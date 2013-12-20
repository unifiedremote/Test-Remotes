-----------------------------------------------------
-- Define your variables here
-----------------------------------------------------

local tid = -1;
local counter = 0;

-----------------------------------------------------
-- Implement your actions here, if needed:
-----------------------------------------------------

actions.foo = function ()
	layout.message.text = "foo";
end

actions.bar = function ()
	layout.message.text = "bar";
end

-----------------------------------------------------
-- Implement event handlers here, if needed:
-----------------------------------------------------

function update ()
	layout.message.text = "tick " .. counter;
	counter = counter + 1;
end

events.focus = function ()
	counter = 0;
	tid = libs.timer.interval(update, 1000);
end

events.blur = function ()
	libs.timer.cancel(tid);
end