if USERTHEME then
	beautiful.init(string.format("%s/themes/%s/theme.lua",  awful.util.getdir("config"), THEME))
else
	beautiful.init(string.format("/usr/share/awesome/themes/%s/theme.lua",  THEME))
end

-- Put wallpapers on screens.
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
