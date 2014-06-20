local awful = require("awful")
local themedir = awful.util.getdir("config") .. "/themes/darkbow"

return {

	font          = "sans 8",

	bg_normal     = "#222222",
	bg_focus      = "#444444",
	bg_urgent     = "#ff0000",
	bg_minimize   = "#2B4FBA",
	bg_systray    = bg_normal,

	fg_normal     = "#aaaaaa",
	fg_focus      = "#ffffff",
	fg_urgent     = "#ffffff",
	fg_minimize   = "#ffffff",

	border_width  = 1,
	border_normal = "#000000",
	border_focus  = "#535d6c",
	border_marked = "#91231c",

	taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png",
	taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png",

	menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png",
	menu_height = 15,
	menu_width  = 100,

	wallpaper = themedir .. "/background.png",

	layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png",
	layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png",
	layout_floating  = "/usr/share/awesome/themes/default/layouts/floatingw.png",
	layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png",
	layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png",
	layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png",
	layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png",
	layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png",
	layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png",
	layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png",
	layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png",
	layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png",

	awesome_icon = themedir .. "/icons/awesome16_rainbow.png",

	-- Define the icon theme for application icons. If not set then the icons
	-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
	icon_theme = nil

}
