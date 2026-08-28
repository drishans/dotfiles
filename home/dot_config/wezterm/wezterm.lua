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

-- Try values live without a rebuild:
--   wezterm --config window_background_opacity=0.85
config.window_background_opacity = 0.90
-- Keep the window chrome and terminal content separate: one-tab sessions do
-- not need a tab bar, while RESIZE retains a clean, resizable window frame.
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 120
config.initial_rows = 36
config.audible_bell = "Disabled"
config.scrollback_lines = 10000

return config
