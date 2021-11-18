function setNodeNebTable(set_R)
    global R num_node;
    global node_x node_y node_id;
    global neb_node_id neb_node_x neb_node_y num_neb;
    global neb_node_source_x neb_node_source_y neb_node_source_id;
    global neb_node_des_x neb_node_des_y neb_node_des_id;
    global nowlocation_x nowlocation_y
 %   global r_source alq_source r alq;
    
    R = set_R;
 %   r_source=(15-0).*rand(1,1) + 0;
 %   alq_source=(110-50).*rand(1,1) + 50;
    % The controller establishes a neighbor node table for the node
	%Note: Both the source and destination nodes exist in the neighbor node linked list of their neighbor nodes!
	for node_i = 1:num_node
	num_mem = 0;
		for node_j = 1:num_node
			if (node_j ~= node_i) && (sqrt((nowlocation_x(node_i) - nowlocation_x(node_j))^2 + (nowlocation_y(node_i) - nowlocation_y(node_j))^2) <= R)
				num_mem = num_mem + 1;
				neb_node_x(node_i,num_mem) = nowlocation_x(node_j);
				neb_node_y(node_i,num_mem) = nowlocation_y(node_j);
				neb_node_id(node_i,num_mem) = node_id(node_j); %ID neb_node_id each row records the neighbor node ID in turn from left to right
			end
		end
		num_neb(node_i) = num_mem;
      %  r(node_i)=(15-0).*rand(1,1) + 0;;
      %  alq(node_i)=(110-50).*rand(1,1) + 50;
	end
	
	% Separately record the neighbor node table of the source node
	neb_node_source_x = neb_node_x(1,:);    
	neb_node_source_y = neb_node_y(1,:);    
	neb_node_source_id = neb_node_id(1,:);
	
	% Separately record the neighbor node table of the destination node
	neb_node_des_x = neb_node_x(num_node,:);
	neb_node_des_y = neb_node_y(num_node,:);    
	neb_node_des_id = neb_node_id(num_node,:);
end