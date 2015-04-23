local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")

local awutil = require("lib.self.awutil")

local wibox_main = {}
local awesomeicon = wibox.widget.imagebox(beautiful.awesome_icon)

-- Define all the widgets
local cpumeter = wibox.widget.textbox()
vicious.register(cpumeter, vicious.widgets.cpu, "| CPU: $1% ", 7)

local rammeter = wibox.widget.textbox()
vicious.register(rammeter, vicious.widgets.mem, "| RAM: $1% ", 13)

local wifimeter = wibox.widget.textbox()
vicious.register(wifimeter, vicious.widgets.wifi, "SSID: ${ssid} | WIFI: ${linp}% ", 11, "wlan0")

local powermeter = wibox.widget.textbox() 
vicious.register(powermeter, vicious.widgets.bat, "| BAT: $2%$1 ", 43, "BAT0")

local volumemeter = wibox.widget.textbox()
vicious.register(volumemeter, vicious.widgets.volume, "| VOL: $1% $2 ", 1, "Master")

local textclock = wibox.widget.textbox()
vicious.register(textclock, vicious.widgets.date, "| %I:%M %p " , 47)


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
local promptbox = {}
local layoutbox = {}

local padding = wibox.widget.textbox()
padding:set_text(" ")

-- Adding the widgets.
for s=1, screen.count() do

	-- Create a promptbox for each screen.
	promptbox[s] = awful.widget.prompt{prompt = "RUN: "}

	-- Create a layoutbox for each screen (shows the current layout).
	layoutbox[s] = awful.widget.layoutbox(s)

	-- Taglist
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

	-- Tasklist
	tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused)


	-- The actual wibox.
	wibox_main[s] = awful.wibox{ position = "top", height = '25', screen = s }


	-- Widgets aligned to the left of the wibox.
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(taglist[s])
  left_layout:add(padding)
	left_layout:add(promptbox[s])
  left_layout:add(padding)

	-- Widgets aligned to the right.
	local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(wifimeter)
  right_layout:add(cpumeter)
  right_layout:add(rammeter)
  right_layout:add(volumemeter)
  right_layout:add(powermeter)
	right_layout:add(textclock)
  if s == 1 then
		right_layout:add(wibox.widget.systray()) -- Add systray only to screen 1.
	end
  right_layout:add(padding)
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
