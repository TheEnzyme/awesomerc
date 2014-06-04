local in_error = false
awesome.connect_signal("debug::error", function (err)
	if in_error then return end -- Make sure we don't go into an endless error loop.
	in_error = true

	naughty.notify{
		preset = naughty.config.presets.critical,
		title = "A Lua error has occured.",
		text = err
	}

	in_error = false
end)
