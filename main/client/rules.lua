local awful = require("awful")
local tags = awful.tag.gettags(1)

return {
	{
		rule = { class = "Skype" },
		properties = { tag = tags[3] }
	},

	{
		rule = { class = "Steam" },
		properties = { tag = tags[3] }
	}
}
