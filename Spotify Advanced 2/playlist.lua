local http = libs.http;
local utf8 = libs.utf8;
local state = 0;
local meinfo;
playlist = {};
local tracks;
local savedTracks = {};
local trackitems = {};
local playlistsinfo;
local offset = 0;

local PLAYLIST_STATE_INIT = 0;
local PLAYLIST_STATE_LISTS = 1;
local PLAYLIST_STATE_TRACKS = 2;

local playlist_lists;
local playlist_current;
local playlist_tracks;
local playlist_state;

function playlist_init ()
	playlist_state = 0;

	local url = "https://api.spotify.com/v1/me";
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			meinfo = nil;
		else
			meinfo = libs.data.fromjson(resp.content);
			playlist_state = 0;
			playlist_select();
		end
	end);
end

function playlist_back ()
	playlist_state = playlist_state - 1;
	playlist_update();
end

function playlist_update ()

	if (playlist_state == 0) then
		local items = {};
		for i = 1, #playlist_lists.items do
			table.insert(items, { type = "item", text = playlist_lists.items[i].name});
		end
		libs.server.update({
			id= "playlists",
			children = items
		});
		playlist_state = 1;
		
	elseif (playlist_state == 1) then
		playlist_current = playlist_lists.items[index+1];
		playlist_get_tracks(0);
		playlist_state = 2;
		
	elseif (playlist_state == 2) then
		if (#savedTracks > index) then
			play(savedTracks[index +1].track.uri, playlist_current.uri);
		else
			offset = offset + 100;
			playlist_get_tracks(offset);
		end
		
	end
end

function playlist_select (index)
	if (playlist_state == 0) then
		playlist_get_lists();
		
	elseif (playlist_state == 1) then
		playlist_current = playlist_lists.items[index+1];
		playlist_get_tracks(0);
		
	elseif (playlist_state == 2) then
		if (#savedTracks > index) then
			play(savedTracks[index +1].track.uri, playlist_current.uri);
		else
			offset = offset + 100;
			playlist_get_tracks(offset);
		end
		
	end
end

function playlist_get_lists ()
	print("loading lists ...");
	local url = "https://api.spotify.com/v1/users/" .. meinfo.id .. "/playlists"; 
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			print("err: " .. err);
			playlist_lists = nil;
		else
			print("got lists");
			playlist_lists = libs.data.fromjson(resp.content);
			playlist_update();
		end
	end);
end

function playlist_get_tracks(offset)
	print("loading tracks ...");
	
	local url = "https://api.spotify.com/v1/users/";
	url = url .. playlist_current.owner.id .. "/playlists/";
	url = url .. playlist_current.id .. "/tracks?fields=items.track(uri,name,available_markets),total,next&limit=100&offset="..offset;
	
	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			print("err: " .. err);
			tracks = nil;
		else
			local pllist= libs.data.fromjson(resp.content);
			
			playlist_tracks = pllist.items;
			if (playlist_tracks ~= nil) then
				if (#trackitems > 0 and utf8.equals(trackitems[#trackitems].text, "Load more tracks...")) then
					table.remove(trackitems, #trackitems);
				end
				for i = 1, #playlist_tracks do
					if (playlist.contains(playlist_tracks[i].track.available_markets, meinfo.country)) then
						table.insert(trackitems, { type = "item", text = playlist_tracks[i].track.name});
						table.insert(savedTracks, playlist_tracks[i]); 
					end
				end
				if (pllist.next ~= nil) then 
					table.insert(trackitems, { type = "item", text="Load more tracks..."});
				end
				libs.server.update({
					id= "playlists",
					children = trackitems
				});
				print("num tracks:" .. #playlist_tracks);
			end
			playlist_state = 2;
		end
	end);
end

function playlist.contains(list, item) 
	for i = 1, #list do
		if (utf8.equals(list[i], item)) then
			return true;
		end
	end
	return false;
end