local keyboard = libs.keyboard;
local tmr = libs.timer;
local down = false; 
local up = false;
--@help Up item
actions.up = function()
	if(up == false) then
		up = true;
		tmr.timeout(sendup, 300);
	else
		up = false;
		keyboard.press("right");
	end
end

--@help Down button
actions.down = function()
	if(down == false) then
		down = true;
		tmr.timeout(senddown, 300);
	else
		down = false;
		keyboard.press("left");
	end
end

function senddown()
	if(down) then
		down = false;
		keyboard.press("down");
	end
end

function sendup()
	if(up) then
		up = false;
		keyboard.press("up");
	end
end