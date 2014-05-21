local fs = libs.fs;

actions.read = function ()
	layout.info.text = fs.read("C:\\foo.txt");
end

actions.readlines = function ()
	layout.info.text = #fs.readlines("C:\\foo.txt");
end

actions.write = function ()
	fs.write("C:\\foo.txt", "abc");
end

actions.writelines = function ()
	fs.writelines("C:\\foo.txt", { "abc", "foo", "bar" });
end

actions.append = function ()
	fs.append("C:\\foo.txt", "fooooo");
end

actions.appendlines = function ()
	fs.appendlines("C:\\foo.txt", { "abc", "foo", "bar" });
end
