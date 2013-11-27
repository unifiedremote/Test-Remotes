
-- Metadata

local command = "";

actions.change = function (text)
	command = text;
	print(text);
end

actions.run = function ()
	local file = io.popen(command);
	local output = file:read('*all');
	file:close();
	server.update("output", "text", output);
end
