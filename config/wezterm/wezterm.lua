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
-- Use XWayland so touch input works without a special launch command.
config.enable_wayland = false
-- The OpenGL renderer stalls under XWayland once several windows share one
-- GUI process, slowing every window. WebGpu (Vulkan) does not.
config.front_end = "WebGpu"
-- Keep the window chrome and terminal content separate: one-tab sessions do
-- not need a tab bar, while RESIZE retains a clean, resizable window frame.
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 169
config.initial_rows = 38
config.audible_bell = "Disabled"
config.scrollback_lines = 10000

return config
