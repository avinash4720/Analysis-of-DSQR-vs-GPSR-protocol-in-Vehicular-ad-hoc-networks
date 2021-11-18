function [route_trace] = linkquality()
    %Assuming that the movement of the vehicle within the unit packet delay is negligible
    global R num_node;
    global source_x source_y source_id des_x des_y des_id;
    global neb_node_id neb_node_x neb_node_y num_neb;
    global neb_node_source_x neb_node_source_y neb_node_source_id;
    global nowlocation_x nowlocation_y;
    global r_source alq_source r alq;
    source_id=1;
%Initialize path information
    route_hop = 1;
    present_node_id(route_hop) = source_id; % Use the source node as the first node of the path

    % The distance from the source node to the destination node
	min_mem_1 = sqrt((nowlocation_x(1)-nowlocation_x(num_node))^2 + (nowlocation_y(1)-nowlocation_y(num_node))^2);
    
	%The next hop node ID of the source node
	next_hop_node_coordinate = source_id;
    
    num_source_neb = num_neb(1);
    theta=pi/4;
    counter=1;
    max_cm=0;
	% The source node judges whether the destination node is a neighbor
	if  min_mem_1 <= R  % The source and destination nodes are neighbors and send directly, that is, the destination node is set as the next hop node
        next_hop_node_coordinate = des_id;
	else                      
		if num_source_neb ~= 0  %The source and destination are not neighbors, and the neighbor table is not empty, then greedy forwarding starts
            for iii_num_source_neb = 1:num_source_neb
                
                if (neb_node_source_x(iii_num_source_neb)>=nowlocation_x(1)+R/2) && (neb_node_source_x(iii_num_source_neb)<=nowlocation_x(1)+R*cos(theta))
                  %  disp('yes');
                    dsqr(counter)=neb_node_source_id(iii_num_source_neb);
                    counter=counter+1;
                end
            end
            if counter>1
               for ii=1:length(dsqr)
                scale_alq=(mean([alq_source alq(dsqr(ii))])-50)/5.0;
                scale_RSS=(15-std([r_source r(dsqr(ii))]));
                cc=scale_alq+scale_RSS;
                cm(ii)=(cc*4)/100;
                if(cm(ii)>max_cm)
                    disp(dsqr(ii));
                    max_cm=cm(ii);
                    next_hop_node_coordinate = dsqr(ii);
                end
               end
               disp(max_cm);
            else
                disp('USING GPRS');
                flag_no_void_source = 0;
                for i_num_source_neb = 1:num_source_neb
                    if sqrt((neb_node_source_x(i_num_source_neb)-des_x)^2 + (neb_node_source_y(i_num_source_neb)-des_y)^2) < min_mem_1
                        min_mem_1 = sqrt((neb_node_source_x(i_num_source_neb)-des_x)^2+(neb_node_source_y(i_num_source_neb)-des_y)^2);
                        next_hop_node_coordinate = neb_node_source_id(i_num_source_neb);
                        flag_no_void_source = 1;
                    end
                end
                if flag_no_void_source == 0   %Greedy failure, right-hand rule forwarding
                    b_in = atan((source_y-0)/(source_x-0));
                    if b_in < 0
                        b_in = b_in+2*pi;
                    end
                    sita_min = 3*pi;
                    for i_num_source = 1:num_source_neb
                        b_a = atan((source_y-neb_node_source_y(i_num_source_neb))/(source_x-neb_node_source_x(i_num_source_neb)));
                        if b_a < 0
                            b_a = b_a + 2*pi;
                        end
                        sita_b = b_a - b_in;
                        if sita_b < 0
                            sita_b = sita_b + 2*pi;
                        end
                        if sita_b < sita_min
                            sita_min = sita_b;
                            a_min = neb_node_source_id(i_num_source_neb);
                            return;
                        end
                    end
                    next_hop_node_coordinate = a_min;  %Jump ID found
               end
                
             end
            end
		
    end
    
    %Add nodes to the path
    pre_hop_node_id(route_hop) = present_node_id(route_hop);
    route_hop = route_hop + 1;
    present_node_id(route_hop) = next_hop_node_coordinate;
    disp(present_node_id(route_hop));
    
    while sqrt((nowlocation_x(present_node_id(route_hop))-des_x)^2 + (nowlocation_y(present_node_id(route_hop))-des_y)^2) > R %It is a neighbor with the destination node and sends data directly to the destination node
		%The destination node is not a neighbor node, and needs to be forwarded according to greed and surrounding
		%Calculate the distance between the current node and the destination node, and find the node closest to the destination node among its neighbor nodes
        counter=1;
        dsqr=[];
        max_cm=0;
		min_mem_2 = sqrt((nowlocation_x(present_node_id(route_hop))-des_x)^2 + (nowlocation_y(present_node_id(route_hop))-des_y)^2);
		if num_neb(present_node_id(route_hop)) ~= 0
			for iii_num_source_neb = 1:num_neb(present_node_id(route_hop))
                
                if (neb_node_x(present_node_id(route_hop),iii_num_source_neb)>=nowlocation_x(present_node_id(route_hop))+R/2) && (neb_node_x(present_node_id(route_hop),iii_num_source_neb)<=nowlocation_x(present_node_id(route_hop))+R*cos(theta))
                  %  disp('yes');
                    dsqr(counter)=neb_node_id(present_node_id(route_hop),iii_num_source_neb);
                    counter=counter+1;
                end
            end
            if counter>1
               for ii=1:length(dsqr)
                scale_alq=(mean([alq(present_node_id(route_hop)) alq(dsqr(ii))])-50)/5.0;
                scale_RSS=(15-std([r(present_node_id(route_hop)) r(dsqr(ii))]));
                cc=scale_alq+scale_RSS;
                cm(ii)=(cc*4)/100;
                if(cm(ii)>max_cm)
                    disp(dsqr(ii));
                    max_cm=cm(ii);
                    next_hop_node_coordinate = dsqr(ii);
                end
                end
               disp(max_cm);
            else
            %%%%%%%%%%%%%%%%%%%%%%%%
                disp('USING GPRS OF NEIGHBOR');
                flag_no_void = 0;
                for i_num_node_neb = 1:num_neb(present_node_id(route_hop))
                    if sqrt((neb_node_x(present_node_id(route_hop),i_num_node_neb)-des_x)^2 + (neb_node_y(present_node_id(route_hop),i_num_node_neb)-des_y)^2) < min_mem_2
                        min_mem_2 = sqrt((neb_node_x(present_node_id(route_hop),i_num_node_neb)-des_x)^2 + (neb_node_y(present_node_id(route_hop),i_num_node_neb)-des_y)^2);
                        next_hop_node_coordinate_temp = neb_node_id(present_node_id(route_hop),i_num_node_neb);
                        flag_no_void = 1;
                    end
                end
            
                if flag_no_void == 1
                    next_hop_node_coordinate = next_hop_node_coordinate_temp;
                elseif flag_no_void == 0    %right hand rule
                    b_in = atan((nowlocation_y(present_node_id(route_hop))-nowlocation_y(pre_hop_node_id(route_hop-1)))/(nowlocation_x(present_node_id(route_hop))-nowlocation_x(pre_hop_node_id(route_hop-1))));
                    if b_in < 0
                        b_in = b_in + 2*pi;
                    end
                    sita_min = 3*pi;
                    flag_a_min_avail = 0;
                    for j_num_node_neb = 1:num_neb(present_node_id(route_hop))
                      %  printf('%d',i_num_bode_neb);
                        if nowlocation_x(pre_hop_node_id(route_hop)) ~= neb_node_x(present_node_id(route_hop),j_num_node_neb)
                            b_a = atan((nowlocation_y(present_node_id(route_hop))-neb_node_y(present_node_id(route_hop),j_num_node_neb))/(nowlocation_x(present_node_id(route_hop))-neb_node_x(present_node_id(route_hop),i_num_node_neb)));
                            if b_a < 0
                                b_a = b_a + 2*pi;
                            end
                            if (b_a-b_in) < 0
                                sita_b = (b_a-b_in) + 2*pi;
                            else 
                                sita_b = b_a - b_in;
                            end
                            if sita_b < sita_min
                                sita_min = sita_b;
                                a_min = neb_node_id(present_node_id(route_hop),j_num_node_neb);
                                flag_a_min_avail = 1;
                            end
                        end
                    end
                    if flag_a_min_avail == 1
                        next_hop_node_coordinate = a_min;
                    else
                        error('Routing unsucessful');
                    end
                end  
            end
      
        end
        %Add nodes to the path
        pre_hop_node_id(route_hop) = present_node_id(route_hop);
        route_hop = route_hop + 1;
        present_node_id(route_hop) = next_hop_node_coordinate;
    end
    
    %Put the destination node in the path
    pre_hop_node_id(route_hop) = present_node_id(route_hop);
    route_hop = route_hop + 1;
    present_node_id(route_hop) = des_id;
    
    route_trace = present_node_id;
end