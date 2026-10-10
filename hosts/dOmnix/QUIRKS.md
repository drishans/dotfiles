# dOmnix quirks

## Bugs

Broken behavior with no fix.

- **Keyboard turns off when the screen rotates.** Turning the laptop sideways, for example in bed, puts it into tablet mode and disables the keyboard. The firmware's tablet-mode switch (`Intel HID switches`, intel-hid) turns on when the laptop is on its side, likely because the hinge angle can't be read from gravity then. libinput then turns off the internal keyboard as it would for a real fold. The `HP WMI hotkeys` tablet switch never changes, even on a real fold, so it can't stand in for the Intel switch. The firmware also cuts the keyboard off itself (no key events reach Linux), so this can't be fixed in Linux. Ignoring the switch in libinput didn't bring the keyboard back and broke auto-rotation. Still happens on BIOS W75 01.05.00 (2026-04-13).

## Annoyances

Cosmetic or minor issues.

- **Small cursor in WezTerm.** WezTerm runs under XWayland (see Workarounds), so its cursor is drawn at half size on the 2x display. Raising `XCURSOR_SIZE` didn't help. To try later: run WezTerm on Wayland and check whether touch input works.
- **First WezTerm window after a restart is misplaced.** It has a gap on the left and top but runs to the right and bottom edges. Likely WezTerm (XWayland) opens before GNOME publishes `Xft.dpi`, then grows when it sees the 2x scale. Doesn't happen after a re-login, and later windows are fine.

## Workarounds

Config that exists only to get around a problem.

- **WezTerm runs on X11.** `enable_wayland = false` in `config/wezterm/wezterm.lua`, because touch input doesn't work in WezTerm on Wayland.
- **Each WezTerm launcher window is its own process.** The desktop entry passes `--always-new-process` (`home-manager/shell.nix`), because windows that share a process slow each other down while one runs a busy TUI such as btop.
- **xdg-terminal-exec is enabled.** GNOME 50 opens terminals through `xdg-terminal-exec`, which isn't installed by default, so "open a terminal" did nothing without it (`home-manager/shell.nix`).
- **Mute LED is driven by a user service.** The speaker-mute LED doesn't follow the default audio output by itself, so the `mute-led` service in `modules/hardware/dOmnix.nix` sets it from PipeWire's mute state.
- **Handy types through ydotool.** This avoids GNOME's remote-interaction permission prompt on Wayland. See the Handy section in `README.md`.

## Resolved

Kept in case they come back.

- **Copyous crashed GNOME Shell.** Its libgda/SQLite history database segfaulted gnome-shell, which logged the session out. After repeated crashes, GNOME sets `disable-user-extensions`, so all extensions turn off, and re-enabling them crashed it again. Replaced with Clipboard Indicator.
