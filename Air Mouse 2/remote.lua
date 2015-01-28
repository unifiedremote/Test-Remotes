local ms = libs.mouse;
local screen = libs.screen;
local j = libs.joystick;
local kb = libs.keyboard;


local zero = { x = 0, y = 0 };
local size = { w = 0, h = 0 };
local last = { x = 0, y = 0 };

events.focus = function ()
	has = false;
	size.w, size.h = screen.size();
end


local buf_x = { };
local buf_y = { };
local buf_len = 10;


function buf_fill(buf, value)
	for i = 0, buf_len - 1 do
		buf[i] = value;
	end
end

function buf_avg(buf, value)
	-- shift all values to the right
	for i = 0, buf_len - 2 do
		buf[5-i] = buf[5-i-1];
	end
	-- add new value
	buf[0] = value;
	-- calc avg
	local sum = 0;
	for i = 0, buf_len - 1 do
		sum = sum + buf[i];
	end
	return sum / buf_len;
end


actions.orientation = function (x, y, z)
	
	layout.info.text = x .. "   " .. y;
	
	if (not has) then
		-- Set zero position
		zero.x = x;
		zero.y = y;
		
		buf_fill(buf_x, 0);
		buf_fill(buf_y, 0);
		
		has = true;
		
		last.x = x;
		last.y = y;
	end
	
	local delta = {
		x = x - last.x,
		y = y - last.y
	};
	
	--local Aperture = 10;
	--local A = Aperture;
	--local Divisions = 100;
	--local Step = Aperture / Divisions;
	
	--local div_x = math.round(Aperture / Divisions * delta.x);
	--local div_y = math.round(Aperture / Divisions * delta.y);
	
	--if (div_x > Divisions) then div_x = Divisions; end
	--if (div_y > Divisions) then div_y = Divisions; end
	--if (div_x < -Divisions) then div_x = -Divisions; end
	--if (div_y < -Divisions) then div_y = -Divisions; end
	
	--x = buf_avg(buf_x, delta.x);
	--y = buf_avg(buf_y, delta.y);
	
	x = math.round(x / 20) * 1;
	y = math.round(y / 20) * 1;
	
	ms.moveraw(x, y);
	kb.press("ctrl");
	
	last.x = x;
	last.y = y;
end
