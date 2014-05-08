
-- Metadata

events.action = function (name, extras)
	print("action: " .. name);
end

actions.set_gone = function()
	libs.server.update("goner", "visibility","gone");
	libs.server.update("goner", "text","gone");
end

actions.set_vis = function()
	libs.server.update("goner", "visibility","visible");
	libs.server.update("goner", "text","visible");
end

actions.set_invis = function()
	libs.server.update("goner", "visibility","invisible");
	libs.server.update("goner", "text","invisible");
end