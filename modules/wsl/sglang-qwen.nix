{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.sglang-qwen;
  docker = lib.getExe pkgs.docker;

  runContainer = pkgs.writeShellScript "run-sglang-qwen" ''
    set -euo pipefail

    exec ${docker} run --rm \
      --name sglang-qwen \
      --device=nvidia.com/gpu=all \
      --shm-size=16g \
      --publish 127.0.0.1:${toString cfg.port}:30000 \
      --mount type=bind,src=${lib.escapeShellArg cfg.modelPath},dst=/model,readonly \
      --mount type=bind,src=/var/cache/sglang-qwen,dst=/root/.cache \
      --env HF_HUB_OFFLINE=1 \
      --env TRANSFORMERS_OFFLINE=1 \
      ${lib.escapeShellArg cfg.image} \
      sglang serve \
        --trust-remote-code \
        --model-path /model \
        --served-model-name ${lib.escapeShellArg cfg.servedModelName} \
        --language-only \
        --mm-feature-transport cpu \
        --context-length ${toString cfg.contextLength} \
        --kv-cache-dtype fp8_e4m3 \
        --mem-fraction-static ${toString cfg.memFractionStatic} \
        --attention-backend flashinfer \
        --chunked-prefill-size 2048 \
        --max-total-tokens ${toString cfg.contextLength} \
        --max-running-requests 1 \
        --max-mamba-cache-size 4 \
        --mamba-radix-cache-strategy extra_buffer_lazy \
        --mamba-ssm-dtype float32 \
        --cuda-graph-backend-decode disabled \
        --cuda-graph-backend-prefill disabled \
        --reasoning-parser qwen3 \
        --tool-call-parser qwen3_coder \
        --host 0.0.0.0 \
        --port 30000 \
        ${lib.escapeShellArgs cfg.extraArgs}
  '';

  control = pkgs.writeShellApplication {
    name = "sglang-qwen";
    runtimeInputs = [
      pkgs.curl
      pkgs.docker
      pkgs.systemd
    ];
    text = ''
      usage() {
        echo "usage: sglang-qwen {start|stop|restart|status|logs|pull|test}"
      }

      case "''${1:-}" in
        start|stop|restart|status)
          exec sudo systemctl "$1" sglang-qwen.service
          ;;
        logs)
          exec sudo journalctl --unit=sglang-qwen.service --follow --lines=100
          ;;
        pull)
          exec sudo docker pull ${lib.escapeShellArg cfg.image}
          ;;
        test)
          exec curl --fail-with-body http://127.0.0.1:${toString cfg.port}/v1/chat/completions \
            -H 'Content-Type: application/json' \
            -d '${
        builtins.toJSON {
          model = cfg.servedModelName;
          messages = [
            {
              role = "user";
              content = "Reply with exactly: SGLang is ready";
            }
          ];
          max_tokens = 64;
          temperature = 0;
          chat_template_kwargs.enable_thinking = false;
        }
      }'
          ;;
        *)
          usage
          exit 2
          ;;
      esac
    '';
  };
in {
  options.services.sglang-qwen = {
    enable =
      lib.mkEnableOption "the local Qwen3.8 SGLang container"
      // {
        default = true;
      };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start the large model automatically when NixOS-WSL starts.";
    };

    image = lib.mkOption {
      type = lib.types.str;
      # amd64 digest of the Qwen3.8 image used by the official SGLang cookbook.
      default = "lmsysorg/sglang:qwen38-27b@sha256:506525a5907ea22c9d445afb7c03603959b912de034d86915cf17da814f1a124";
      description = "Pinned SGLang image containing Qwen3.8 support.";
    };

    modelPath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/d/AI/models/qwen/Qwen3.8-27B-NVFP4";
      description = "Host path to the local Hugging Face checkpoint.";
    };

    servedModelName = lib.mkOption {
      type = lib.types.str;
      default = "qwen3.8-27b";
      description = "Model id exposed by the OpenAI-compatible API.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 30000;
      description = "Host API port, bound only to localhost.";
    };

    contextLength = lib.mkOption {
      type = lib.types.ints.positive;
      default = 32768;
      description = "Maximum context exposed by this single-RTX-5090 profile.";
    };

    memFractionStatic = lib.mkOption {
      type = lib.types.float;
      default = 0.94;
      description = "SGLang static GPU-memory fraction.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional arguments appended to `sglang serve`.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [control];

    systemd.services.sglang-qwen = {
      description = "SGLang OpenAI server for local Qwen3.8-27B NVFP4";
      wantedBy = lib.optional cfg.autoStart "multi-user.target";
      after = [
        "docker.service"
        "nvidia-container-toolkit-cdi-generator.service"
      ];
      requires = [
        "docker.service"
        "nvidia-container-toolkit-cdi-generator.service"
      ];

      preStart = ''
        if [[ ! -r ${lib.escapeShellArg cfg.modelPath}/config.json ]]; then
          echo "Missing model: ${cfg.modelPath}/config.json" >&2
          exit 1
        fi
        ${docker} rm --force sglang-qwen >/dev/null 2>&1 || true
      '';

      serviceConfig = {
        ExecStart = runContainer;
        ExecStop = "-${docker} stop --timeout 120 sglang-qwen";
        Restart = "on-failure";
        RestartSec = 10;
        TimeoutStartSec = "infinity";
        TimeoutStopSec = 180;
        CacheDirectory = "sglang-qwen";
      };
    };
  };
}
