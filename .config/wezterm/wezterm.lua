local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.font = wezterm.font("BlexMono Nerd Font Mono")
config.line_height = 1.2
config.font_size = 16
config.color_scheme = "tokyonight_night"

config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}

config.window_decorations = "TITLE | RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32

config.colors.tab_bar = {
  background = "#16161e",
  active_tab = {
    bg_color = "#7aa2f7",
    fg_color = "#16161e",
    intensity = "Bold",
  },
  inactive_tab = {
    bg_color = "#16161e",
    fg_color = "#565f89",
  },
  inactive_tab_hover = {
    bg_color = "#1a1b26",
    fg_color = "#a9b1d6",
  },
  new_tab = {
    bg_color = "#16161e",
    fg_color = "#565f89",
  },
  new_tab_hover = {
    bg_color = "#16161e",
    fg_color = "#7aa2f7",
  },
}

config.default_cursor_style = "SteadyBar"
config.audible_bell = "Disabled"
-- config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
-- config.initial_cols = 220
-- config.initial_rows = 50
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
-- config.scrollback_lines = 10000

-- Key bindings
config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Word movement
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',
  },
  -- Pane navigation
  { key = 'h', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Down' },
  -- Delete to start of line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendString '\x15',
  },
  -- Line start/end
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendString '\x01',
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendString '\x05',
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.SendString 'clear\n',
  },
  {
    key = 'e',
    mods = 'CMD|SHIFT',
    action = wezterm.action.PromptInputLine {
      description = 'Rename tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

return config
