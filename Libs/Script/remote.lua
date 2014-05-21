local script = libs.script;

actions.default = function ()
	out,err,res = script.default("foo");
	layout.info.text = out .. err;
end

actions.script = function ()
	out,err,res = libs.os.script("set out to \"foooooo\"");
	layout.info.text = out .. err;
end

actions.batch = function ()
	layout.info.text = script.batch(
		"echo %cd%"
	);
end

actions.powershell = function ()
	layout.info.text = script.powershell([[
		$pwd
		ps | Where-Object { $_.Name -eq \"svchost\" }
	]]);
end

actions.apple = function ()
	layout.info.text = script.apple(
		"set r to (path to me)"
	);
end

actions.shell = function ()
	layout.info.text = script.shell(
		"echo $PWD"
	);
end

actions.shell_special = function ()
	layout.info.text = script.shell(
		"#!/bin/sh",
		"echo $PWD"
	);
end