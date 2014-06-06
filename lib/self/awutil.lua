local awutil = {}

local awful = require("awful")
awful.rules = require("awful.rules")

function awutil.add_global_keys(keys)
	root.keys( awful.util.table.join(root.keys(), table.unpack(keys)) )
end

function awutil.add_client_rules(rules)
	awful.rules.rules = awful.util.table.join(awful.rules.rules, rules)
end

return awutil
