local d = require("data");
local http = require("http");
local utf8 = require("utf8");
local server = require("server");
local timer = require("timer");

local query = nil;
local mainitems = {};
local trackitems = {};

include("spotify_api_v1.lua");

actions.changed_search = function (text)
   	query = text;
end

actions.go = function ( )
	local types = { "track", "album", "artist", "playlist" };

	local url = spotify_api_v1_url("/search?q=" .. query .. "&type=" .. utf8.join(",", types) .. "&limit=5" );
	print(url);
	mainitems = {};
	server.update({
		{id = "mainlist", visibility="visible", children = {{ type = "item", text = "Searching..."}} },
		{id = "playlistlist", 		visibility="gone"},
		{id = "tracklist", 			visibility="gone"},
		{id = "artistinfolist", 	visibility="gone"}
	});

	http.request({ method = "get", url = url, connect = "spotify" }, function (err, resp)
		if (err) then
			print("Error");
		else
			print("Success");
			
			local res = libs.data.fromjson(resp.content);

			if(res.tracks ~= nil) then
				table.insert(mainitems, {type = "item", text = "Tracks",  checked = true, stype = 5});
				local titems = res.tracks.items;
				for i = 1, #titems do
					local fmt = format_track(titems[i]);
					local checked = titems[i].uri == playing_uri;
					table.insert(mainitems, {type = "item", text = fmt, stype = 1, track = titems[i], checked = checked});
				end
			end
			if(res.artists ~= nil) then
				table.insert(mainitems, {type = "item", text = "Artists",  checked = true, stype = 6});
				local titems = res.artists.items;
				for i = 1, #titems do
					table.insert(mainitems, {type = "item", text = titems[i].name, stype = 2, artist = titems[i]});
				end
			end
			if(res.albums ~= nil) then
				table.insert(mainitems, {type = "item", text = "Albums",  checked = true, stype = 4});
				local aitems = res.albums.items;
				for i = 1, #aitems do
					table.insert(mainitems, {type = "item", text = aitems[i].name, stype = 0, album = aitems[i]});
				end
			end
			if(res.playlists ~= nil) then
				table.insert(mainitems, {type = "item", text = "Playlists",  checked = true, stype = 7});
				local titems = res.playlists.items;
				for i = 1, #titems do
					table.insert(mainitems, {type = "item", text = titems[i].name, stype = 3, playlist = titems[i]});
				end
			end
			server.update({id = "mainlist", children = mainitems});
		end
	end);
end


actions.mainlist = function ( id )
	id = id + 1;
	local it = mainitems[id];
	
	-- If press on track in search
	if(it.stype == 1) then
		webhelper_play(it.track.uri, "");
		playing_uri = it.track.uri;
		actions.go();
		timer.timeout(function()
			playing_uri = it.track.uri;
			actions.go();
		end, 1000);
	end

	-- If tracks
	if(it.stype == 5) then
		server.update({
			{id = "mainlist", visibility = "gone"},
			{id = "tracklist", visibility = "visible"}
		});

		local url = spotify_api_v1_url("/search?q=" .. query .. "&type=track&limit=50");
		http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else
					print("Success");
					local res = libs.data.fromjson(resp.content);
					if(res.tracks ~= nil) then
						print(resp.content);
						local titems = res.tracks.items;
						for i = 1, #titems do
							local fmt = format_track(titems[i]);
							table.insert(trackitems, {type = "item", text = fmt, track = titems[i]});
						end
					end
					server.update({id = "tracklist", children = trackitems});
				end
			end
		);
	end

	-- If press on artist
	if (it.stype == 2) then
		server.update({
			{id = "mainlist", visibility = "gone"},
			{id = "artistinfolist", visibility = "visible"}
		});

		local url = spotify_api_v1_url("/artists/" .. it.artist.id .. "/top-tracks?country=" .. meinfo.country);

		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else 
					print("Success");
					local res = libs.data.fromjson(resp.content);
					if(res.tracks ~= nil) then
						print(resp.content);
						local titems = res.tracks;
						trackitems = {};
						for i = 1, #titems do
							local fmt = titems[i].name .. "\n" .. "Popularity: " .. titems[i].popularity .. " /  100"
							table.insert(trackitems, {type = "item", text = fmt, track = titems[i]});
						end
					end
					server.update({id = "artistinfolist", children = trackitems});
				end
			end
		);
	end 

	if (it.stype == 3) then
		server.update({
			{id = "mainlist", visibility = "gone"},
			{id = "playlistlist", visibility = "visible"}
		});

		local url = it.playlist.href;
		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else 
					print("Success");
					local res = libs.data.fromjson(resp.content);
					print(resp.content);
					if(res.tracks ~= nil) then
						local titems = res.tracks;
						for i = 1, #titems do
							local fmt = format_track(titems[i]);
							table.insert(trackitems, {type = "item", text = titems[i].name,  playlist = titems[i]});
						end
					end
					server.update({id = "playlist", children = trackitems});
				end
			end
		);
	end

	if (it.stype == 7) then
		server.update({id = "mainlist", visibility="gone"});
		server.update({id = "playlistlist", visibility="visible"});

		local url = spotify_api_v1_url("search?q=" .. query .. "&type=playlist&limit=50");
		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else
					print("Success");
					local res = libs.data.fromjson(resp.content);
					mainitems = {};
					if(res.playlists ~= nil) then
						local titems = res.playlists.items;
						for i = 1, #titems do
							table.insert(mainitems, {type = "item", text = titems[i].name, stype = 3, playlist = titems[i]});
						end
					end
					server.update({id = "playlistlist", children = mainitems});
				end
			end
		);
	end
end

actions.artistinfolist_tap = function ( id )
	
end


actions.playlistlist_tap = function ( id )
	id = id + 1;
	local it = trackitems[id];
	print("playlistlist_tap: " + it.playlist);
	play(it.track.track.uri, it.playlist);
end

actions.tracklist_tap = function ( id )
	id = id + 1;
	local it = trackitems[id];
	local uri = it.track.uri;
	print("tracklist_tap: " .. uri);
	
	play(uri, "");

	playing_uri = uri;
	actions.go();
end