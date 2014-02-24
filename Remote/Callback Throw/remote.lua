
events.create = function ()
	print("throwing soon...");
	libs.timer.timeout(function ()
		print("throwing...");
		os.throw("asdf asdf asdf");
	end, 1000);
end