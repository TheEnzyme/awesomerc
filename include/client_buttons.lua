local OPTIONS, MOD = ...

local awful = require("awful")

---

return awful.util.table.join(
	awful.button({                }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ OPTIONS.modkey }, 1, awful.mouse.client.move),
	awful.button({ OPTIONS.modkey }, 3, awful.mouse.client.resize) 
)
