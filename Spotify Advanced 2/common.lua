local server = require("server");
local timer = require("timer");
local http = require("http");
local data = require("data");
local utf8 = require("utf8");

playing = false;
playing_uri = "";

-------------------------------------------------------------------------------------------
-- Spotify Cover Art Grabber
-------------------------------------------------------------------------------------------
function get_cover_art_url (uri, callback)
	local url = "https://embed.spotify.com/oembed/?url=" .. uri;
	http.get(url, function(err, resp) 
		if (err) then
			callback(err, nil);
		else
			local json = data.fromjson(resp);
			local result = utf8.replace(json.thumbnail_url, "cover", "320");
			callback(nil, result);
		end
	end);
end

function get_cover_art (uri, callback)
	get_cover_art_url(uri, function(err, url) 
		http.get(url, function(err, raw)
			callback(err, raw);
		end);
	end);
end


-------------------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------------------


function update ()
	webhelper_get_status(function (status)
		if (stop) then
			print("Stopping update");
			return;
		end

		playing = (status.playing ~= 0);
		
		local volume = 0;
		local track = "";
		local artist = "";
		local album = "";
		local pos = 0;
		local duration = 0;
		local uri = "";

		if (status.volume ~= nil) then
			volume = math.ceil(status.volume * 100);
		end

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
			playlist_update_playing();
			timer.timeout(function ()
				get_cover_art(uri, function(err, img)
					if (err) then
						print("Failed to load image for track " + uri);
					else 
						server.update({ id = "currimg", image = img });
					end
				end);
			end, 100);
		end
		
		local name = track .. " - " .. artist;
		if (track == "" and artist == "") then
			name = "[Not Playing]";
		end
		
		Playing = playing;
		
		server.update(
			{ id = "currtitle", text = name },
			{ id = "currvol", progress = volume },
			{ id = "currpos", progress = math.floor(pos), progressMax = duration, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) }
		);

		server_update_play_state();

		timer.timeout(update, 1000);
	end);
end

function server_update_play_state()
	local icon = "";
	if (not Playing) then
		icon = "play";
	else 
		icon = "pause";
	end
	server.update(
		{ id = "play", icon = icon }
	);
end

function format_artists(artists)
	local builder = {};
	if (#artists == 1) then 
		return artists[1].name
	end
	for i = 1, #artists do
		table.insert(builder, artists[i].name);
	end
	return utf8.join(", ", builder);
end

function format_track(item)
	return format_artists(item.artists) .. " - " .. item.name;
end


-------------------------------------------------------------------------------------------
-- State
-------------------------------------------------------------------------------------------

events.focus = function()
	webhelper_init(function ()
		stop = false;
		playlist_init();
		update();
	end)
end

events.blur = function ()
	stop = true;
end

-------------------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------------------

actions.selected = function(index)
	playlist_select(index);
end

--@help Navigate back
actions.back = function()
	playlist_back();
end

--@help Start playback
actions.play = function()
	if (not Playing) then
		webhelper_resume();
		Playing = true;
		server_update_play_state();
	end
end

--@help Pause playback
actions.pause = function()
	if (Playing) then
		webhelper_pause();
		Playing = false;
		server_update_play_state();
	end
end

--@help Toggle playback state
actions.play_pause = function()
	if (Playing) then 
		actions.pause();
	else
		actions.play();
	end
end
