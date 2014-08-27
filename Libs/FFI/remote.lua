local win = require("win");
local ffi = require("ffi");

ffi.cdef[[
void ShowWindow(int hwnd, int cmd);
]]

actions.min = function ()
	hwnd = win.window("notepad.exe");
	ffi.C.ShowWindow(hwnd, 6);
end

actions.max = function ()
	hwnd = win.window("notepad.exe");
	ffi.C.ShowWindow(hwnd, 3);
end