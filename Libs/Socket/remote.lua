local s;

events.create = function ()
	s = libs.socket.new();
	s:ondata(data);
	s:onclose(closed);
	s:onerror(err);
	s:onconnect(connected);
end

events.destroy = function ()
	s:close();
end

actions.connect = function ()
	print("SOCKET connecting...");
	s:connect("philip-pc2", 9999);
end

actions.disconnect = function ()
	s:close();
end

actions.send = function ()
	print("SOCKET sending");
	s:write("foobar");
end

function connected ()
	print("SOCKET connected");
end

function closed ()
	print("SOCKET closed");
end

function data (buffer)
	print("SOCKET received: " .. buffer);
	layout.receive.text = buffer;
end

function err (e)
	print("SOCKET error: " .. e);
end