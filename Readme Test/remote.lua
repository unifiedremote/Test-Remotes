local script = require "script";

events.focus = function ()
	libs.win.capture();
end
