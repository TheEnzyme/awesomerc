local awful = require("awful")

return awful.util.table.join(
	awful.key({ MODKEY,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ MODKEY, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ MODKEY, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ MODKEY, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ MODKEY,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ MODKEY,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ MODKEY,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ MODKEY,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)
