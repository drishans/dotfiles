# dOmnix quirks

- **Small cursor in WezTerm.** WezTerm runs under XWayland (`enable_wayland = false`, for touch input), so its cursor is drawn at half size on the 2x display. Raising `XCURSOR_SIZE` didn't help. To try later: run WezTerm on Wayland and check whether touch input works.
- **Copyous crashed GNOME Shell.** Its libgda/SQLite history database segfaulted gnome-shell, which logged the session out. After repeated crashes, GNOME sets `disable-user-extensions`, so all extensions turn off, and re-enabling them crashed it again. Replaced with Clipboard Indicator.
- **Keyboard turns off when the screen rotates.** Turning the laptop sideways, for example in bed, puts it into tablet mode and disables the keyboard.
