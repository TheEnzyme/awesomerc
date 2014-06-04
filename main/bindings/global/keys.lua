local awful = require("awful")
local menubar = require("menubar")

return awful.util.table.join(
		-- Launching applications --
    awful.key({ MODKEY,           }, "Return", function () awful.util.spawn(APPLICATIONS.terminal) end),
		awful.key({ MODKEY, "Shift"   }, "Return", function () awful.util.spawn(APPLICATIONS.veditor) end),
		awful.key({ MODKEY, "Control" }, "Return", function () awful.util.spawn(APPLICATIONS.webbrowser) end),
		-- ================ --

		awful.key({ MODKEY,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ MODKEY,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ MODKEY,           }, "Escape", awful.tag.history.restore),

    awful.key({ MODKEY,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ MODKEY,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ MODKEY, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ MODKEY, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ MODKEY, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ MODKEY, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ MODKEY,           }, "u", awful.client.urgent.jumpto),
    awful.key({ MODKEY,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ MODKEY, "Control" }, "r", awesome.restart),
    awful.key({ MODKEY, "Shift"   }, "q", awesome.quit),

    awful.key({ MODKEY,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ MODKEY,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ MODKEY, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ MODKEY, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ MODKEY, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ MODKEY, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ MODKEY,           }, "space", function () awful.layout.inc(LAYOUTS,  1) end),
    awful.key({ MODKEY, "Shift"   }, "space", function () awful.layout.inc(LAYOUTS, -1) end),

    awful.key({ MODKEY, "Control" }, "n", awful.client.restore),

    -- Menubar
    awful.key({ MODKEY }, "p", function() menubar.show() end)
)
