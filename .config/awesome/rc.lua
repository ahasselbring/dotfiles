-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
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
                         text = err })
        in_error = false
    end)
end
-- }}}

awful.util.spawn("/usr/bin/wmname LG3D", false)

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/arne/.config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "/usr/bin/urxvtc"
terminal_cmd = terminal .. " -e tmux"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "term", "www", "comm", "apps", "docs" }, s, layouts[2])
end
-- }}}

-- {{{ Wibox

-- Create a wibox for each screen and add it
mywibox = {}

-- Date
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date,
    '<span background="' .. beautiful.date_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.date_fg .. '" font="' .. beautiful.font .. '">%d. %b %H:%M</span> </span>', 60)

-- Network
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
        local interface = ""
        if args["{wlp4s0 carrier}"] == 1 then
            interface = "wlp4s0"
        elseif args["{enp0s31f6 carrier}"] == 1 then
            interface = "enp0s31f6"
        else
            interface = "enp0s31f6"
        end
        return '<span background="' .. beautiful.net_bg .. '" font="' .. beautiful.font_bg ..
            '"> <span color="' .. beautiful.net_fg .. '" font="' .. beautiful.font .. '">' ..
            args["{" .. interface .." down_kb}"] .. ' ↓↑ ' .. args["{" .. interface .." up_kb}"] ..
            '</span> </span>'
    end, 5)
netmenuitems = {
    { "WiFi on", function()
        awful.util.spawn("sudo /sbin/rc-service net.wlp4s0 start", false)
    end },
    { "WiFi off", function()
        awful.util.spawn("sudo /sbin/rc-service net.wlp4s0 stop", false)
    end },
    { "TUHH VPN on", function()
        awful.util.spawn("sudo /sbin/rc-service openconnect.tuhh start", false)
    end },
    { "TUHH VPN off", function()
        awful.util.spawn("sudo /sbin/rc-service openconnect.tuhh stop", false)
    end }
}
netmenu = awful.menu({ items = netmenuitems })
netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function() netmenu:toggle() end)))

-- TODO: show whether WiFi is enabled / VPN is enabled

-- Battery
batterywidget = wibox.widget.textbox()
vicious.register(batterywidget, vicious.widgets.bat,
    '<span background="' .. beautiful.battery_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.battery_fg .. '" font="' .. beautiful.font .. '">$1$2%</span> </span>', 30, "BAT0")

-- File System Usage
fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs,
    '<span background="' .. beautiful.fs_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.fs_fg .. '" font="' .. beautiful.font .. '">${/ used_gb}GiB</span> </span>', 30)

-- CPU Usage
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
    '<span background="' .. beautiful.cpu_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.cpu_fg .. '" font="' .. beautiful.font .. '">$2% $3% $4% $5% $6% $7% $8% $9%</span> </span>', 5)

memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem,
    '<span background="' .. beautiful.mem_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.mem_fg .. '" font="' .. beautiful.font .. '">$2MiB</span> </span>', 5)

mailwidget = wibox.widget.textbox()
vicious.register(mailwidget, vicious.widgets.mdir,
    '<span background="' .. beautiful.mail_bg .. '" font="' .. beautiful.font_bg ..
    '"> <span color="' .. beautiful.mail_fg .. '" font="' .. beautiful.font .. '">$1</span> </span>', 30,
    { "/home/arne/Mail/tuhh", "/home/arne/Mail/google", "/home/arne/Mail/ctf" })

volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, function(widget, args)
        local string = args[1] .. '%'
        if args[2] == "♩" then
            string = 'M'
        end
        return '<span background="' .. beautiful.volume_bg .. '" font="' .. beautiful.font_bg ..
            '"> <span color="' .. beautiful.volume_fg .. '" font="' .. beautiful.font .. '">' ..
            string .. '</span> </span>'
    end, 60, "Master")
volumewidget:buttons(awful.util.table.join(awful.button({ }, 1, function()
        awful.util.spawn('/usr/bin/amixer set Master toggle', false)
        vicious.force({ volumewidget })
    end)))

mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mailwidget)
    right_layout:add(memwidget)
    right_layout:add(cpuwidget)
    right_layout:add(volumewidget)
    right_layout:add(fswidget)
    right_layout:add(batterywidget)
    right_layout:add(netwidget)
    right_layout:add(datewidget)
    right_layout:add(mylayoutbox[s])

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal_cmd) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.util.spawn("xscreensaver-command -lock", false)    end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey }, "c",
              function ()
                  awful.prompt.run({ prompt = "Calculate: " },
                  mypromptbox[mouse.screen].widget,
                  function(expr)
                      local result = awful.util.eval("return (" .. expr .. ")")
                      naughty.notify({ text = expr .. " = " .. result, timeout = 10 })
                  end)
              end),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.util.spawn("/usr/bin/amixer set Master toggle", false)
            vicious.force({ volumewidget })
        end),
    awful.key({ }, "XF86AudioMicMute",
        function ()
            awful.util.spawn("/usr/bin/amixer set Capture toggle", false)
            vicious.force({ volumewidget })
        end),
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.util.spawn("/usr/bin/amixer set Master 2+", false)
            vicious.force({ volumewidget })
        end),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.util.spawn("/usr/bin/amixer set Master 2-", false)
            vicious.force({ volumewidget })
        end),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.util.spawn("/usr/bin/xbacklight -dec 10", false)
        end),
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.util.spawn("/usr/bin/xbacklight -inc 10", false)
        end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Gitk" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Telegram" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Matlab" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Wireshark" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "jetbrains-clion" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Zathura" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Sxiv" },
      properties = { tag = tags[1][5] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
