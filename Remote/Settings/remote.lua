
actions.get = function ()
	print(settings.time);
	layout.info.text = settings.time;
end

actions.set = function ()
	settings.time = libs.timer.time();
end
