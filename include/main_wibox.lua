local main_wibox = {}

---

local OPTIONS, MOD = ...

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local vicious = require("vicious")

---

local powermeter = wibox.widget.textbox()

local volumemeter = wibox.widget.textbox()

local separator = wibox.widget.textbox(" | ")

local textclock = awful.widget.textclock("%I:%M %p", 1)

---

vicious.register(powermeter, vicious.widgets.bat, "BAT: $2%$1", 43, "BAT0")

vicious.register(volumemeter, vicious.widgets.volume, "VOL: $1% $2", 1, "Master")

---

local taglist = {}
taglist.buttons = awful.util.table.join(
	-- Left click -> view only that tag.
	awful.button.new({}, 1, awful.tag.viewonly),

	-- Mod + left click -> set this tag as the current client's only tag.
	awful.button.new({OPTIONS.modkey}, 1, awful.client.movetotag),

	-- Right click -> toggle visibilty of this tag.
	awful.button.new({}, 3, awful.tag.viewtoggle),

	-- Mod + right click -> toggle whether current client has this tag.
	awful.button.new({OPTIONS.modkey}, 3, awful.client.toggletag)
)

---

local tasklist = {}
tasklist.buttons = awful.util.table.join(
	-- Left click -> Minimise a client or give it focus, or maximise it.
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c.minimized = false -- Needed for :isvisible() to make sense.
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- Un-minimise client if needed.
			client.focus = c
			c:raise()
		end
	end)
)

---

local prompt = {}
local layoutbox = {}

for s = 1, screen.count() do
	main_wibox[s] = awful.wibox{
		position = "top",
		height = "25",
		screen = s
	}

	---

	-- prompt: runs commands.
	prompt[s] = awful.widget.prompt{prompt = " | RUN: "}

	-- layoutbox: shows layout of screen s.
	layoutbox[s] = awful.widget.layoutbox(s)

	-- taglist: lists tags.
	taglist[s] = awful.widget.taglist(s,
		awful.widget.taglist.filter.all, taglist.buttons)

	-- tasklist: lists clients on screen s.
	tasklist[s] = awful.widget.tasklist(s,
		awful.widget.tasklist.filter.focused) 

	---

	local left = {
		taglist[s],
		prompt[s],
		separator
	}


	local right = {
		separator,
		volumemeter,
		separator,
		powermeter,
		separator,
		textclock,
		separator,
		separator,
		layoutbox[s]
	}

	if s == 1 then
		table.insert(right, 8, wibox.widget.systray())
	end

	---

	-- Widgets aligned to the left of the wibox.
	local left_layout = wibox.layout.fixed.horizontal()
	for i, widget in ipairs(left) do
		left_layout:add(widget)
	end

	-- Widgets aligned to the right.
	local right_layout = wibox.layout.fixed.horizontal()
	for i, widget in ipairs(right) do
		right_layout:add(widget)
	end

	-- Put it all together.
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(tasklist[s])
	layout:set_right(right_layout)

	-- Set the wibox's widget to the whole thing.
	main_wibox[s]:set_widget(layout)
end

---

MOD.add_root_keys(
	awful.key({OPTIONS.modkey}, "r", function()
		prompt[mouse.screen]:run()
	end),

	awful.key({OPTIONS.modkey, }, "z",
		function()
			awful.prompt.run({ prompt = " | DELETE(y/n): "},
			prompt[mouse.screen].widget,
			function(confirmation)
				if string.upper(confirmation) == "Y" then
					awful.tag.delete()
				end
			end)
		end),

	awful.key({OPTIONS.modkey, }, "x",
		function()
			awful.prompt.run({ prompt = " | TAG: "},
			prompt[mouse.screen].widget,
			function(new_name)
				if not new_name or #new_name == 0 then
					return
				else
					local screen = mouse.screen
					local tag = awful.tag.selected(screen)
					if tag then
						tag.name = new_name
					end
				end
		end)
	end),

	awful.key({OPTIONS.modkey, }, "c",
		function()
			awful.prompt.run({ prompt = " | TAG: "  },
			prompt[mouse.screen].widget,
			function(new_name)
				if not new_name or #new_name == 0 then
					return
				else
					local screen = mouse.screen
					t = awful.tag.add(new_name)
					awful.tag.viewonly(t)
				end
			end)
		end)
)

---

main_wibox.separator = separator
main_wibox.textclock = textclock

main_wibox.volumemeter = volumemeter
main_wibox.powermeter = powermeter

main_wibox.prompt = prompt
main_wibox.layoutbox = layoutbox
main_wibox.taglist = taglist
main_wibox.tasklist = tasklist

---
---

return main_wibox
