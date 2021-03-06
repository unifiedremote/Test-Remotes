
-- Metadata

local timer = libs.timer;
local server = libs.server;
local task = libs.task;
local utf8 = libs.utf8;
local tid1 = -1;
local tid2 = -1;
local tid3 = -1;

events.create = function ()
	print("create");
end

events.focus = function ()
	print("focus");
end

events.blur = function ()
	print("blur");
end

events.destroy = function ()
	print("destroy");
end

actions.timeout = function ()
	print("start");
	timer.timeout(function ()
		print("timeout!");
	end, 3000);
end

actions.start1 = function ()
	print("start1");
	tid1 = timer.interval(function ()
		print("interval1");
	end, 100);
end

actions.start2 = function ()
	print("start2");
	tid2 = timer.interval(function ()
		print("interval2");
	end, 101);
end

function update()
	server.update("info", "text", timer.time());
	print(timer.time());
end

actions.start3 = function ()
	tid3 = timer.interval(update, 1000);
end

actions.stop1 = function ()
	timer.cancel(tid1);
end

actions.stop2 = function ()
	timer.cancel(tid2);
end

actions.stop3 = function ()
	timer.cancel(tid3);
end

actions.run = function ()
	print("run");
	server.run("Test.Timer", "test");
end

actions.test = function ()
	print("test");
end
