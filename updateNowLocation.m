function updateNowLocation()
    global num_node;
    global source_x source_y source_id des_x des_y des_id;
    global nowlocation_x nowlocation_y;
    for i = 1:num_node
        getNowLocation(i);
    end
    source_x=nowlocation_x(1);
    source_y=nowlocation_y(1);
    des_x=nowlocation_x(num_node);
    des_y=nowlocation_y(num_node);
end