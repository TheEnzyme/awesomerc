local awful = require("awful")
local menubar = require("menubar")

local globalkeys = {}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ MODKEY }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then
					 awful.tag.viewonly(tag)
				end
			end),
	awful.key({ MODKEY, "Control" }, "#" .. i + 9,
		function ()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				 awful.tag.viewtoggle(tag)
			end
		end),
	awful.key({ MODKEY, "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
						awful.client.movetotag(tag)
				end
		 end
		end),
	awful.key({ MODKEY, "Control", "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
						awful.client.toggletag(tag)
				end
			end
		end))
end

globalkeys = awful.util.table.join(globalkeys,
	-- Launching applications --
	awful.key({ MODKEY,           }, "Return", function () awful.util.spawn(APPLICATIONS.terminal) end),
	awful.key({ MODKEY, "Shift"   }, "Return", function () awful.util.spawn(APPLICATIONS.veditor) end),
	awful.key({ MODKEY, "Control" }, "Return", function () awful.util.spawn(APPLICATIONS.webbrowser) end),
	awful.key({ MODKEY, "Mod1"    }, "Return", function () awful.util.spawn(APPLICATIONS.filebrowser) end),
	-- ================ --

	awful.key({ MODKEY,           }, "Left",   awful.tag.viewprev  ),
	awful.key({ MODKEY,           }, "a",      awful.tag.viewprev  ),
	awful.key({ MODKEY,           }, ",",      awful.tag.viewprev  ),

	
	awful.key({ MODKEY,           }, "Right",  awful.tag.viewnext  ),
	awful.key({ MODKEY,           }, "d",      awful.tag.viewnext  ),
	awful.key({ MODKEY,           }, ".",      awful.tag.viewnext  ),

	awful.key({ MODKEY,           }, "Escape", awful.tag.history.restore),
	awful.key({ MODKEY,           }, "s",      awful.tag.history.restore),

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

	awful.key({ MODKEY, "Control" }, "n", awful.client.restore)

	-- Menubar
	--awful.key({ MODKEY }, "p", function()  menubar.show()  end)
)

return globalkeys
