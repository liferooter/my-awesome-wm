-- vim:fileencoding=utf-8:ft=lua:foldmethod=marker

-- {{{ Imports
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- }}}

-- {{{ Debug
local naughty = require("naughty")
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Nice

-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/pretty/theme.lua")
local nice = require("nice")
nice{
  floating_color = "#0077ff",
  sticky_color = "#ff0077",
  ontop_color = "#77ff00",
  titlebar_items = {
    left = {"close", "minimize", "maximize"},
    middle = "title",
    right = {"floating"},
  }
}

awesome.set_preferred_icon_size(30)
-- }}}

-- {{{ Defaults

-- This is used later as the default terminal and editor to run.
terminal = "kitty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  awful.layout.suit.corner.ne,
  awful.layout.suit.corner.sw,
  awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Widgets
-- Create a textclock widget
mytextclock = wibox.widget.textclock("<b>%H\n%M</b>")
-- {{{ Sensors
mysensors = wibox.container.radialprogressbar()
mysensors.border_color = "#222222"
mysensors.color = "#ffffff"
mysensors.max_value = 70
mysensors_icon = wibox.widget{
    widget = wibox.widget.imagebox,
    image = beautiful.icon_sensors,
} 
mysensors:setup{
  widget = wibox.container.place,
  mysensors_icon
}

mysensors_label = wibox.widget{
  widget = wibox.widget.textbox,
  font = "Radio Space Bitmap 13",
  fg = "#ffffff"
}

function update_sensors_icon ()
    awful.spawn.easy_async_with_shell(
      "bash -c \"sensors | grep 'Core 0' | cut -d' ' -f10 | tr -d '+' | cut -d'.' -f1\"",
      function(out)
        mysensors.value = tonumber(out) - 20
        mysensors_label.text = tostring(tonumber(out)).."°C"
      end
    )
end
-- }}}
-- {{{ Battery
mybattery_icon = wibox.widget{
  widget = wibox.widget.imagebox,
  image = beautiful.icon_battery
}
mybattery = wibox.container.radialprogressbar()
mybattery.border_color = "#222222"
mybattery.color = "#ffffff"
mybattery.max_value = 100
mybattery:setup{
  widget = wibox.container.place,
  mybattery_icon
}

mybattery_label = wibox.widget{
  widget = wibox.widget.textbox,
  font = "Radio Space Bitmap 13",
  fg = "#ffffff"
}

function update_battery_icon()
  awful.spawn.easy_async_with_shell(
    "cat /sys/class/power_supply/BAT0/status",
    function(out)
      if string.find(out, "Full") or string.find(out, "Unknown")
      then
        mybattery.color = "#4545dd"
        mybattery_icon.image = beautiful.icon_battery_full
      elseif string.find(out, "Charging") then
        mybattery.color = "#4545dd"
        mybattery_icon.image = beautiful.icon_battery_charge
      else
        mybattery.color = "#ffffff"
        mybattery_icon.image = beautiful.icon_battery
      end
    end
  )
  awful.spawn.easy_async_with_shell(
    "cat /sys/class/power_supply/BAT0/capacity",
    function(out)
      mybattery_label.text = tostring(tonumber(out)).."%"
      mybattery.value = tonumber(out)
      if tonumber(out) <= 15
      then
        mybattery_icon.image = beautiful.icon_battery_empty
      end
    end
  )
end
-- }}}
-- {{{ Backlight
mybacklight_icon = wibox.widget{
  widget = wibox.widget.imagebox,
  image = beautiful.icon_backlight
}
mybacklight = wibox.container.radialprogressbar()
mybacklight.border_color = "#222222"
mybacklight.color = "#ffffff"
mybacklight.max_value = 100
mybacklight:setup{
  widget = wibox.container.place,
  buttons = gears.table.join(
    awful.button(
      {}, 1,
      function ()
        awful.spawn("light -S 100")
        update_backlight_icon()
      end
    ),
    awful.button(
      {}, 4,
      function ()
        awful.spawn("light -U 10")
        update_backlight_icon()
      end
    ),
    awful.button(
      {}, 5,
      function ()
        awful.spawn("light -A 10")
        update_backlight_icon()
      end
    )
  ),
  mybacklight_icon
}

mybacklight_label = wibox.widget{
  widget = wibox.widget.textbox,
  font = "Radio Space Bitmap 13",
  fg = "#ffffff"
}

function update_backlight_icon ()
  awful.spawn.easy_async_with_shell(
    "bash -c 'xbacklight | cut -d\".\" -f1'",
    function(out)
      mybacklight.value = tonumber(out)
      mybacklight_label.text = tostring(tonumber(out)).."%"
    end
  )
end
-- }}}
-- {{{ Volume
myvolumeicon_icon = wibox.widget{
  widget = wibox.widget.imagebox,
  image = beautiful.icon_volumeicon
}
myvolumeicon = wibox.container.radialprogressbar()
myvolumeicon.border_color = "#222222"
myvolumeicon.color = "#ffffff"
myvolumeicon.max_value = 100
myvolumeicon:setup{
  widget = wibox.container.place,
  buttons = gears.table.join(
    awful.button(
      {}, 1,
      function ()
        awful.spawn("amixer set Master toggle")
        update_volume_icon()
      end
    ),
    awful.button(
      {}, 2,
      function ()
        awful.spawn("amixer set Master 100%")
        update_volume_icon()
      end
    ),
    awful.button(
      {}, 4,
      function ()
        awful.spawn("amixer set Master 5%-")
        update_volume_icon()
      end
    ),
    awful.button(
      {}, 5,
      function ()
        awful.spawn("amixer set Master 5%+")
        update_volume_icon()
      end
    )
  ),
  myvolumeicon_icon
}

myvolumeicon_label = wibox.widget{
  widget = wibox.widget.textbox,
  font = "Radio Space Bitmap 13",
  fg = "#ffffff"
}

function update_volume_icon ()
  awful.spawn.easy_async_with_shell(
    "bash -c 'amixer | grep Master -A 6 | tail -n 1 | grep \\'\\[on\\]\\' | cut -d\"[\" -f2 | tr -d \"%]\"'",
    function(out)
      if tonumber(out) == nil
      then
        myvolumeicon.color = "#666666"
        out = "100"
      else
        myvolumeicon.color = "#ffffff"
      end
      if tonumber(out) > 100
      then
        out = tostring(100)
        awful.spawn("amixer set Master 100%")
      end
      myvolumeicon_label.text = tostring(tonumber(out) or 0).."%"
      myvolumeicon.value = tonumber(out)
    end
  )
end

gears.timer{
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function ()
    update_battery_icon()
    update_backlight_icon()
    update_volume_icon()
    update_sensors_icon()
  end
}

--- }}}

-- {{{ Taglist buttons
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
-- }}}
-- {{{ Tasklist buttons
local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal(
          "request::activate",
          "tasklist",
          {raise = true}
        )
        awful.client.jumpto(c)
      end
  end),
  awful.button({ }, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
end))
-- }}}
-- {{{ Wallpaper
local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
-- }}}
-- {{{ Per-screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "MESG", "TERM", "PROG", "WEB", "MAIL", "APPS", "GAMES", "WRITE", "ADMIN" }, s, awful.layout.suit.tile)

    s.mysystray = wibox.widget.systray{
        base_size     = 40,
        forced_width = 40,
        reverse = true
    }
    s.mysystray:set_horizontal(false)
    if s.geometry.x == 0 and s.geometry.y == 0
        then
            s.mywidget_container = wibox.widget{
                widget = wibox.container.margin,
                left = 10,
                right = 10,
                bottom = 10,
                {
                    widget = wibox.container.background,
                    shape = gears.shape.rounded_rect,
                    bg = beautiful.bg_normal,
                    {
                        widget = wibox.container.margin,
                        top = 15,
                        bottom = 15,
                        left = 2,
                        s.mysystray
                    }
                }
            }
        else
            s.mywidget_container = nil
        end

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox{
      screen = s,
      buttons = {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
      },
      forced_height = 40,
      forced_width = 40,
    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      layout   = wibox.layout.fixed.vertical,
      widget_template = {
        {
          id = 'icon',
          widget = wibox.widget.imagebox,
          forced_height = 40,
          forced_width = 40,
          image = beautiful.icon_tag[1]
        },
        id     = 'background_role',
        widget = wibox.container.background,
        create_callback = function (self, t, index, tags)
          self:get_children_by_id('icon')[1].image = beautiful.icon_tag[index]
          if not t:clients()[1]
          then
            self:get_children_by_id('icon')[1].opacity = 0.5
          else
            self:get_children_by_id('icon')[1].opacity = 1
          end
        end,
        update_callback = function (self, t, index, tags)
          if not t:clients()[1]
          then
            self:get_children_by_id('icon')[1].opacity = 0.5
          else
            self:get_children_by_id('icon')[1].opacity = 1
          end
        end
      },
      buttons = taglist_buttons,
    }

    s.mytasklist = awful.widget.tasklist {
      screen   = s,
      filter   = awful.widget.tasklist.filter.alltags,
      buttons  = tasklist_buttons,
      layout   = {
        spacing = 1,
        layout  = wibox.layout.fixed.vertical
      },
      -- Notice that there is *NO* wibox.wibox prefix, it is a template,
      -- not a widget instance.
      widget_template = {
        {
          {
            widget = wibox.container.margin,
            margins = 1,
            awful.widget.clienticon
          },
          widget = wibox.container.background,
          id = "background_role",
        },
        widget = wibox.container.margin,
        margins = 1
      }
    }

    local height = s.geometry.y + s.geometry.height
    local width = s.geometry.x

    awful.popup{
      widget = mysensors_label,
      bg = "#00000000",
      preferred_positions = "right",
      x = width + 80,
      y = height - 280,
      type = 'dock',
      ontop = false,
      screen = s
    }

    awful.popup{
      widget = mybattery_label,
      bg = "#00000000",
      preferred_positions = "right",
      x = width + 80,
      y = height - 130,
      type = 'dock',
      ontop = false,
      screen = s
    }
    
    awful.popup{
      widget = mybacklight_label,
      bg = "#00000000",
      preferred_positions = "right",
      x = width + 80,
      y = height - 230,
      type = 'dock',
      ontop = false,
      screen = s
    }

    awful.popup{
      widget = myvolumeicon_label,
      bg = "#00000000",
      preferred_positions = "right",
      x = width + 80,
      y = height - 180,
      type = 'dock',
      ontop = false,
      screen = s
    }

    -- Create the wibox
    
    s.mywibox_left = awful.wibar({ position = "left", screen = s, width = 60, bg = "#00000000", type = "dock" })
    s.mywibox_right = awful.wibar({ position = "right", screen = s, width = 60, bg = "#00000000", type = "dock" })

    s.mywibox_left:setup{
      widget = wibox.container.background(),
      {
        layout = wibox.layout.align.vertical,
        {
          layout = wibox.layout.fixed.vertical,
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            top = 10,
            s.mylayoutbox,
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            top = 10,
            {
              widget = wibox.container.background,
              shape = gears.shape.rounded_rect,
              bg = beautiful.bg_normal,
              s.mytaglist,
            }
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            top = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.rounded_rect,
              forced_height = 50,
              {
                widget = wibox.container.place,
                awful.widget.keyboardlayout
              }
            }
          }
        },
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            bottom = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.circle,
              mysensors
            }
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            bottom = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.circle,
              mybacklight
            }
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            bottom = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.circle,
              myvolumeicon
            }
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            bottom = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.circle,
              mybattery
            }
          },
          {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            bottom = 10,
            {
              widget = wibox.container.background,
              bg = beautiful.bg_normal,
              shape = gears.shape.rounded_rect,
              forced_height = 80,
              {
                widget = wibox.container.place,
                mytextclock
              }
            }
          }
        }
      }
    }

    s.mywibox_right:setup{
      widget = wibox.container.background(),
      {
        layout = wibox.layout.align.vertical,
        {
          layout = wibox.layout.fixed.vertical,
          {
            widget = wibox.container.margin,
            top = 10,
            right = 10,
            left = 10,
            {
              widget = wibox.container.background,
              shape = gears.shape.rounded_rect,
              bg = beautiful.bg_normal,
              height = 40,
              width = 40,
              {
                widget = wibox.widget.imagebox,
                image = beautiful.icon_power,
                buttons = gears.table.join({
                    awful.button({}, 1,
                      function ()
                        awful.spawn.with_shell("~/.config/awesome/bin/power.sh")
                      end
                    )
                }),
              }
            },
          },
          {
            widget = wibox.container.margin,
            top = 10,
            right = 10,
            left = 10,
            {
              widget = wibox.container.background,
              shape = gears.shape.rounded_rect,
              bg = beautiful.bg_normal,
              height = 40,
              width = 40,
              {
                widget = wibox.widget.imagebox,
                image = beautiful.icon_add,
                buttons = gears.table.join({
                    awful.button({}, 1,
                      function ()
                        awful.spawn.with_shell("pkill rofi || rofi -show")
                      end
                    )
                }),
              }
            },
          },
        },
        {
          widget = wibox.container.margin,
          top = 10,
          left = 10,
          right = 10,
          bottom = 10,
          {
            widget = wibox.container.background,
            shape = gears.shape.rounded_rect,
            bg = beautiful.bg_normal,
            width = 40,
            {
              widget = wibox.container.margin,
              s.mytasklist
            }
          }
        },
        s.mywidget_container
      }
    }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey, "Control" }, "s", function ()
      awful.spawn.with_shell("~/.config/awesome/config/rofi/scripts.sh")
                                        end,
  { description = "run custom script with rofi", group = "apps" }), -- https://github.com/davatorium/rofi/wiki/Script-Launcher
  awful.key({ modkey, "Shift" }, "n", function ()
      awful.spawn.with_shell("bash -c 'kill -s USR1 $(pidof deadd-notification-center)'")
                                      end,
    { description = "show notification center", group = "apps" }),
  -- Volume
  awful.key({ }, "XF86AudioRaiseVolume", function ()
      awful.spawn("amixer set Master 5%+")
      update_volume_icon()
  end),
   awful.key({ }, "XF86AudioLowerVolume", function ()
       awful.spawn("amixer set Master 5%-")
       update_volume_icon()
   end),
   awful.key({ }, "XF86AudioMute", function ()
       awful.spawn("amixer set Master toggle")
       update_volume_icon()
   end),
  -- Brightness
  awful.key({ }, "XF86MonBrightnessDown", function ()
      awful.spawn("light -U 10")
      update_backlight_icon()
  end),
  awful.key({ }, "XF86MonBrightnessUp", function ()
      awful.spawn("light -A 10")
      update_backlight_icon()
  end),
  awful.key({ modkey, "Mod1" }, "h",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key({ modkey, "Mod1" }, "l", function ()
      awful.spawn.with_shell("~/.config/awesome/bin/lock.sh")
                                     end,
    {description = "lock screen", group = "apps"}
  ),
  awful.key({ modkey, }, "w",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey, }, "s",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  awful.key({ modkey, }, "d",
    function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey, }, "a",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),

  -- Layout manipulation
  awful.key({ "Mod1", "Control" }, "Tab", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({ "Mod1", "Shift"   }, "Tab", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),
  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

  -- Applications
  awful.key({ modkey }, "p", function() awful.spawn.with_shell("pkill rofi || rofi -show") end,
    {description = "show rofi menu", group = "apps"}),
  awful.key({ modkey }, "c", function() awful.spawn.with_shell("pkill rofi || rofi -show calc") end,
    {description = "show rofi calculator", group = "apps"}),
  awful.key({ modkey }, "b", function() awful.spawn("bwmenu") end,
    {description = "show Bitwarden", group = "apps"}),
  awful.key({ modkey, "Shift" }, "p", function() awful.spawn.with_shell("~/.config/awesome/bin/power.sh") end,
    {description = "show power menu", group = "apps"}),
  awful.key({ }, "Print", function() awful.spawn("flameshot gui") end,
    {description = "take screenshot", group = "apps"}),
  awful.key({ modkey, "Control" }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:activate { raise = true, context = "key.unminimize" }
      end
    end,
    {description = "restore minimized", group = "client"})
)

