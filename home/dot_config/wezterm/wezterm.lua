local wezterm = require 'wezterm'

local config = wezterm.config_builder()

if wezterm.target_triple:find('windows') then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
end
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font_with_fallback {
  'Iosevka',
  'Symbols Nerd Font Mono',
}
-- Already the default, but pinned so a theme or future default cannot
-- introduce translucency.
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = 'Disabled'
config.scrollback_lines = 10000

return config
