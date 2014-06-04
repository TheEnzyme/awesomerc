local awful = require("awful")

return awful.util.table.join(
	awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ MODKEY }, 1, awful.mouse.client.move),
	awful.button({ MODKEY }, 3, awful.mouse.client.resize)
)
