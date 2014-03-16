-- The main wibox across the top of the screen
wibox_main = {}

wi_awesomelauncher = awful.widget.launcher{
	image = beautiful.awesome_icon,
	menu = awful.menu{
		items = {
			{ "manual", terminal .. " -e man awesome" },
			{ "edit config", "textadept " .. awesome.conffile },
			{ "restart", awesome.restart },
			{ "quit", awesome.quit }
		}
	}
}

wi_textclock = awful.widget.textclock()

wi_taglist = {}
wi_taglist.buttons = awful.util.table.join(
	-- Left click -> view only that tag.
	awful.button({ }, 1, awful.tag.viewonly),

	-- Mod + left click -> set this tag as the current client's only tag.
	awful.button({ modkey }, 1, awful.client.movetotag),

	-- Right click -> toggle visibilty of this tag.
	awful.button({ }, 3, awful.tag.viewtoggle),

	-- Mod + right click -> toggle whether current client has this tag.
	awful.button({ modkey }, 3, awful.client.toggletag)
)

wi_tasklist = {}
wi_tasklist.buttons = awful.util.table.join(

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
	end),

	-- Right click -> shows a menu with all clients in the list.
	awful.button({ }, 3, function()
		if not instance then
			instance = awful.menu.clients{width = 250}
		else
			instance:hide()
			instance = nil
		end
	end)
)

wi_promptbox = {}
wi_layoutbox = {}


-- Adding the widgets.
for s=1, screen.count() do

	-- Create a promptbox for each screen.
	wi_promptbox[s] = awful.widget.prompt()

	-- Create a layoutbox for each screen (shows the current layout).
	wi_layoutbox[s] = awful.widget.layoutbox(s)
	wi_layoutbox[s]:buttons(awful.util.table.join(
		-- Left click -> next layout.
		awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),

		 -- Right click -> previous layout.
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
	))

	-- Taglist
	wi_taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, wi_taglist.buttons)

	-- Tasklist
	wi_tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, wi_tasklist.buttons)


	-- The actual wibox.
	wibox_main[s] = awful.wibox{ position = "top", screen = s }

	-- Widgets aligned to the left of the wibox.
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(wi_awesomelauncher)
	left_layout:add(wi_taglist[s])
	left_layout:add(wi_promptbox[s])

	-- Widgets aligned to the right.
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then
		right_layout:add(wibox.widget.systray()) -- Add systray only to screen 1.
	end
	right_layout:add(wi_textclock)
	right_layout:add(wi_layoutbox[s])

	-- Put it all together.
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(wi_tasklist[s])
	layout:set_right(right_layout)

	wibox_main[s]:set_widget(layout)
end
