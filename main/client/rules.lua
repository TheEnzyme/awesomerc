local awful = require("awful")
local tags = awful.tag.gettags(1)

return {
	{ -- Applications to do with communication.
		rule_any = { class = {"Skype", "Mumble"} },
		properties = { tag = tags[1] }
	}
}
