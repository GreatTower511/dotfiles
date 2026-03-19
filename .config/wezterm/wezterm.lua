local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 14.0
config.use_ime = true
config.window_background_opacity = 0.65
config.macos_window_background_blur = 5
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false


config.window_background_gradient = {
  colors = { "#000000" },
}

config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.colors = {
  tab_bar = {
    background = "#000000",
    inactive_tab_edge = "none",
    active_tab = {
      bg_color = "#00ff00",
      fg_color = "#FFFFFF",
    },
    inactive_tab = {
      bg_color = "#1a1a1a",
      fg_color = "#FFFFFF",
    },
    inactive_tab_hover = {
      bg_color = "#2a2a2a",
      fg_color = "#FFFFFF",
    },
    new_tab = {
      bg_color = "#000000",
      fg_color = "#808080",
    },
    new_tab_hover = {
      bg_color = "#333333",
      fg_color = "#FFFFFF",
    },
  },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#1a1a1a"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#00ff00"
    foreground = "#FFFFFF"
  end

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)

config.keys = {
  {
      key = "+",
      mods = "CMD|SHIFT",
      action = wezterm.action.IncreaseFontSize,
  },
  {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
      key = "d",
      mods = "CMD|SHIFT",
      action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } },
  },
  {
      key = "d",
      mods = "CMD",
      action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
  },
  {
      key = 'h',
      mods = 'CMD|ALT',
      action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
      key = 'j',
      mods = 'CMD|ALT',
      action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
      key = 'k',
      mods = 'CMD|ALT',
      action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
      key = 'l',
      mods = 'CMD|ALT',
      action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'V', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
}

return config
