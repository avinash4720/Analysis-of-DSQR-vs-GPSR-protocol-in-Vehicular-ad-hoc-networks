function getNowLocation(i)
    %Note that the area is 1000*1000, if the node reaches the boundary of the area, it will bounce back into the area
    global now_time;
    global nowlocation_x nowlocation_y;
    global mobi_model_x mobi_model_y mobi_model_startime mobi_model_speed mobi_model_direct;

	if now_time > mobi_model_startime(i)
		nowlocation_x(i) = mobi_model_x(i) + mobi_model_speed(i)*(now_time-mobi_model_startime(i))*cos(mobi_model_direct(i));
		nowlocation_y(i) = mobi_model_y(i) + mobi_model_speed(i)*(now_time-mobi_model_startime(i))*sin(mobi_model_direct(i));
		[nowlocation_x(i) nowlocation_y(i)] = rightLocation(nowlocation_x(i),nowlocation_y(i));                       
    end
    
end