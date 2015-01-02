local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")

local awutil = require("lib.self.awutil")

local wibox_main = {}


local textclock = wibox.widget.textbox()
vicious.register(textclock, vicious.widgets.date, "%I:%M %p " , 30)

local mybattery = wibox.widget.textbox() 
vicious.register(mybattery, vicious.widgets.bat, " Battery: $2% ", 30, "BAT1")

local awesomeicon = wibox.widget.imagebox(beautiful.awesome_icon)

local taglist = {}
taglist.buttons = awful.util.table.join(

	-- Left click -> view only that tag.
	awful.button({ }, 1, awful.tag.viewonly),

	-- Mod + left click -> set this tag as the current client's only tag.
	awful.button({ MODKEY }, 1, awful.client.movetotag),

	-- Right click -> toggle visibilty of this tag.
	awful.button({ }, 3, awful.tag.viewtoggle),

	-- Mod + right click -> toggle whether current client has this tag.
	awful.button({ MODKEY }, 3, awful.client.toggletag)

)

local tasklist = {}
tasklist.buttons = awful.util.table.join(
	-- Left click
	awful.button({ }, 1, function(c)
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

local promptbox = {}
local layoutbox = {}

-- Adding the widgets.
for s=1, screen.count() do

	-- Create a promptbox for each screen.
	promptbox[s] = awful.widget.prompt()

	-- Create a layoutbox for each screen (shows the current layout).
	layoutbox[s] = awful.widget.layoutbox(s)

	-- Taglist
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

	-- Tasklist
	tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)


	-- The actual wibox.
	wibox_main[s] = awful.wibox{ position = "top", screen = s }


	-- Widgets aligned to the left of the wibox.
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(taglist[s])
	left_layout:add(promptbox[s])

	-- Widgets aligned to the right.
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then
		right_layout:add(wibox.widget.systray()) -- Add systray only to screen 1.
	end
	right_layout:add(mybattery)
	right_layout:add(textclock)
	right_layout:add(layoutbox[s])
	

	-- Put it all together.
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(tasklist[s])
	layout:set_right(right_layout)

	wibox_main[s]:set_widget(layout)
end

awutil.add_global_keys{
	awful.key( { MODKEY }, "r", function()  promptbox[mouse.screen]:run()  end)
}
