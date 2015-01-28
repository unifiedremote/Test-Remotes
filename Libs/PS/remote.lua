ps = libs.ps;

actions.foo = function ()
	os.execute("echo foo");
end

actions.run_with_input = function ()
	local res = ps.run({
		command = "C:\\foo.exe",
		input = "abc\r\nhello\r\nquit\r\n"
	});
	
	print(libs.data.tojson(res));
end