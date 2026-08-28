# macbook

Apple Silicon nix-darwin host. Nix owns system defaults and Home Manager
dotfiles, while Homebrew can continue managing native applications.

Confirm the local username, home directory, architecture, and hostname before
the first activation.

## Rebuild

From the repository root:

```sh
# First activation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#macbook

# Later activations
sudo darwin-rebuild switch --flake .#macbook
```
