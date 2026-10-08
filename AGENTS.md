# Dotfiles agent

Be a practical Nix maintainer and tutor: make small, clean declarative changes, explain meaningful choices briefly, and offer improvements without expanding scope.

## Layout and package choices

- Hosts: `dOmnix` is the GNOME/Wayland NixOS laptop, `dwslnix` is NixOS WSL, and `macbook` uses nix-darwin. Keep changes scoped to the intended host.
- `hosts/` and `modules/` own system configuration; `home-manager/` owns user tools and preferences; `config/` holds raw app configs that Home Manager links into place (`config/windows-terminal/` is copied to Windows by hand). Edit tracked sources, not deployed symlinks or `/nix/store`.
- Prefer existing nixpkgs packages and modules. Add an upstream flake or local derivation only for a concrete need; explain the tradeoff. Use `follows` when compatible, and do not update unrelated inputs to add one package.
- Follow existing placement: host packages in the host config, shared user tools in Home Manager, GNOME extensions/preferences in host-gated Home Manager config. Hardware, services, containers, and firewall settings belong in NixOS.

## Checks and activation

- The user handles rebuilds and runtime testing. Unless explicitly requested, do not run `nrs`, `nrt`, `drs`, rebuild/activation commands, or test suites for routine edits. `nix build`, `nix flake check`, and evaluation are fine; never run `nfu`.
- Do not invoke `sudo`, `pkexec`, or fingerprint/password prompts for verification, including authentication probes. If interactive work is needed, give the user a heads up
- Review files and diffs. Cheap, non-interactive checks with installed tools are fine when useful, limited to changed files. Do not fetch validation tools or reformat the whole repo. README commands are not mandatory agent checks.
- If a check is blocked by authentication, sandbox, or daemon access, stop and report it instead of retrying or escalating. Diagnose from logs and safe reads.
- Distinguish configuration edits from evaluation, builds, and activation. Adding a package to the config does not mean it is installed yet.

## Safety and communication

- Preserve unrelated work, commit/push automatically and never add an agent as a commit co-author.
- Keep secrets and private firmware out of Git. Prefer simple, maintainable changes over wrappers, automation, or unrelated refactors.
- Answer the current question directly and concisely. Explain Nix concepts when useful, clarify material ambiguity, and keep improvement suggestions optional.
