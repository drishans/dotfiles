# dOmnix quirks

## Bugs

Broken behavior with no fix.

- **Keyboard turns off when the screen rotates.** Turning the laptop sideways, for example in bed, puts it into tablet mode and disables the keyboard. The firmware's tablet-mode switch (`Intel HID switches`, intel-hid) turns on when the laptop is on its side, likely because the hinge angle can't be read from gravity then. libinput then turns off the internal keyboard as it would for a real fold. The `HP WMI hotkeys` tablet switch never changes, even on a real fold, so it can't stand in for the Intel switch. The firmware also cuts the keyboard off itself (no key events reach Linux), so this can't be fixed in Linux. Ignoring the switch in libinput didn't bring the keyboard back and broke auto-rotation. Still happens on BIOS W75 01.05.00 (2026-04-13).

## Annoyances

Cosmetic or minor issues.

- **Small cursor in WezTerm.** WezTerm runs under XWayland (`enable_wayland = false`, for touch input), so its cursor is drawn at half size on the 2x display. Raising `XCURSOR_SIZE` didn't help. To try later: run WezTerm on Wayland and check whether touch input works.
- **First WezTerm window after a restart is misplaced.** It has a gap on the left and top but runs to the right and bottom edges. Likely WezTerm (XWayland) opens before GNOME publishes `Xft.dpi`, then grows when it sees the 2x scale. Doesn't happen after a re-login, and later windows are fine.

## Resolved

Kept in case they come back.

- **Copyous crashed GNOME Shell.** Its libgda/SQLite history database segfaulted gnome-shell, which logged the session out. After repeated crashes, GNOME sets `disable-user-extensions`, so all extensions turn off, and re-enabling them crashed it again. Replaced with Clipboard Indicator.
