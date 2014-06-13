local awful = require("awful")
local tags = awful.tag.gettags(1)

return {
	{ -- Clients which open on [comm] tag.
		rule_any = { class = {"Skype", "Mumble"} },
		properties = { tag = tags[3] }
	}
}
