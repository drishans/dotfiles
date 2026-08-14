local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font_with_fallback {
  'PragmataPro Mono',
  'Symbols Nerd Font Mono',
}
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = 'Disabled'
config.scrollback_lines = 10000

return config
