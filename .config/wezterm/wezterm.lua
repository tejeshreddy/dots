local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.font = wezterm.font("BlexMono Nerd Font Mono")
config.line_height = 1.2
config.font_size = 15.5
config.color_scheme = "Dracula"

config.colors = {
  cursor_bg = "#f8f8f2",
  cursor_border = "#f8f8f2",
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
  { key = 'LeftArrow', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CMD|OPT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'PageUp', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(-1) },
  { key = 'PageDown', mods = 'CTRL|SHIFT', action = wezterm.action.MoveTabRelative(1) },
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'f', mods = 'CMD|SHIFT', action = wezterm.action.ShowTabNavigator },
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
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendString '\x1b[13;2u',
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

local cpu_samples = {}

wezterm.on("update-right-status", function(window, pane)
  local ok, err = pcall(function()
    local cwd = pane:get_current_working_dir()
    local path = cwd and cwd.file_path or ""
    path = path:gsub(os.getenv("HOME"), "~")

    -- CPU
    local cpu_ok, cpu_out = wezterm.run_child_process({ "sh", "-c",
      "ps -A -o %cpu | awk 'NR>1{s+=$1} END{printf \"%.0f\",s}'"
    })
    local ncpu_ok, ncpu_out = wezterm.run_child_process({ "sysctl", "-n", "hw.logicalcpu" })
    local ncpu = ncpu_ok and (tonumber(ncpu_out) or 1) or 1
    local sample = cpu_ok and math.floor((tonumber(cpu_out) or 0) / ncpu) or 0

    local now = os.time()
    table.insert(cpu_samples, { t = now, v = sample })
    local kept, sum = {}, 0
    for _, e in ipairs(cpu_samples) do
      if now - e.t <= 10 then table.insert(kept, e); sum = sum + e.v end
    end
    cpu_samples = kept
    local pct = #kept > 0 and math.floor(sum / #kept) or 0
    local cpu_color = pct > 80 and "#f7768e" or pct > 50 and "#e0af68" or "#9ece6a"
    local bar = ({"▁","▂","▃","▄","▅","▆","▇","█"})[math.max(1, math.min(8, math.floor(pct/100*8)+1))]

    window:set_right_status(wezterm.format({
      { Foreground = { Color = cpu_color } },
      { Text = " CPU " .. bar .. " " .. pct .. "% " },
    }))
  end)
  if not ok then
    window:set_right_status("error: " .. tostring(err))
  end
end)

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
