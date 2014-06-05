local awutil = {}

local awful = require("awful")

local awesome_rules = require("awful.rules")

function awutil.add_global_keys(keys)
	root.keys( awful.util.table.join(root.keys(), table.unpack(keys)) )
end

function awutil.add_client_rules(rules)
	awesome_rules = awful.util.table.join(awesome_rules, rules)
end

return awutil
