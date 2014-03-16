-- Autostart
-- http://awesome.naquadah.org/wiki/Autostart#The_native_lua_way
require("lfs")
local function processwalker()
	local function yieldprocess()
		for dir in lfs.dir("/proc") do
			-- All directories in /proc containing a number, represent a process
			if tonumber(dir) then
				local f, err = io.open("/proc/"..dir.."/cmdline")
				if f then
					local cmdline = f:read("*all")
					f:close()
					if cmdline ~= "" then
						coroutine.yield(cmdline)
					end
				end
			end
		end
	end
	return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
	assert(type(process) == "string")
	local regex_killer = {
		["+"]  = "%+", ["-"] = "%-",
		["*"]  = "%*", ["?"]  = "%?"
	}

	for p in processwalker() do
		if p:find(process:gsub("[-+?*]", regex_killer)) then
			return
		end
	end
	return awful.util.spawn(cmd or process)
end


for n,item in ipairs(AUTOSTART) do
	if type(item) == "string" then
		run_once(item)
	elseif type(item) == "table" then
		run_once(item[1],item[2])
	else
		naughty.notify{
			preset = naughty.config.presets.critical,
			title = "Autostart error",
			text = string.format("Item %d was not a string or a table.",  n)
		}
	end
end
