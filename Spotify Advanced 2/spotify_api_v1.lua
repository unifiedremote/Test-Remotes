local server = require("server");


function spotify_api_v1_log (str)
	print("spotify_api_v1.lua: " .. str);
end

function spotify_api_v1_url (path)
	print("https://api.spotify.com/v1" .. path);
	return "https://api.spotify.com/v1" .. path;
end

function open_connect_dialog()
	server.update({ 
	    type = "dialog", 
	    text = "Connect your Spotify account, please click 'Connect Spotify' in the manager", 
	    ontap = "connect_dialog",
	    children = {
	    	{ type = "button", text = "Open On Computer" },
	        { type = "button", text = "Cancel" }
	    }
	});
end

actions.connect_dialog = function(i)
	if (i == 0) then
		os.open("http://localhost:9510/web/#/status/connect");
	elseif (i == 1) then 
		spotify_api_v1_log("Aborted by user..");
	else
		spotify_api_v1_log("Invalid dialog option.... i=" .. i);
	end
end