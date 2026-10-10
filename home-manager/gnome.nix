# GNOME preferences and extensions. Imported only by GNOME hosts.
{ pkgs, ... }:
let
  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  # Wiggly draws its magnified cursor from an image, so recolor Bibata's arrow
  # source the same way its Modern Classic build does.
  wigglyCursor = pkgs.runCommand "bibata-modern-classic-left-ptr.svg" { } ''
    sed -e 's/#00FF00/#000000/g' -e 's/#0000FF/#FFFFFF/g' \
      ${pkgs.bibata-cursors.src}/svg/modern/left_ptr.svg > $out
  '';
in
{
  # Also sets the default Xcursor theme, so XWayland apps such as WezTerm match.
  home.pointerCursor = cursor // {
    enable = true;
    # XCURSOR_SIZE for XWayland apps such as WezTerm, doubled for the 2x display.
    x11.size = 48;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = cursor.name;
      cursor-size = cursor.size;
    };
    "org/gnome/mutter" = {
      auto-maximize = false;
      center-new-windows = true;
    };
    # Free Super+V from the notification list (Super+M still opens it) for Clipboard Indicator.
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>m" ];
    };
    "org/gnome/shell/extensions/wiggly" = {
      cursor-path = "${wigglyCursor}";
    };
    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = [ "<Super>v" ];
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.gjs-osk; }
      { package = pkgs.gnomeExtensions.wiggly; }
      { package = pkgs.gnomeExtensions.clipboard-indicator; }
    ];
  };
}
