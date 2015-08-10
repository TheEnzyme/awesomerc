
local awful = require("awful")
require("awful.autofocus")
awful.rules = require("awful.rules")

local naughty = require("naughty")

local beautiful = require("beautiful")
local gears = require("gears")

local menubar = require("menubar")

---

local CONFIG_DIR = awful.util.getdir("config")

local MOD

---
---
---

--======== OPTIONS ========--
local OPTIONS = {
	modkey = "Mod4",

	theme = "ocean",

	---

	applications = {
		terminal = "termite -e fish",
		editor = os.getenv("EDITOR"),
		veditor = "textadept",
		filemanager = "thunar",
		www = "firefox"
	},

	---

	ntags = 6,

	layouts = {
		awful.layout.suit.floating,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.tile,
		awful.layout.suit.tile.left
	},
	default_layout = awful.layout.suit.tile
}

OPTIONS.keys = awful.util.table.join(

	awful.key({OPTIONS.modkey}, "Return", function()
		awful.util.spawn(OPTIONS.applications.terminal)
	end),

	awful.key({OPTIONS.modkey, "Control"}, "Return", function()
		awful.util.spawn(OPTIONS.applications.www)
	end),

	awful.key({OPTIONS.modkey, "Mod1"}, "Return", function()
		awful.util.spawn(OPTIONS.applications.filemanager)
	end),

	--[[
	awful.key({OPTIONS.modkey, "Control", "Shift"}, "Return", function()
		awful.util.spawn(OPTIONS.applications.veditor)
	end),
	]]
	---

	awful.key({OPTIONS.modkey, }, "a", awful.tag.viewprev         ),
	awful.key({OPTIONS.modkey, }, ",", awful.tag.viewprev         ),

	awful.key({OPTIONS.modkey, }, "s", awful.tag.history.restore  ),

	awful.key({OPTIONS.modkey, }, "d", awful.tag.viewnext         ),
	awful.key({OPTIONS.modkey, }, ".", awful.tag.viewnext         ),

	---

	awful.key({OPTIONS.modkey, }, "q",
		function()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[4]
			if tag then
				awful.tag.viewonly(tag)
			end
		end),

	awful.key({OPTIONS.modkey, }, "w",
		function()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[5]
			if tag then
				awful.tag.viewonly(tag)
			end
		end),

	awful.key({OPTIONS.modkey, }, "e",
		function()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[6]
			if tag then
				awful.tag.viewonly(tag)
			end
		end)
)

OPTIONS.buttons = {}

OPTIONS.client_rules = {
}
--======== END OPTIONS ========--

---
---
---

-- Set the terminal for applications that require it.
menubar.utils.terminal = OPTIONS.applications.terminal

---

local ROOT_KEYS = {}
local ROOT_BUTTONS = {}

MOD = {
	add_root_keys = function(...)
		ROOT_KEYS = awful.util.table.join(ROOT_KEYS, ...)
	end,

	add_root_buttons = function(...)
		ROOT_BUTTONS = awful.util.table.join(ROOT_BUTTONS, ...)
	end,

	---

	add_client_rules = function(...)
		awful.rules.rules = awful.util.table.join(awful.rules.rules, ...)
	end,

	remove_client_rule = function(rulet)
		local i = awful.util.table.hasitem(awful.rules.rules, rulet)
		if i then
			awful.rules.rules[i] = nil
		end
	end
}


-- System to make windows appear on the tag their process was started on.
local sticky_clients = {__mode = "v"}
do
	local spawn = awful.util.spawn
	function awful.util.spawn(...)
		local screen = mouse.screen
		local tag = awful.tag.selected()

		local pid = spawn(...)

		sticky_clients[pid] = {
			screen = screen,
			tag = tag
		}

		return pid
	end
end

---

--- Handle runtime Lua errors
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end

		in_error = true
		naughty.notify{
			preset = naughty.config.presets.critical,
			title = "A Lua error occurred",
			text = err
		}
		in_error = false
	end)
end


--- Apply theme
beautiful.init(("%s/themes/%s/theme.lua"):format(CONFIG_DIR, OPTIONS.theme))

if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end


--- Add tags
local tags = {}

names = { "TERM", "COMMS", "WEB", "AUX", "DEV", "WORK" }

for s = 1, screen.count() do
	tags[s] = {}

	for n = 1, OPTIONS.ntags do
		tags[s][n] = awful.tag.add( names[n], {
			screen = s,
			layout = OPTIONS.default_layout
		})

		if n == 1 then
			tags[s][n].selected = true
		end
	end
end

--- Add main wibox
local MAIN_WIBOX = assert(loadfile(CONFIG_DIR .. "/include/main_wibox.lua"))(OPTIONS, MOD)

--- Add key and button bindings
MOD.add_root_keys(assert(loadfile(CONFIG_DIR .. "/include/root_keys.lua"))(OPTIONS, MOD) or {})
MOD.add_root_buttons(assert(loadfile(CONFIG_DIR .. "/include/root_buttons.lua"))(OPTIONS, MOD) or {})

MOD.add_root_keys(OPTIONS.keys or {})
MOD.add_root_buttons(OPTIONS.buttons or {})


--- Client rules
MOD.add_client_rules(
	{
		{ -- All clients match this rule.
			rule = {},
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = assert(loadfile(CONFIG_DIR .. "/include/client_keys.lua"))(OPTIONS, MOD),
				buttons = assert(loadfile(CONFIG_DIR .. "/include/client_buttons.lua"))(OPTIONS, MOD)
			}
		}
	},

	{ rule = { class = "Skype" },
		properties = { tag = tags[2] } },
	
	{ rule = { class = "Firefox" },
		properties = { tag = tags[3] } },

	OPTIONS.client_rules
)


--- Client signals
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
		--awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	---

	if c.pid and sticky_clients[c.pid] then
		local t = sticky_clients[c.pid]

		if not t.keep then
			sticky_clients[c.pid] = nil
		end

		c:tags({t.tag})
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


--- Set global keys and buttons
root.keys(ROOT_KEYS)
root.buttons(ROOT_BUTTONS)

--- Auto start up programs.
function run_once(cmd)
	findme = cmd
	firstspace = cmd:find(" ")

	if firstspace then
		findme = cmd:sub(0, firstspace-1)
	end
	
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("skype")
run_once("termite -e \"tmux -2 a -t comms\"")
run_once("firefox")
