
-- Metadata

events.action = function (name, extras)
	print("action: " .. name);
end

actions.change = function (text)
	print("action: change: " .. text);
end

actions.done = function (text)
	print("action: done: " .. text);
end