clientkeys = gears.table.join(
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey   }, "q",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"}),
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
                                -- View tag only.
                                awful.key({ modkey }, "#" .. i + 9,
                                  function ()
                                    local screen = awful.screen.focused()
                                    local tag = screen.tags[i]
                                    if tag then
                                      tag:view_only()
                                    end
                                  end,
                                  {description = "view tag #"..i, group = "tag"}),
                                -- Toggle tag display.
                                awful.key({ modkey, "Control" }, "#" .. i + 9,
                                  function ()
                                    local screen = awful.screen.focused()
                                    local tag = screen.tags[i]
                                    if tag then
                                      awful.tag.viewtoggle(tag)
                                    end
                                  end,
                                  {description = "toggle tag #" .. i, group = "tag"}),
                                -- Move client to tag.
                                awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                  function ()
                                    if client.focus then
                                      local tag = client.focus.screen.tags[i]
                                      if tag then
                                        client.focus:move_to_tag(tag)
                                      end
                                    end
                                  end,
                                  {description = "move focused client to tag #"..i, group = "tag"}),
                                -- Toggle tag on focused client.
                                awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                  function ()
                                    if client.focus then
                                      local tag = client.focus.screen.tags[i]
                                      if tag then
                                        client.focus:toggle_tag(tag)
                                      end
                                    end
                                  end,
                                  {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
  end),
  awful.button({ modkey, "Shift" }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { focus = awful.client.focus.filter,
                   raise = true,
                   keys = clientkeys,
                   buttons = clientbuttons,
                   screen = awful.screen.preferred,
                   placement = awful.placement.centered
    }
  },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"},

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
  }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "normal", "dialog" }
               }, properties = { titlebars_enabled = true }
  },
  {
    rule = {requests_no_titlebar = true},
    properties = {titlebars_enabled = false}
  },
  {
    rule = {instance = "onboard"},
    properties = {focusable = false}
  },
  {
    rule = {instance = "onboard-settings"},
    properties = {focusable = true}
  },
  {
    rule = {instance = "rofi"},
    properties = {ontop = true, floating = true, placement = awful.placement.top}
  }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
                        -- Set the windows at the slave,
                        -- i.e. put it at the end of others instead of setting it master.
                        -- if not awesome.startup then awful.client.setslave(c) end

                        if awesome.startup
                          and not c.size_hints.user_position
                        and not c.size_hints.program_position then
                          -- Prevent clients from being unreachable after screen count changes.
                          awful.placement.no_offscreen(c)
                        end
                        
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                        c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- }}}

-- {{{ Autostart
autostart_list = {
  "autorandr horizontal",
  "picom -b --config ~/.config/awesome/picom.conf",
  "xfce4-power-manager",
  "xss-lock ~/.config/awesome/bin/lock.sh",
  "/usr/lib/polkit-kde-authentication-agent-1",  
  "kwalletd5",
  "blueman-applet",
  "nm-applet",
  "~/.config/awesome/bin/autostart.sh",
  "~/.config/awesome/bin/powerbtn.sh",
  "tilda",
  "redshift-gtk"
}
for i,cmd in ipairs(autostart_list)
do    
  local findme = cmd
  local firstplace = cmd:find(' ')
  if firstplace then
    findme = cmd:sub(0, firstplace - 1)
  end
  awful.spawn.with_shell(string.format('pidof -x %s > /dev/null || %s', findme, cmd))
end
--- }}}
