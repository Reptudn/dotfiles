local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 20.0
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "JetBrains Darcula"
config.window_background_opacity = 0.3
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.max_fps = 60

config.prefer_egl = true

config.use_fancy_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.window_padding = {
  left = 5,
  right = 5,
  top = 20,
  bottom = 5,
}

-- config.hide_tab_bar_if_only_one_tab = true

local bg_image = os.getenv("HOME") .. "/.config/wezterm/images/blackhole.gif" 

local function is_fullscreen(window)
    local dimensions = window:get_dimensions()
    return dimensions.is_full_screen
end

wezterm.on('window-resized', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if is_fullscreen(window) then
        overrides.window_background_image = bg_image
    else
        overrides.window_background_image = nil
    end
    window:set_config_overrides(overrides)
end)

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
    tabline_a = { ' 🐧' },
    tabline_b = { os.getenv("LOGNAME") },
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

config.default_prog = { "/Users/jkauker/.brew/bin/tmux" }

return config
