# GNOME preferences and extensions. Imported only by GNOME hosts.
{ pkgs, ... }:
let
  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
in
{
  # Also sets the default Xcursor theme, so XWayland apps such as WezTerm match.
  home.pointerCursor = cursor;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = cursor.name;
      cursor-size = cursor.size;
    };
    "org/gnome/mutter" = {
      auto-maximize = false;
      center-new-windows = true;
    };
    # Free Super+V from the notification list (Super+M still opens it) for Copyous.
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>m" ];
    };
    "org/gnome/shell/extensions/copyous" = {
      open-clipboard-dialog-shortcut = [ "<Super>v" ];
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.gjs-osk; }
      { package = pkgs.gnomeExtensions.copyous; }
    ];
  };
}
