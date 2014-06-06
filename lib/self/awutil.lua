local awutil = {}

local awful = require("awful")
awful.rules = require("awful.rules")

--- Add keys to the global key registry.
-- @param keys A table of key objects.
function awutil.add_global_keys(keys)
	root.keys( awful.util.table.join(root.keys(), table.unpack(keys)) )
end

--- Add client rules to Awful's rules list.
-- @param rules A table of rules (which are themselves tables).
function awutil.add_client_rules(rules)
	awful.rules.rules = awful.util.table.join(awful.rules.rules, rules)
end

return awutil
