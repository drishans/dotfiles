# dwslnix

NixOS-WSL host dedicated to local model serving. It provides Docker, NVIDIA
CDI support, Tailscale, and the SGLang Qwen service while omitting interactive
agent packages.

## Rebuild

From the repository root:

```sh
sudo nixos-rebuild test --flake .#dwslnix
sudo nixos-rebuild switch --flake .#dwslnix
```

The model path and serving profile are configured in
[`modules/wsl/sglang-qwen.nix`](../../modules/wsl/sglang-qwen.nix).
