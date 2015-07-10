local server = libs.server;
local http = libs.http;
local utf8 = libs.utf8;
local timer = libs.timer;
local data = libs.data;
local win = libs.win;

local keys;
local selectedPlaylist;

include("common.lua")
include("playlist.lua")
include("search.lua");
include("webhelper.lua");

-------------------------------------------------------------------------------------------
-- Native Stuff
-------------------------------------------------------------------------------------------

local WM_LBUTTONDOWN = 0x0201;
local WM_LBUTTONUP = 0x0202;
local WM_APPCOMMAND = 0x0319;
local CMD_PLAY_PAUSE = 917504;
local CMD_VOLUME_DOWN = 589824;
local CMD_VOLUME_UP = 655360;
local CMD_STOP = 851968;
local CMD_PREVIOUS = 786432;
local CMD_NEXT = 720896;
local CMD_MUTE = 524288;

local bit = require("bit");
local ffi = require("ffi");
ffi.cdef[[
typedef void* HWND;
typedef long LONG;
typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;
bool GetWindowRect(LONG hwnd, RECT* rect);
]]

function click(hwnd, x, y)
	local pos = bit.lshift(y, 16) + x;
	win.post(hwnd, WM_LBUTTONDOWN, 0x01, pos);
	os.sleep(100);
	win.post(hwnd, WM_LBUTTONUP, 0x00, pos);
end

function get_hwnd()
	local hwnd = win.find("SpotifyMainWindow", nil);
	hwnd = win.find(hwnd, 0, "CefBrowserWindow", nil);
	hwnd = win.find(hwnd, 0, "Chrome_WidgetWin_0", nil);
	hwnd = win.find(hwnd, 0, "Chrome_RenderWidgetHostHWND", nil);
	return hwnd;
end

-------------------------------------------------------------------------------------------
-- State
-------------------------------------------------------------------------------------------

events.focus = function()
	webhelper_init(function ()
		stop = false;
		playlist_init();
		--update();
	end)
end

events.blur = function ()
	stop = true;
end

-------------------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------------------

--@help Send raw command to Spotify
--@param cmd:number
actions.command = function (cmd)
	local hwnd = win.find("SpotifyMainWindow", nil);
	win.send(hwnd, WM_APPCOMMAND, 0, cmd);
end

actions.selected = function(index)
	playlist_select(index);
end

--@help Next track
actions.next = function ()
	actions.command(CMD_NEXT);
end

--@help Previous track
actions.previous = function ()
	actions.command(CMD_PREVIOUS);
end

--@help Start playback
actions.play = function()
	if (not Playing) then
		actions.play_pause();
	end
end

--@help Pause playback
actions.pause = function()
	if (Playing) then
		actions.play_pause();
	end
end

--@help Toggle playback state
actions.play_pause = function()
	actions.command(CMD_PLAY_PAUSE);
end

--@help Toggle Shuffle 
actions.shuffle = function ()
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	click(hwnd, rect.right - rect.left - 202, rect.bottom - rect.top - 30);
	click(hwnd, 0, 0);
end

--@help Toggle Repeat 
actions.repeating = function ()
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	click(hwnd, rect.right - rect.left - 170, rect.bottom - rect.top - 30);
	click(hwnd, 0, 0);
end

--@help Change Volume
--@param vol:number Set Volume
actions.volchange = function (vol)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	local y = rect.bottom - rect.top - 30;
	local x = (rect.right - rect.left - 107) + math.floor(vol / 100 * 79) + 1;
	click(hwnd, x, y);
end

--@help Change Position
--@param pos:number Set Position
actions.poschange = function (pos)
	local hwnd = get_hwnd();
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	
	local y = rect.bottom - rect.top - 30;
	local x1 = 214;
	local x2 = rect.right - rect.left - 366;
	local w = x2 - x1;
	local x = x1 + math.floor(pos / 100 * w) + 1;
	click(hwnd, x, y);
end

--@help Navigate back
actions.back = function()
	playlist_back();
end

function update ()
	webhelper_get_status(function (status)
		print("updating status ...");
		
		if (stop) then
			print("stopping");
			return;
		end
		
		playing = status.playing ~= 0;
		local volume = math.ceil(status.volume * 100);
		
		local track = "";
		local artist = "";
		local album = "";
		local pos = 0;
		local duration = 0;
		local uri = "";
		
		if (status.track ~= nil) then
			uri = status.track.track_resource.uri;
			pos = math.ceil(status.playing_position);
			duration = math.ceil(status.track.length);
		
			if (status.track.artist_resource ~= nil) then
				artist = status.track.artist_resource.name;
			else
				artist = "Unknown";
			end
			if (status.track.track_resource ~= nil) then
				track = status.track.track_resource.name;
			else
				track = "Unknown";
			end
			if (status.track.album_resource ~= nil) then
				album = status.track.album_resource.name;
			else
				album = "";
			end
		end

		if (uri ~= playing_uri) then
			playing_uri = uri;
			--server.update({ id = "currimg", image = get_cover_art(uri) });
		end
		
		local name = track .. " - " .. artist;
		if (track == "" and artist == "") then
			name = "[Not Playing]";
		end
		
		local icon = "play";
		if (playing) then
			icon = "pause";
		end
		
		Playing = playing;
		
		server.update(
			{ id = "currtitle", text = name },
			{ id = "currvol", progress = volume },
			{ id = "currpos", progress = math.floor(pos / duration * 100), progressMax = 100, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) },
			{ id = "play", icon = icon }
		);

		timer.timeout(update, 1000);
	end);
end
