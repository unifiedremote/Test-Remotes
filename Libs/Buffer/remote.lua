
events.focus = function ()
	libs.buffer.new();
	
	libs.buffer.new("utf8");
	
	libs.buffer.new("utf8", "le");

	local b = libs.buffer.new();
	
	b:writebyte(1);
	print(b:available());
	
	print(b:readbyte());
	print(b:available());
	
	b:writebyte(2);
	print(b:available());
	
	print(b:readbyte());
	print(b:available());
	
end
