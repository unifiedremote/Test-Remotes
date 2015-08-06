local mouse = libs.mouse;

actions.down = function ()
	
end

actions.up = function ()
	mouse.up();
end

actions.delta = function (id, x, y)
	mouse.moveby(x, y);
end

actions.hold = function ()
	mouse.down();
end
