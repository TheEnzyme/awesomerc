local awful = require("awful")
local themedir = awful.util.getdir("config") .. "/themes"

return {

	font          = "DejaVu Sans 10",
	bg_normal     = "#2b303b",
	bg_focus      = "#65737e", 
	bg_urgent     = "#bf616a",
	bg_minimise   = bg_normal,
	bg_systray    = bg_normal,

	fg_normal     = "#c0c5ce",
	fg_focus      = "#c0c5ce",
	fg_urgent     = "#c0c5ce",
	fg_minimize   = "#ffffff",

	border_width  = 2,
	border_normal = "#65737e",
	border_focus  = "#8fa1b3",
	border_marked = "#2b303b",

	tasklist_bg_normal = bg_normal,
	tasklist_bg_focus  = "#2b303b",

	tasklist_fg_normal = fg_normal,
	tasklist_fg_focus  = fg_normal,

	menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png",
	menu_height = 15,
	menu_width  = 100,

	wallpaper = themedir .. "/background/dresden_minimal.png",

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

	awesome_icon = themedir .. "/icons/awesome16.png",

	-- Define the icon theme for application icons. If not set then the icons
	-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
	icon_theme = nil

}
