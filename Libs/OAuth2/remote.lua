local server = libs.server;


actions.test = function ()
	libs.http.request({ method = "get", url = "https://api.spotify.com/v1/me", connect = "spotify" }, 
		function (err, resp)
			if (err) then
				layout.resp.text = err;
			else
				layout.resp.text = resp.content;
			end
		end
	);
end

