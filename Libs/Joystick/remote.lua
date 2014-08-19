local j = libs.joystick;

function norm (value, minValue, maxValue)
	return math.round((value - minValue) / maxValue * 254) - 127;
end

actions.throttle = function (value)
	value = norm(value, 0, 100);
	j.throttle(value);
end

actions.orientation = function (x, y, z)
	xAxis = norm(-y, -180, 180);
	yAxis = norm(-z, -180, 180);
	zAxis = norm(-x, 0, 100);
	j.look(xAxis, yAxis, 0);
	j.rotate(zAxis, 0);
	layout.info.text = xAxis .. " " ..yAxis;
end
