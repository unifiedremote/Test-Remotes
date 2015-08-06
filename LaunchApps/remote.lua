--@help left
actions.left = function()
	libs.keyboard.press("LEFT");
end

--@help right
actions.right = function()
	libs.keyboard.press("RIGHT");
end

--@help up
actions.up = function()
	libs.keyboard.press("UP");
end

--@help down
actions.down = function()
	libs.keyboard.press("DOWN");
end

--@help return
actions["return"] = function()
	libs.keyboard.press("RETURN");
end

--@help back
actions.back = function()
	libs.keyboard.stroke("BACK");
end

--@help close_app
actions.close_app = function()
	libs.keyboard.stroke("MENU","F4");
end

--@help start_chrome
actions.start_chrome = function()
	os.start("C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe");
end

--@help start_plex
actions.start_plex = function()
	os.start("C:\\a_programs\\Plex Home Theater\\Plex Home Theater.exe");
end

--@help start_xbmc
actions.start_xbmc = function()
	os.start("C:\\a_programs\\XBMC\\XBMC.exe");
end

--@help start_internet_explorer
actions.start_internet_explorer = function()
	os.start("iexplore.exe");
end

--@help start_windows_media_player
actions.start_windows_media_player = function()
	os.start("wmplayer.exe");
end

--@help minimize_all
actions.minimize_all = function()
	libs.keyboard.stroke("LWIN","M");
end

