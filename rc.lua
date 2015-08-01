-- Standard awesome library --
local awful = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")

require("awful.autofocus")

local beautiful = require("beautiful")
local gears = require("gears")
-- ================ --

-- Other modules --
local awutil = require("lib.self.awutil")
-- ================ --

-- Various definitions --
local THEME_PATH = string.format("%s/themes/theme.lua", awful.util.getdir("config"))

APPLICATIONS = {
	terminal = "termite -e fish",
	veditor = "textadept",
	webbrowser = "firefox",
	filebrowser = "thunar"
}

LAYOUTS = {
	awful.layout.suit.floating,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left
}

local NTAGS = 6

MODKEY = "Mod4"
-- ================ --


-- Handle runtime Lua errors --
local in_error = false
awesome.connect_signal("debug::error", function (err)
	if in_error then return end -- Make sure we don't go into an endless error loop.
	in_error = true

	naughty.notify{
		preset = naughty.config.presets.critical,
		title = "A Lua error has occured.",
		text = err
	}

	in_error = false
end)
-- ================ --

-- Set theme --
beautiful.init(THEME_PATH)
-- ================ --

-- Put the wallpaper on all screens.
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- ================ --

-- Setup tags --
local tags = {}
names = { "TERM", "COMMS", "WEB", "AUX", "DEV",  "WORK" }
for s = 1, screen.count() do
	tags[s] = {}
	for n = 1, NTAGS do
		tags[s][n] = awful.tag.add(names[n], {
			screen = s,
			layout = LAYOUTS[4]
		})

		if n == 1 then
			tags[s][n].selected = true
		end
	end
end
-- ================ --

-- Main key/mouse bindings --
root.keys( require("main.bindings.global.keys") )
-- ================ --

-- Set the terminal for applications that require it --
menubar.utils.terminal = APPLICATIONS.terminal
-- ================ --

-- Main widget box --
require("main.wibox.main")
-- ================ --

-- Client rules --
awutil.add_client_rules{
	{ -- All clients will match this rule.
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			keys = require("main.bindings.client.keys"),
			buttons = require("main.bindings.client.buttons")
		}
	}
}

awutil.add_client_rules( require("main.client.rules") )
-- ================ --

-- Client signals --
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
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
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

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
-- ================ --
