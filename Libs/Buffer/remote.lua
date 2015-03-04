
events.focus = function ()
	
	print("b");
	local b = libs.buffer.new();
	b:writeint32(123456);
	print(b:tostring());
	
	print("b0");
	local b0 = libs.buffer.new();
	print(b0:length());
	print(b0:available());
	b0:writebyte(123);
	print(b0:length());
	print(b0:available());
	b0:readbyte();
	print(b0:length());
	print(b0:available());
	
	print("b1");
	local b1 = libs.buffer.new("asdf");
	b1:writestring("abcåäö");
	print(b1:tostring());
	
	print("b2");
	local b2 = libs.buffer.new("utf16");
	b2:writestring("abcåäö");
	print(b2:tostring());
	
	print("b3");
	local b3 = libs.buffer.new("utf8", "le");
	b3:writeint32(123456);
	print(b3:tostring());
	
	print("b4");
	local b4 = libs.buffer.new("utf8", "be");
	b4:writeint32(123456);
	print(b4:tostring());
	
	print("b5,b6");
	local b5 = libs.buffer.new();
	b5:writestring("foo");
	b5:writestring("bar");
	print(b5:tostring());
	print(b5:readstring());
	print(b5:tostring());
	local b6 = b5:readbuffer();
	print(b6);
	print(b6:tohex());
	
	local b6 = libs.buffer.new("utf16");
	b6:writeint8(255);
	b6:writedouble(250);
	print(b6:tostring());
	print(b6:readint16());
	
	local b7 = libs.buffer.new();
	b7:write("abc");
	print(b7:read(1)); -- a
	print(b7:read());  -- bc
	
	local b8 = libs.buffer.new();
	b8:write("xxx");
	
	local b9 = libs.buffer.new();
	b9:write("aaa");
	b9:writebuffer(b8);
	print(b9:tostring());
	
	local b10 = libs.buffer.new();
	b10:writeline("foo");
	b10:writeline("bar");
	print(b10:readline());
	print(b10:readline());
	print(b10:readline());
end
