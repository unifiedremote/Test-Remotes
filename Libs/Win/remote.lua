
-- Metadata

local server = libs.server;
local win = libs.win;
local process = "uTorrent.exe";

actions.start_app_without_exe = function ()
	os.start("chrome");
end

actions.start_app_with_exe = function ()
	os.start("chrome.exe");
end

actions.start_without_exe = function ()
	os.start("calc");
end

actions.start_with_exe = function ()
	os.start("calc.exe");
end

actions.start_relative = function ()
	os.start("");
end

actions.start_absolute = function ()
	os.start("C:/Windows/notepad.exe");
end

actions.start_vars = function ()
	os.start("%windir%/notepad.exe");
end

actions.start_bad = function ()
	os.start("laskjdlaksjdflkasjf");
end

actions.start_args = function ()
	os.start("cmd", "/k", "ipconfig");
end

actions.start_args_table = function ()
	os.start("cmd", { "/k", "ipconfig" });
end

actions.open_http = function ()
	os.open("http://www.google.com");
end

actions.open_www = function ()
	os.open("www.youtube.com");
end

actions.open_file = function ()
	os.open("C:/Test.txt");
end

actions.open_dir = function ()
	os.open("C:/Windows");
end

actions.open_cp = function ()
	os.open("control mouse");
end

-------------------------------------------------------------------------------------
-- Windows
-------------------------------------------------------------------------------------

actions.desktop = function ()
	server.update({ id = "info", text = win.desktop() });
end

actions.desktop_title = function ()
	server.update({ id = "info", text = win.title(win.desktop()) });
end

actions.active = function ()
	server.update({ id = "info", text = win.active() });
end

actions.find_class = function ()
	server.update({ id = "info", text = win.find("Chrome_WidgetWin_1", nil) });
end

actions.find_title = function ()
	server.update({ id = "info", text = win.find(nil, "Calculator") });
end

actions.find_both = function ()
	server.update({ id = "info", text = win.find("CalcFrame", "Calculator") });
end

actions.find_none = function ()
	server.update({ id = "info", text = win.find(nil, nil) });
end

actions.post = function ()
	server.update({ id = "info", text = win.post(win.window("spotify.exe"), 0x0319, 0, 917504) });
end

actions.post_bad = function ()
	server.update({ id = "info", text = win.post(0, 0, 0, 0) });
end

actions.send = function ()
	server.update({ id = "info", text = win.send(win.window("spotify.exe"), 0x0319, 0, 917504) });
end

actions.send_bad = function ()
	server.update({ id = "info", text = win.send(0, 0, 0, 0) });
end

-------------------------------------------------------------------------------------
-- Misc
-------------------------------------------------------------------------------------

actions.active = function ()
	server.update({ id = "info", text = win.active() });
end

actions.active_title = function ()
	server.update({ id = "info", text = win.title(win.active()) });
end

actions.active_title = function ()
	server.update({ id = "info", text = win.title(win.active()) });
end

actions.process = function ()
	server.update({ id = "info", text = win.process(process) });
end

actions.process_bad = function ()
	server.update({ id = "info", text = win.process("asdf") });
end

actions.window = function ()
	server.update({ id = "info", text = win.window(process) });
end

actions.window_bad = function ()
	server.update({ id = "info", text = win.window("asdf") });
end

actions.title = function ()
	server.update({ id = "info", text = win.title(process) });
end

actions.title_bad = function ()
	server.update({ id = "info", text = win.title("asdf") });
end

actions.switchto = function ()
	server.update({ id = "info", text = win.switchto(process) });
end

actions.switchto_bad = function ()
	server.update({ id = "info", text = win.switchto("asdf") });
end

actions.switchtowait = function ()
	server.update({ id = "info", text = win.switchtowait(process) });
end

actions.switchtowait_bad = function ()
	server.update({ id = "info", text = win.switchtowait("asdf") });
end

actions.switchtowait3sec = function ()
	local text = win.switchtowait(process, 3000);
	print("done!");
	server.update({ id = "info", text = text });
end

actions.switchtowait3sec_bad = function ()
	local text = win.switchtowait("asdf", 3000);
	print("done!");
	server.update({ id = "info", text = text });
end

actions.kill = function ()
	win.kill(process);
end

actions.kill_bad = function ()
	win.kill("asdf");
end

actions.close = function ()
	win.close(process);
end

actions.close_bad = function ()
	win.close("asdf");
end

actions.quit = function ()
	win.quit(process);
end

actions.quit_bad = function ()
	win.quit("asdf");
end

actions.list = function ()
	local tasks = win.list();
	for i,task in ipairs(tasks) do
		print(win.title);
	end
	print(win.list());
end
