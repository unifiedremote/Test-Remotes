local server = libs.server;


actions.test = function ()
	-- Get connect details for service called: telldus
	local keys = server.connect("telldus");
	if (keys == nil) then
		layout.keys.text = "No Keys";
		return;
	else
		layout.keys.text = libs.data.tojson(keys);
	end
	
	-- Perform URL using keys for OAuth 1.0
	local url = "http://api.telldus.com/xml/sensors/list";
	local resp = libs.http.request({
		method = "get",
		url = url,
		oauth1 = keys
	});
	
	if (resp == nil) then
		layout.resp.text = "No Resp";
		return;
	else
		layout.resp.text = resp.content;
	end
end

