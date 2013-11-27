
-- Metadata

events.action = function (name, extras)
	print("action: " .. name);
end

local start;

actions.down = function ()
	start = libs.timer.time();
end

actions.tap = function ()
	print("tap!");
end

actions.hold = function ()
	local time = libs.timer.time();
	print("hold time: " .. time - start);
end
