local server = libs.server;


actions.test = function ()
	libs.http.request({ method = "get", url = "http://api.telldus.com/xml/sensors/list", connect = "telldus" }, 
		function (err, resp)
			if (err) then
				layout.resp.text = err;
			else
				layout.resp.text = resp.content;
			end
		end
	);
end

