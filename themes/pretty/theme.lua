---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local gears = require("gears")
local themes_path = gears.filesystem.get_xdg_config_home().."/awesome/themes/"

local theme = {}

theme.font          = "Noto Sans 15"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#4545bb"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

-- theme.bg_systray    = "#000000"

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(7)
theme.gap_single_client = false
theme.border_width  = dpi(0)
theme.border_color_normal = "#00000000"
theme.border_color_active = "#99999977"

theme.tasklist_bg_focus = "#ffffff"
theme.tasklist_shape = gears.shape.rounded_rect

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

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.hotkeys_font = "Fira Code 11"
theme.hotkeys_modifiers_fg = "#dddddd"
theme.hotkeys_description_font = "Fira Code 9"

-- Define the wallpaper to load
theme.wallpaper = themes_path.."pretty/background.png"

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

theme.icon_tag = {
    themes_path.."pretty/icons/mesg.png",
    themes_path.."pretty/icons/term.png",
    themes_path.."pretty/icons/prog.png",
    themes_path.."pretty/icons/web.png",
    themes_path.."pretty/icons/mail.png",
    themes_path.."pretty/icons/apps.png",
    themes_path.."pretty/icons/games.png",
    themes_path.."pretty/icons/write.png",
    themes_path.."pretty/icons/admin.png"
}
theme.icon_sensors = themes_path.."pretty/icons/sensors.png"
theme.icon_backlight = themes_path.."pretty/icons/backlight.png"
theme.icon_volumeicon = themes_path.."pretty/icons/volumeicon.png"
theme.icon_battery = themes_path.."pretty/icons/battery.png"
theme.icon_battery_empty = themes_path.."pretty/icons/battery_empty.png"
theme.icon_battery_charge = themes_path.."pretty/icons/battery_charge.png"
theme.icon_battery_full = themes_path.."pretty/icons/battery_full.png"
theme.icon_power = themes_path.."pretty/icons/power.png"
theme.icon_add = themes_path.."pretty/icons/add.png"
theme.icon_keyboard = themes_path.."pretty/icons/keyboard.png"


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Tela-dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
