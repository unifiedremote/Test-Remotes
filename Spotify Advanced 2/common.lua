local server = libs.server;
local timer = libs.timer;
local http = libs.http;
local data = libs.data;
local utf8 = libs.utf8;

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
			print(result);
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
			{ id = "currpos", progress = math.floor(pos / duration * 100), progressMax = 100, text = libs.data.sec2span(pos) .. " / " .. libs.data.sec2span(duration) }
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
	server.update({ id = "play", icon = icon });
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
