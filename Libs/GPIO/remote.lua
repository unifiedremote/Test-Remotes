
-- Metadata

local g = libs.gpio;
local ind = g.index;
local n = g.name;

events.focus = function ()
	g.map("pi");
	for i=0,16 do 
		libs.gpio.capture(ind(i)); 
		libs.gpio.out(ind(i));
	end
end

events.blur = function ()
	g.releaseall();
end

actions.off = function()
	for i = 0, 16 do
		g.set(ind(i), false);
		layout["l" .. i+1].checked=false;	
	end
end

actions.on = function() 
	for i = 0, 16 do
		g.set(ind(i), true);
		layout["l"..i+1].checked = true;
	end
end

actions.l1 = function(checked)
	g.set(n("GPIO17"),checked);
end
actions.l2 = function(checked)
	g.set(n("GPIO18"),checked);
end
actions.l3 = function(checked)
	g.set(n("GPIO21/27"),checked);
end
actions.l4 = function(checked)
	g.set(n("GPIO22"),checked);
end
actions.l5 = function(checked)
	g.set(n("GPIO23"),checked);
end
actions.l6 = function(checked)
	g.set(n("GPIO24"),checked);
end
actions.l7 = function(checked)
	g.set(n("GPIO25"),checked);
end
actions.l8 = function(checked)
	g.set(n("GPIO4"),checked);
end
actions.l9 = function(checked)
	g.set(n("SDA"),checked);
end
actions.l10 = function(checked)
	g.set(n("SCL"),checked);
end
actions.l11 = function(checked)
	g.set(n("CE2"),checked);
end
actions.l12 = function(checked)
	g.set(n("CE1"),checked);
end
actions.l13 = function(checked)
	g.set(n("MOSI"),checked);
end
actions.l14 = function(checked)
	g.set(n("MISO"),checked);
end
actions.l15 = function(checked)
	g.set(n("SCLK"),checked);
end
actions.l16 = function(checked)
	g.set(n("TxD"),checked);
end
actions.l17 = function(checked)
	g.set(n("RxD"),checked);
end

