local awful = require("awful")
local tags = awful.tag.gettags(1)

return {
	{ -- Applications to do with communication.
		rule_any = { class = {"Skype", "Pidgin"} },
			properties = { tag = tags[1] },
      
    rule_any = { class = {"Firefox"} },
      properties = { tag = tags[2] }

      
	}
}


