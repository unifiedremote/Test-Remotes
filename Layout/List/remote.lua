local server = libs.server;

actions.tap = function (i)
	print("tap: " .. i);
end

actions.hold = function (i)
	print("hold: " .. i);
end

actions.empty = function ()
	server.update({ id = "list", children = {} });
end

actions.test = function ()
	server.update({ id = "list", children = {
		{ type = "item", text = "foo" },
		{ type = "item", text = "bar" }
	}});
end