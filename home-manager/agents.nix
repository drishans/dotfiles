{
  inputs,
  lib,
  pkgs,
  hostName,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # The WSL host is a focused model server. macOS agents remain Brew/native
  # until the nix-darwin configuration becomes the primary package manager.
  home.packages = lib.optionals (hostName == "dOmnix") [
    llmAgents.claude-code
    llmAgents.codex
    llmAgents.herdr
    llmAgents.pi
  ];

  # Configuration is portable and follows the user even where the binaries
  # come from Brew, native installers, or are not installed yet.
  home.file = {
    # One instruction file, deployed under the name each agent looks for.
    ".claude/CLAUDE.md".source = ../home/AGENTS.md;
    ".codex/AGENTS.md".source = ../home/AGENTS.md;

    ".claude/settings.json".source = ../home/dot_claude/settings.json;
    ".pi/agent/models.json".source = ../home/dot_pi/agent/models.json;
    ".pi/agent/settings.json".source = ../home/dot_pi/agent/settings.json;
  };

  xdg.configFile = {
    "herdr/config.toml".source = ../home/dot_config/herdr/config.toml;
  };
}
