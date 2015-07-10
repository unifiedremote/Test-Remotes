local server = libs.server;
local timer = libs.timer;
local http = libs.http;
local data = libs.data;
local st = libs.utf8;

playing = false;
playing_uri = "";

-------------------------------------------------------------------------------------------
-- Spotify Cover Art Grabber
-------------------------------------------------------------------------------------------
function get_cover_art_url (uri)
	local url = "https://embed.spotify.com/oembed/?url=" .. uri;
	local raw = http.get(url);
	local json = data.fromjson(raw);
	return st.replace(json.thumbnail_url, "cover", "320");
end

function get_cover_art (uri)
	local url = get_cover_art_url(uri);
	local raw = http.get(url);
	return raw;
end

