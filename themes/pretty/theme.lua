---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local gears = require("gears")
local themes_path = "~/.config/awesome/themes/"

local theme = {}

theme.font          = "Noto Sans 8"

theme.bg_normal     = "#22222288"
theme.bg_focus      = "#4545bb"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = "#15151500"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(0)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.tasklist_bg_focus = "#666666aa"
theme.tasklist_bg_normal = "#444444aa"
theme.tasklist_font     = "Noto Sans 11"
theme.tasklist_plain_task_name = true

theme.taglist_fg_occupied = "#ffffff"
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_font = "Material Icons 17"

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_opacity      = 0.7
theme.notification_font         = "Noto Sans 10"
theme.notification_width        = 300
theme.notification_height       = 80
theme.notification_margin       = 20
theme.notification_border_color = theme.bg_normal

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.hotkeys_font = "Fira Code 11"
theme.hotkeys_description_font = "Fira Code 9"

-- Define the wallpaper to load
theme.wallpaper = themes_path.."pretty/background.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."pretty/layouts/fairh.png"
theme.layout_fairv = themes_path.."pretty/layouts/fairv.png"
theme.layout_floating  = themes_path.."pretty/layouts/floating.png"
theme.layout_magnifier = themes_path.."pretty/layouts/magnifier.png"
theme.layout_max = themes_path.."pretty/layouts/max.png"
theme.layout_fullscreen = themes_path.."pretty/layouts/fullscreen.png"
theme.layout_tilebottom = themes_path.."pretty/layouts/tilebottom.png"
theme.layout_tileleft   = themes_path.."pretty/layouts/tileleft.png"
theme.layout_tile = themes_path.."pretty/layouts/tile.png"
theme.layout_tiletop = themes_path.."pretty/layouts/tiletop.png"
theme.layout_spiral  = themes_path.."pretty/layouts/spiral.png"
theme.layout_dwindle = themes_path.."pretty/layouts/dwindle.png"
theme.layout_cornernw = themes_path.."pretty/layouts/cornernw.png"
theme.layout_cornerne = themes_path.."pretty/layouts/cornerne.png"
theme.layout_cornersw = themes_path.."pretty/layouts/cornersw.png"
theme.layout_cornerse = themes_path.."pretty/layouts/cornerse.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
