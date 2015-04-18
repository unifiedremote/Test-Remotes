
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

actions.execute = function ()
	os.execute("test.bat");
end

actions.start = function ()
	os.start("asdf");
	--os.start("chrome");
	--os.start("IconGen.exe");
end

actions.open = function ()
	os.open("asdf");
	--os.open("test.bat", "\"hello world!\"");
end