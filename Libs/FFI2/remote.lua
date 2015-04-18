local win = require("win");
local ffi = require("ffi");

ffi.cdef[[
typedef int BOOL;
typedef long LONG;
typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;
BOOL GetWindowRect(LONG hwnd, RECT* rect);
BOOL MoveWindow(LONG hwnd, int x, int y, int w, int h, BOOL repaint);
]]

function move (amount)
	local hwnd = win.find(nil, "Calculator");
	local rect = ffi.new("RECT", 0, 0, 0, 0);
	ffi.C.GetWindowRect(hwnd, rect);
	ffi.C.MoveWindow(hwnd, 
		rect.left - amount, 
		rect.top, 
		rect.right - rect.left, 
		rect.bottom - rect.top, 
		1);
end

actions.move_in = function ()
	move(100);
end

actions.move_out = function ()
	move(-100);
end
