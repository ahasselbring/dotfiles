-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.confdir = ("/home/arne/.config/awesome/theme/")
theme.wallpaper = theme.confdir .. "compiling.jpg"
-- }}}

-- {{{ Styles
theme.font      = "Terminus 9"
theme.font_bg   = "Terminus 12"

-- {{{ Colors
theme.fg_normal = "#AAAAAA"
theme.fg_focus  = "#0099CC"
theme.fg_urgent = "#3F3F3F"
theme.bg_normal = "#222222"
theme.bg_focus  = "#1E2320"
theme.bg_urgent = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#535D6C"
theme.border_marked = "#91231C"
-- }}}

theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
theme.taglist_bg_focus   = "#3F3F3F"
theme.taglist_fg_focus   = "#00CCFF"
theme.tasklist_bg_focus  = "#222222"
theme.tasklist_fg_focus  = "#00CCFF"
theme.textbox_widget_as_label_font_color = "#FFFFFF"
theme.textbox_widget_margin_top = 1
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
theme.date_fg = "#EEEEEE"
theme.date_bg = "#777E76"
theme.net_fg = "#FFFFFF"
theme.net_bg = "#C2C2A4"
theme.battery_fg = "#FFFFFF"
theme.battery_bg = "#92B0A0"
theme.fs_fg = "#EEEEEE"
theme.fs_bg = "#D0785D"
theme.volume_fg = "#EEEEEE"
theme.volume_bg = "#4B3B51"
theme.cpu_fg = "#DDDDDD"
theme.cpu_bg = "#4B696B"
theme.mem_fg = "#EEEEEE"
theme.mem_bg = "#777E76"
theme.mail_fg = "#FFFFFF"
theme.mail_bg = "#92B0A0"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "120"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.confdir .. "taglist/squarefz.png"
theme.taglist_squares_unsel = theme.confdir .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.confdir .. "awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.confdir .. "layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "layouts/floating.png"
-- }}}

return theme
