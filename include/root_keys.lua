local OPTIONS, MOD = ...

local awful = require("awful")
local menubar = require("menubar")

---

local keys = {}
local function add_keys(...)
	keys = awful.util.table.join(keys, ...)
end

-- Bind number keys to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	add_keys(
		-- Mod + # -> Only view that tag.
		awful.key({OPTIONS.modkey}, "#" .. i + 9,
			function()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then
					awful.tag.viewonly(tag)
				end
			end
		),

		-- Mod + Control + # -> Toggle viewing that tag.
		awful.key({OPTIONS.modkey, "Control"}, "#" .. i + 9,
			function()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end
		),

		-- Mod + Shift + # -> Move the focused client to that tag.
		awful.key({OPTIONS.modkey, "Shift"}, "#" .. i + 9,
			function()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then
						awful.client.movetotag(tag)
					end
				end
			end
		),

		-- Mod + Control + Shift + # -> Toggle whether focused client has this tag.
		awful.key({OPTIONS.modkey, "Mod1"}, "#" .. i + 9,
			function()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then
						awful.client.toggletag(tag)
					end
				end
			end
		)
	)
end

-- Miscellaneous navigation and control keys.
add_keys(
	awful.key({OPTIONS.modkey,          }, "Left",   awful.tag.viewprev       ),
	awful.key({OPTIONS.modkey,          }, "Right",  awful.tag.viewnext       ),

	awful.key({OPTIONS.modkey,          }, "j",
		function()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end
	),
	awful.key({OPTIONS.modkey,          }, "k",
		function()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end
	),

	-- Layout manipulation.
	awful.key({OPTIONS.modkey, "Shift"  }, "j", function() awful.client.swap.byidx(  1)     end),
	awful.key({OPTIONS.modkey, "Shift"  }, "k", function() awful.client.swap.byidx( -1)     end),
	awful.key({OPTIONS.modkey, "Control"}, "j", function() awful.screen.focus_relative( 1)  end),
	awful.key({OPTIONS.modkey, "Control"}, "k", function() awful.screen.focus_relative(-1)  end),
	awful.key({OPTIONS.modkey,          }, "u", awful.client.urgent.jumpto),
	awful.key({OPTIONS.modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			 end
		end),
																											

	awful.key({OPTIONS.modkey, "Control"}, "r", awesome.restart),
	awful.key({OPTIONS.modkey, "Shift"  }, "q", awesome.quit),

	awful.key({OPTIONS.modkey,          }, "l",     function() awful.tag.incmwfact( 0.05)    end),
	awful.key({OPTIONS.modkey,          }, "h",     function() awful.tag.incmwfact(-0.05)    end),
	awful.key({OPTIONS.modkey, "Shift"  }, "h",     function() awful.tag.incnmaster( 1)      end),
	awful.key({OPTIONS.modkey, "Shift"  }, "l",     function() awful.tag.incnmaster(-1)      end),
	awful.key({OPTIONS.modkey, "Control"}, "h",     function() awful.tag.incncol( 1)         end),
	awful.key({OPTIONS.modkey, "Control"}, "l",     function() awful.tag.incncol(-1)         end),
	awful.key({OPTIONS.modkey,          }, "space", function() awful.layout.inc(OPTIONS.layouts,  1) end),
	awful.key({OPTIONS.modkey, "Shift"  }, "space", function() awful.layout.inc(OPTIONS.layouts, -1) end),

	awful.key({OPTIONS.modkey, "Control"}, "n", awful.client.restore)
)
---

return keys
