-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local icontheme = require("menubar.icon_theme")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
		    title = "Oops, there were berrors during startup!",
		    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
			     -- Make sure we don't go into an endless error loop
			     if in_error then return end
			     in_error = true

			     naughty.notify({ preset = naughty.config.presets.critical,
					      title = "Oops, an error happened!",
					      text = tostring(err) })
			     in_error = false
   end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/pretty/theme.lua")


local nice = require('nice')
nice{
   no_titlebar_maximized = true,
   floating_color = "#0077ff",
   sticky_color = "#ff0077",
   ontop_color = "#77ff00",
   titlebar_items = {
      left = {"close", "minimize", "maximize"},
      middle = "title",
      right = {"floating"},
   }
}

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
menubar.utils.terminal = terminal
icon_theme = icontheme.new("McMuse-dark", {"~/.local/share/icons", "~/.icons", "/usr/share/icons"})

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
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
--   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.corner.nw,
   awful.layout.suit.corner.ne,
   awful.layout.suit.corner.sw,
   awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout{
   font = "Noto Sans  10"
}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach( mytextclock, 'tr' )

mywifi = wibox.widget.imagebox{
   
}

-- Create a wibox for each screen and add it
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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s)

      -- Each screen has its own tag table.
      awful.tag({ "", "", "", "", "", "", "", "I", "" }, s, awful.layout.suit.tile)

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contain an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(gears.table.join(
			       awful.button({ }, 1, function () awful.layout.inc( 1) end),
			       awful.button({ }, 3, function () awful.layout.inc(-1) end),
			       awful.button({ }, 4, function () awful.layout.inc( 1) end),
			       awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist {
	 screen  = s,
	 filter  = awful.widget.taglist.filter.all,
	 layout   = wibox.layout.fixed.vertical,
	 widget_template = {
	    {
	       id     	= 'text_role',
	       align 	= "center",
	       forced_height = 40,
	       widget	= wibox.widget.textbox
	    },
	    id     = 'background_role',
	    widget = wibox.container.background,
	 },
	 buttons = taglist_buttons
      }

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist {
	 screen   = s,
	 filter   = awful.widget.tasklist.filter.currenttags,
	 buttons  = tasklist_buttons,
	 style    = {
	    border_width = 1,
	    border_color = '#777777',
	    shape        = gears.shape.rounded_rect,
	 },
	 layout   = {
	    spacing = 3,
	    spacing_widget = {
	       {
		  forced_width = 0,
		  shape        = gears.shape.circle,
		  widget       = wibox.widget.separator
	       },
	       valign = 'center',
	       halign = 'center',
	       widget = wibox.container.place,
	    },
	    layout  = wibox.layout.fixed.horizontal
	 },
	 -- Notice that there is *NO* wibox.wibox prefix, it is a template,
	 -- not a widget instance.
	 widget_template = {
	    {
	       {
		  {
		     {
			id     = 'clienticon',
			widget = awful.widget.clienticon,
		     },
		     margins = 5,
		     widget  = wibox.container.margin,
		  },
		  {
		     id     = 'text_role',
		     widget = wibox.widget.textbox,
		  },
		  {
		     id = "close_button",
		     text = "",
		     font = "Material Icons 15",
		     widget = wibox.widget.textbox,
		  },
		  layout = wibox.layout.align.horizontal,
	       },
	       left  = 10,
	       right = 10,
	       widget = wibox.container.margin
	    },
	    forced_width = 400,
	    id     = 'background_role',
	    widget = wibox.container.background,
	    create_callback = function (self, c, index, clients)
	       local closer = self:get_children_by_id('close_button')[1]
	       closer:connect_signal("button::press",
				     function (self, lx, ly, b, m, r)
					self.client:kill()
				     end
	       )
	       closer.client = c
	    end
	 },
      }
      
      s.mybattery_text = wibox.widget.textbox()
      s.mybattery_text.font = "Font Awesome 10"
      
      s.mybattery = awful.widget.watch("bash -c \"~/.config/awesome/bin/battery.sh\"", 1,
				       function (widget, stdout)
					  widget:set_text(stdout)
				       end,
				       s.mybattery_text
      )
      
      s.mysystray = wibox.widget.systray{
	 forced_width 	= 30,
      }
      
      s.mysystray:set_horizontal(false)
      -- Create the wibox
      s.mywibox_top = awful.wibar({ position = "top", screen = s, height = 40 })

      -- Add widgets to the wibox
      s.mywibox_top:setup {
	 layout = wibox.layout.align.horizontal,
	 { -- Left widgets
	    layout = wibox.layout.fixed.horizontal,
	    s.mypromptbox,
	 },
	 s.mytasklist, -- Middle widget
	 { -- Right widgets
	    layout = wibox.layout.fixed.horizontal,
	    s.mybattery,
	    mykeyboardlayout,
	    mytextclock,
	    s.mylayoutbox,
	 },
      }

      s.mywibox_left = awful.wibar({ position = "left", screen = s, width = 40})
      
      s.mywibox_left:setup {
	 s.mytaglist,
	 nil,
	 {
	    layout = wibox.layout.fixed.vertical,
	    s.mysystray,
	 },
	 layout = wibox.layout.align.vertical,
      }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
   -- Brightness
   awful.key({ }, "XF86MonBrightnessDown", function ()
	 awful.util.spawn("xbacklight -dec 10") end),
   awful.key({ }, "XF86MonBrightnessUp", function ()
	 awful.util.spawn("xbacklight -inc 10") end),
   awful.key({ modkey, "Shift" }, "s",      hotkeys_popup.show_help,
      {description="show help", group="awesome"}),
   awful.key({ modkey, "Mod1" }, "l", function ()
	 awful.util.spawn("i3lock-next")
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

   awful.key({ modkey, "Control" }, "n",
      function ()
	 local c = awful.client.restore()
	 -- Focus restored client
	 if c then
	    c:emit_signal(
	       "request::activate", "key.unminimize", {raise = true}
	    )
	 end
      end,
      {description = "restore minimized", group = "client"}),

   -- Prompt
   awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
      {description = "run prompt", group = "launcher"}),

   awful.key({ modkey }, "x",
      function ()
	 awful.prompt.run {
	    prompt       = "Run Lua code: ",
	    textbox      = awful.screen.focused().mypromptbox.widget,
	    exe_callback = awful.util.eval,
	    history_path = awful.util.get_cache_dir() .. "/history_eval"
	 }
      end,
      {description = "lua execute prompt", group = "awesome"}),
   -- Applications
   awful.key({ modkey }, "p", function() awful.util.spawn("ulauncher-toggle") end,
      {description = "show Ulauncher", group = "apps"}),
   awful.key({ }, "Print", function() awful.util.spawn("flameshot gui") end,
      {description = "take screenshot", group = "apps"})
)

clientkeys = gears.table.join(
   awful.key({ modkey,           }, "f",
      function (c)
	 c.fullscreen = not c.fullscreen
	 c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey,           }, "n",
      function (c)
	 -- The client currently has the input focus, so it cannot be
	 -- minimized, since minimized clients can't have the focus.
	 c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
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
   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Disable titlebars for maximized windows
client.connect_signal("request::geometry",
		      function (c, context)
			 if c.maximized then
			    c.titlebars_enabled = false;
			 end
		      end
)
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

-- Set default notifications icon
naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = icon_theme:find_icon_path(hints.app_icon) or
        menubar.utils.lookup_icon_uncached(hints.app_icon:lower())

    if path then
        n.icon = path
    else
	n.icon = "/usr/share/icons/McMuse-dark/actions/24/hook-notifier.svg"
    end
end)

naughty.connect_signal("request::action_icon", function(a, context, hints)
     a.icon = menubar.utils.lookup_icon(hints.id)
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
			 c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- }}}

-- {{{ Autostart
autostart_list = {
   "compton -b --config ~/.config/awesome/compton.conf",
   "volumeicon",
   "xinput disable 13",
   "xss-lock i3lock-next",
   "/usr/lib/xfce-polkit/xfce-polkit",
   "blueman-applet",
   "~/.local/bin/autostart_all",
   "thunderbird",
   "tilda",
   "nm-applet"
}
for i,cmd in ipairs(autostart_list)
do	
   local findme = cmd
   local firstplace = cmd:find(' ')
   if firstplace then
      findme = cmd:sub(0, firstplace - 1)
   end
   awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || %s', findme, cmd))
end
--- }}}
