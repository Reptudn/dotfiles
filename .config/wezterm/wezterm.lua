local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 20.0
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "JetBrains Darcula"
config.window_background_opacity = 0.5
config.macos_window_background_blur = 42
config.window_decorations = "RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 60

config.prefer_egl = true

config.use_fancy_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
}

-- Define the background image path
local bg_image = os.getenv("HOME") .. "/.config/wezterm/images/animated.gif"

-- Function to check if window is fullscreen
local function is_fullscreen(window)
    local dimensions = window:get_dimensions()
    return dimensions.is_full_screen
end

-- Event handler for window resizing
wezterm.on('window-resized', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if is_fullscreen(window) then
        overrides.window_background_image = bg_image
    else
        overrides.window_background_image = nil
    end
    window:set_config_overrides(overrides)
end)

-- Initial configuration (background image not set)
config.window_background_image = nil

config.tab_bar_at_bottom = true

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { ' 🤓 ' },
    tabline_b = { '' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu'},
    tabline_y = { 'datetime' },
    tabline_z = { 'hostname' },
  },
  extensions = {},
})

tabline.apply_to_config(config)

return config
