
actions.sleep = function ()
	print("sleeping...");
	os.sleep(3000);
	print("slept!");
end

actions.open = function ()
	os.open("http://www.google.com/");
end

actions.open_all = function ()
	if (OS_WINDOWS) then
		os.open_all("F:\\AAA");
	else
		os.open_all("~/AAA");
	end
end

actions.start = function ()
	os.start("ping");
end

actions.start_args = function ()
	if (OS_WINDOWS) then
		os.start("ping", "-n 3");
	else
		os.start("ping", "-c 3");
	end
end

actions.script = function ()
	local out = "";
	if (OS_OSX) then
		out = os.script(
			"tell application \"Spotify\"",
				"set r to sound volume",
			"end tell"
		);
	elseif (OS_WINDOWS) then
		out = os.script(
			"echo foobar1",
			"echo foobar2",
			"echo foobar3",
			"echo foobar4",
			"echo foobar5"
		);
	elseif (OS_LINUX) then
		out = os.script(
			"echo foobar"
		);
	end
	print(out);
end

actions.throw = function ()
	os.throw("foo!");
end