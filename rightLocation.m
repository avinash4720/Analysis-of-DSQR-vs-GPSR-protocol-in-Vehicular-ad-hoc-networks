function [right_x,right_y]=rightLocation(x,y)
	%global area_l area_w;
	x = abs(x);
	y = abs(y);
    %Only analyze intersections and add nodes
	if (x < 488.75)&&(y < 488.75)
        x = 488.75 + mod(488.75 - x,22.5);
        y = 488.75 + mod(488.75 - y,22.5);
    elseif (x > 511.25)&&(y < 488.75)
        x = 511.25 - mod(x - 511.25,22.5);
        y = 488.75 + mod(488.75 - y,22.5);
    elseif (x > 511.25)&&(y > 511.25)
        x = 511.25 - mod(x - 511.25,22.5);
        y = 511.25 - mod(y - 511.25,22.5);
    elseif (x < 488.75)&&(y > 511.25)
        x = 488.75 + mod(488.75 - x,22.5);
        y = 511.25 - mod(y - 511.25,22.5);
	end
	right_x = x;
	right_y = y;
end