
-- Metadata

local g = libs.gpio;
local tid = -1;

events.create = function ()
	g.map("pi");
	for i=0,16 do
		g.capture(g.index(i));
		g.out(g.index(i));
		g.low(g.index(i));
	end
	
	tid = libs.timer.interval(update, 100);
end

function update ()
	for i=0,16 do
		local s = math.random(0,1);
		if (s == 1) then
			g.high(g.index(i));
		else
			g.low(g.index(i));
		end
	end
end

events.destroy = function ()
	libs.timer.cancel(tid);
	g.releaseall();
end
