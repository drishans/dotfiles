# dOmnix

HP OmniBook Flip Ultra laptop running NixOS with GNOME, encrypted Btrfs,
fingerprint support, sensor integration, and automatic screen rotation.

## Sensor-hub firmware

The Intel Integrated Sensor Hub firmware is machine-specific and is not
redistributed in this repository. Before the first rebuild, copy
`ishC_SI_20260309.bin` from the private backup and add it to the Nix store:

```sh
nix-store --add-fixed sha256 /path/to/ishC_SI_20260309.bin
```

The expected SHA-256 is:

```text
4041198cddf5a712306339de7ec417d46363338f12a5b3a933aed555e72f02b9
```

The host module verifies this hash before using the file. Once a system
generation references the resulting firmware derivation, normal Nix garbage
collection keeps it reachable with that generation.

## Rebuild

From the repository root:

```sh
sudo nixos-rebuild test --flake .#dOmnix
sudo nixos-rebuild switch --flake .#dOmnix
```

## Handy text input

The host enables the NixOS ydotool module, which provides `ydotoold`, the client,
and `YDOTOOL_SOCKET`. The user is in the `ydotool` group so Handy can inject
keyboard input without GNOME's remote-interaction permission prompt.

After rebuilding, log out and back in to pick up the group and environment
changes, then restart Handy. Keep Handy's paste method on **Direct**. It can
automatically detect ydotool; if it selects another tool, press `Ctrl+Shift+D`
in Handy to reveal Debug and select **ydotool** as the typing tool.

This grants applications running as the user persistent keyboard/mouse injection
access through the ydotool socket. It does not disable GNOME's portal permissions
globally.
