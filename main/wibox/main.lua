local awful = require("awful")

local wibox_main = {}

local wi_textclock = awful.widget.textclock()

local wibox_main_taglist = {}
wibox_main_taglist.buttons = awful.util.table.join(

	-- Left click -> view only that tag.
	awful.button({ }, 1, awful.tag.viewonly),

	-- Mod + left click -> set this tag as the current client's only tag.
	awful.button({ modkey }, 1, awful.client.movetotag),

	-- Right click -> toggle visibilty of this tag.
	awful.button({ }, 3, awful.tag.viewtoggle),

	-- Mod + right click -> toggle whether current client has this tag.
	awful.button({ modkey }, 3, awful.client.toggletag)

)

local wibox_main_tasklist = {}
wibox_main_tasklist.buttons = awful.util.table.join(
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

local wibox_main_promptbox = {}
local wibox_main_layoutbox = {}

-- Adding the widgets.
for s=1, screen.count() do

	-- Create a promptbox for each screen.
	wibox_main_promptbox[s] = awful.widget.prompt()

	-- Create a layoutbox for each screen (shows the current layout).
	wibox_main_layoutbox[s] = awful.widget.layoutbox(s)

	-- Taglist
	wibox_main_taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, wi_taglist.buttons)

	-- Tasklist
	wibox_main_tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, wi_tasklist.buttons)


	-- The actual wibox.
	wibox_main[s] = awful.wibox{ position = "top", screen = s }

	-- Widgets aligned to the left of the wibox.
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(wibox_main_taglist[s])
	left_layout:add(wibox_main_promptbox[s])

	-- Widgets aligned to the right.
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then
		right_layout:add(wibox.widget.systray()) -- Add systray only to screen 1.
	end
	right_layout:add(wibox_main_textclock)
	right_layout:add(wibox_main_layoutbox[s])

	-- Put it all together.
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(wibox_main_tasklist[s])
	layout:set_right(right_layout)

	wibox_main[s]:set_widget(layout)
end

-- Set relevant key bindings.
awful.key( { MODKEY }, "r", function()  wi_promptbox[mouse.screen]:run()  end )
