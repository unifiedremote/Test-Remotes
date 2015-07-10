local d = libs.data;
local http = libs.http;
local utf8 = libs.utf8;
local server = libs.server;

local query = nil;
local mainitems = {};
local trackitems = {};
local meinfo = nil;
actions.changetab = function (index)
	print(index);
	if(index == 2) then
		libs.http.request({ method = "get", url = "https://api.spotify.com/v1/me", connect = "spotify" }, 
			function (err, resp)
				if (err) then
					meinfo = nil;
				else
					print(resp.content);
					meinfo = libs.data.fromjson(resp.content);
				end
			end
		);
	end
end

actions.changeq = function (text)
   	query = text;
end
actions.go = function ( )
	local types = {};
	table.insert(types, "track");
	table.insert(types, "album");
	table.insert(types, "artist"); 
	table.insert(types, "playlist");

	local url = "https://api.spotify.com/v1/search?q=" .. query .. "&type=" .. utf8.join(",", types) .. "&limit=3";

	libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else
					print("Success");
					--print(resp.content);
					
					local res = libs.data.fromjson(resp.content);
					
					if(res.tracks ~= nil) then
						table.insert(mainitems, {type = "item", text = "Tracks",  checked = true, stype = 5});
						local titems = res.tracks.items;
						for i = 1, #titems do
							table.insert(mainitems, {type = "item", text = titems[i].name, stype = 1, track = titems[i]});
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
			end
		);
end


actions.mainlist = function ( id )
	id = id+1;
	local it = mainitems[id];
	if(it.stype == 1) then
		play(it.track.uri, "");
	elseif(it.stype == 5) then
		server.update({id = "mainlist", visibility="gone"});
		server.update({id = "tracklist", visibility="visible"});
		local url = "https://api.spotify.com/v1/search?q=" .. query .. "&type=track&limit=50";
		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else
					print("Success");
					local res = libs.data.fromjson(resp.content);
					if(res.tracks ~= nil) then
						local titems = res.tracks.items;
						for i = 1, #titems do
							table.insert(trackitems, {type = "item", text = titems[i].name, track = titems[i]});
						end
					end
					server.update({id = "tracklist", children = trackitems});
				end
			end
		);
	elseif (it.stype == 2) then
		server.update({id = "mainlist", visibility = "gone"});
		server.update({id = "artistInfoList", visibility = "visible"});
		local url = "https://api.spotify.com/v1/artists/" .. it.artist.id .. "/top-tracks?country=" .. meinfo.country;
		print(url);
		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else 
					print("Success");
					local res = libs.data.fromjson(resp.content);
					if(res.tracks ~= nil) then
						local titems = res.tracks.items;
						for i = 1, #titems do
							table.insert(trackitems, {type = "item", text = titems[i].name, track = titems[i]});
						end
					end
					server.update({id = "artistInfoList", children = trackitems});
				end
			end
		);
	elseif (it.stype == 3) then
		server.update({id = "mainlist", visibility = "gone"});
		server.update({id = "playlistlist", visibility="gone"});
		server.update({id = "playlisttracklistlist", visibility = "visible"});
		local url = it.playlist.href;
		print(url);
		libs.http.request({ method = "get", url = url, connect = "spotify" }, 
			function (err, resp)
				if (err) then
					print("Error");
				else 
					print("Success");
					local res = libs.data.fromjson(resp.content);
					print(resp.content);
					if(res.tracks ~= nil) then
						local titems = res.tracks.items;
						for i = 1, #titems do
							table.insert(trackitems, {type = "item", text = titems[i].name,  playlist = titems[i]});
						end
					end
					server.update({id = "playlisttracklist", children = trackitems});
				end
			end
		);
	elseif (it.stype == 7) then
		server.update({id = "mainlist", visibility="gone"});
		server.update({id = "playlistlist", visibility="visible"});
		local url = "https://api.spotify.com/v1/search?q=" .. query .. "&type=playlist&limit=50";
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

actions.playlisttracklist = function ( id )
	id = id + 1;
	local it = trackitems[id];
	print(it.playlist);
	play(it.track.track.uri,it.playlist);
end

actions.tracklist = function ( id )
	id = id + 1;
	local it = trackitems[id];
	print(it.track.uri);
	play(it.track.uri,"");
end