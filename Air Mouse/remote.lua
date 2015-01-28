local ms = libs.mouse;
local screen = libs.screen;
local j = libs.joystick;
local kb = libs.keyboard;


local zero = { x = 0, y = 0 };
local size = { w = 0, h = 0 };

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
		
		buf_fill(buf_x, 50);
		buf_fill(buf_y, 50);
		
		has = true;
	end
	
	local delta = {
		x = x - zero.x,
		y = y - zero.y
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
	
	local A = 20;
	local D = 100;
	local div_x = j.normalize(delta.x, -A, A, 0, D);
	local div_y = j.normalize(delta.y, -A, A, 0, D);
	
	
	--div_x = buf_avg(buf_x, div_x);
	--div_y = buf_avg(buf_y, div_y);
	
	x = math.round(size.w / D * div_x);
	y = math.round(size.h / D * div_y);
	
	--layout.info.text = x .. "   " .. y;
	
	
	ms.moveto(x, y);
	kb.press("ctrl");
end
