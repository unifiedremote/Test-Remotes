local server = libs.server;


actions.test = function ()
	-- Get connect details for service called: telldus
	local keys = server.connect("spotify");
	if (keys == nil) then
		layout.keys.text = "No Keys";
		return;
	else
		layout.keys.text = libs.data.tojson(keys);
	end
	
	-- Perform URL using keys for OAuth 2.0
	local url = "https://api.spotify.com/v1/me";
	local resp = libs.http.request({
		method = "get",
		url = url,
		oauth2 = keys
	});
	
	if (resp == nil) then
		layout.resp.text = "No Resp";
		return;
	else
		layout.resp.text = resp.content;
	end
end

