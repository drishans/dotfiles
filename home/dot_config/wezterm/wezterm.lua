local wezterm = require("wezterm")

local config = wezterm.config_builder()

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font_with_fallback({
	"Iosevka",
	"Symbols Nerd Font Mono",
})

config.window_background_opacity = 0.90
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"
config.scrollback_lines = 10000

return config
