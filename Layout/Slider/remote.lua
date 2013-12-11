local tid = 0;
local pos = 0;

events.focus = function ()
	tid = libs.timer.interval(function ()
		pos = pos + 1;
		if (pos >= 10) then
			pos = 0;
		end
		layout.slider.progress = pos;
	end, 500);
end

events.blur = function ()
	libs.timer.cancel(tid);
end

events.action = function (name, extras)
	print("action: " .. name);
end
