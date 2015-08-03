local OPTIONS, MOD = ...

local awful = require("awful")

---

return awful.util.table.join(
	awful.key({OPTIONS.modkey,          }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({OPTIONS.modkey, "Shift"  }, "c",      function (c) c:kill()                         end),
	awful.key({OPTIONS.modkey, "Control"}, "space",  awful.client.floating.toggle                     ),
	awful.key({OPTIONS.modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({OPTIONS.modkey,          }, "o",      awful.client.movetoscreen                        ),
	awful.key({OPTIONS.modkey,          }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({OPTIONS.modkey,          }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end
	)
)
