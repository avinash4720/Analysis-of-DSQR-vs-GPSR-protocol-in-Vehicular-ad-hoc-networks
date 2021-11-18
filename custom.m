	global now_time step_time sum_time;
	global area_l area_w num_node;
	global node_x node_y node_id;
	global source_x source_y source_id des_x des_y des_id;
	global neb_node_id neb_node_x neb_node_y num_neb;
	global nowlocation_x nowlocation_y;
	global mobi_model_x mobi_model_y mobi_model_startime mobi_model_speed mobi_model_direct;
    global r_source alq_source r alq;
	
    %City two-way 6-lane intersection:
     % Each lane is 3.75 meters wide, for a total of 22.5 meters wide
     % Vehicle speed 40~60km/h, near intersection (within 100 meters) 15~30km/h, standard 30~60km/s 45km/h
     % Direction 0 pi/2 pi 3*pi/2, intersection area pi/4 7*pi/4 3*pi/4 5*pi/4
     % Traffic density of single lane 10 25 30 50 vehicles/lane/km
     % Vehicle communication radius [100,250] 150 200
	now_time = 0;
    axis([0 1000+1 0 1000+1]);
    pause on;
    step_time = 0.5;
    sum_time = 5;
    set_node=10;
	area_l = 488.75 + 11.25 + 11.25 + 488.75;
	area_w = 1000;
    single_num_node = set_node; %30
	num_node_temp = single_num_node*3*2*2;
    add_ten_road = 2*fix(num_node_temp/(1000/22.5)); %20km/h 7.0m/s
    % The density of intersections increases, and the vehicle speed also decreases to 20km/h 7.0m/s
	num_node = num_node_temp + add_ten_road;
    
	%Set the location and ID of the intermediate node
    %Horizontal road
    %   下 under
	for i = 2:single_num_node*3
		node_x(i) = area_l*rand(1,1);
		node_y(i) = area_w/2 - 11.5*rand(1,1);
		node_id(i) = i;
    end
    %   上 on
    for i = (single_num_node*3 + 1):single_num_node*6
		node_x(i) = area_l*rand(1,1);
		node_y(i) = area_w/2 + 11.5*rand(1,1);
		node_id(i) = i;
    end
    % Longitudinal road
    %   left
    for i = (single_num_node*6 + 1):single_num_node*9
        node_x(i) = area_l/2 - 11.5*rand(1,1);
        node_y(i) = area_w*rand(1,1);
        node_id(i) = i;
    end
    %    right
    for i = (single_num_node*9 + 1):(single_num_node*12 - 1)
		node_x(i) = area_l/2 + 11.5*rand(1,1);
		node_y(i) = area_w*rand(1,1);
		node_id(i) = i;
    end
    
    %ID Set the intersection to increase the location and ID of the node
    for i = (single_num_node*12):(num_node - 1)
		node_x(i) = area_l/2 - 11.5 + 2*11.5*rand(1,1);
		node_y(i) = area_w/2 - 11.5 + 2*11.5*rand(1,1);
		node_id(i) = i;
    end
    
	%ID Set the location and ID of the source node
	source_x = area_l/5*rand(1,1);
	source_y = area_w/2 - 11.5*rand(1,1);
%     source_x = 375;
% 	source_y = area_w/2 - 11.5*rand(1,1);
	source_id = 1;
	node_x(1) = source_x;
	node_y(1) = source_y;
	node_id(1) = source_id;
    
	%Set the location and ID of the destination node
	des_x = 1/5*area_l + area_l/5*rand(1,1);
	des_y = area_w/2 - 11.5*rand(1,1);
%     des_x = area_l/2 + 11.5*rand(1,1);
% 	des_y = 875;
	des_id = num_node;
	node_x(num_node) = des_x;
	node_y(num_node) = des_y;
	node_id(num_node) = des_id;
% Initialize the real location and corresponding time of the node
	nowlocation_x = node_x;
	nowlocation_y = node_y;
%plot road
    hold on;
    plot([0 488.75],[488.75 488.75],'k-');
    hold on;
    plot([0 488.75],[500 500],'k--');
    hold on;
    plot([0 488.75],[500-3.75 500-3.75],'g--');
    hold on;
    plot([0 488.75],[500-2*3.75 500-2*3.75],'g--');
    hold on;
    plot([0 488.75],[500+3.75 500+3.75],'g--');
    hold on;
    plot([0 488.75],[500+2*3.75 500+2*3.75],'g--');
    hold on;
    plot([0 488.75],[511.25 511.25],'k-');
    hold on;
    plot_l=1000;
    plot([511.25 plot_l],[488.75 488.75],'k-');
    hold on;
    plot([511.25 plot_l],[500 500],'k--');
    hold on;
    plot([511.25 plot_l],[500-3.75 500-3.75],'g--');
    hold on;
    plot([511.25 plot_l],[500-2*3.75 500-2*3.75],'g--');
    hold on;
    plot([511.25 plot_l],[500+3.75 500+3.75],'g--');
    hold on;
    plot([511.25 plot_l],[500+2*3.75 500+2*3.75],'g--');
    hold on;
    plot([511.25 plot_l],[511.25 511.25],'k-');
    hold on;
    %y-axis
    plot([488.75 488.75],[0 488.75],'k-');
    hold on;
    plot([500 500],[0 488.75],'k--');
    hold on;
    plot([511.25 511.25],[0 488.75],'k-');
    hold on;
    plot([488.75 488.75],[511.25 1000],'k-');
    hold on;
    plot([500 500],[511.25 1000],'k--');
    hold on;
    plot([511.25 511.25],[511.25 1000],'k-');
    hold on;
    %for z=1:num_node
      %  if z==source_id
       %     h2=plot(node_x(z),node_y(z),'or'); 
       %     text(node_x(z),node_y(z),num2str(z));
      %  else if z == num_node
       %         h2=plot(node_x(z),node_y(z),'dm');
        %        text(node_x(z),node_y(z),num2str(z));
         %   end
       % end
       % h2=plot(node_x(z),node_y(z),'.k');
   % end

	%Initialize the neighbor node table
	for node_i = 1:num_node
		for num_mem = 1:num_node
			neb_node_x(node_i,num_mem) = 0; % neb_node_x is the matrix of num_node*num_node
			neb_node_y(node_i,num_mem) = 0;
			neb_node_id(node_i,num_mem) = 0;
        end
        num_neb(node_i) = num_mem; %num_node The number of neighbors of each node is initialized to num_node
	end
	
	% Initialize the real location and corresponding time of the node
	nowlocation_x = node_x;
	nowlocation_y = node_y;
	%neighbor table
    setNodeNebTable(50);
	% Mobile Model
	mobi_model_x = node_x;
	mobi_model_y = node_y;
	mobi_model_startime = zeros(1,num_node);
    
    %Speed: 30~60km/s, normal distribution, mean 45km/h, variance 20, namely 8.3~16.7m/s 12.5m/s
    %Set the speed of the source node and the intermediate node
    for i = 1:(num_node_temp - 1)
        speed_temp = normrnd(12.5,20);
        while ~((speed_temp >= 8.3)&&(speed_temp <= 16.7))
            speed_temp = normrnd(12.5,20);
        end
        mobi_model_speed(i) = (10/set_node)^2*speed_temp; %Traffic density affects vehicle speed
    end
    %Set intersections to increase the speed of nodes and affect the interruption rate
    for i = num_node_temp:(num_node - 1)
        mobi_model_speed(i) = (10/set_node)^2*7.0;
    end
    %Set the speed of the destination node
    speed_temp = normrnd(12.5,20);
        while ~((speed_temp >= 8.3)&&(speed_temp <= 16.7))
            speed_temp = normrnd(12.5,20);
        end
    mobi_model_speed(num_node) = (20/set_node)^2*speed_temp;
    
    %Movement direction: [0,pi/4],[7*pi/4,2*pi]
    mobi_model_direct = zeros(1,num_node);
    % Set the direction of movement of the intermediate node
    for i = 2:single_num_node*3
        mobi_model_direct(i) = 0;
    end
    for i = (single_num_node*3 + 1):single_num_node*6
        mobi_model_direct(i) = pi;
    end
    for i = (single_num_node*6 + 1):single_num_node*9
        mobi_model_direct(i) = 3*pi/2;
    end
    for i = (single_num_node*9 + 1):(single_num_node*12 - 1)
        mobi_model_direct(i) = pi/2;
    end
    %Set the crossroads to increase the movement direction of the nodes, evenly distributed, pi/4 7*pi/4 3*pi/4 5*pi/4
    
    for i = num_node_temp:(num_node - 1)
        direct_flag = rand(1,1);
        if direct_flag <= 0.25
            mobi_model_direct(i) = pi/4;
        elseif (direct_flag > 0.25)&&(direct_flag <= 0.5)
            mobi_model_direct(i) = 3*pi/4;
        elseif (direct_flag > 0.5)&&(direct_flag <= 0.75)
            mobi_model_direct(i) = 5*pi/4;
        else
            mobi_model_direct(i) = 7*pi/4;
        end
    end
    
    %the direction of movement of the source node
    mobi_model_direct(1) = 0;
    %the direction of movement of the destination node
    mobi_model_direct(num_node) = 0;
%     mobi_model_direct(num_node) = pi/2;
% uicontrol
              %  H = uicontrol('Style', 'listbox', ...
                  %  'Units', 'normalized', ...
                  %  'Position', [0.5 0.2 0.3 0.68], ...
                   % 'String', {'Path Establishing...'});
                %drawnow;
%mobility             
counter=1;
density_sum=0;
%pause(5);
   r_source=(15-0).*rand(1,1) + 0;
   alq_source=(110-50).*rand(1,1) + 50;
   for node_j= 1:num_node
          r(node_j)=(15-0).*rand(1,1) + 0;;
          alq(node_j)=(110-50).*rand(1,1) + 50;
   end
for now_time = 0.5:step_time:sum_time
        updateNowLocation();   %now_time should be a global variable to facilitate updating the location
        for z=1:num_node
            if z==source_id
                plot(nowlocation_x(z),nowlocation_y(z),'or'); 
                h7=text(nowlocation_x(z),nowlocation_y(z),num2str(z),'FontSize',12);
            else if z == num_node
                    plot(nowlocation_x(z),nowlocation_y(z),'dm');
                    h9=text(nowlocation_x(z),nowlocation_y(z),num2str(z),'FontSize',12);
                end
            end
            h2(z)=plot(nowlocation_x(z),nowlocation_y(z),'.k');
            h10(z)=text(nowlocation_x(z),nowlocation_y(z),num2str(z));
        end
        setNodeNebTable(100);
        route=linkquality();
        path{counter}=route;
        
        pause(1);
        set(h2,'Visible','off');

        set(h10,'Visible','off');
       % h4= plot([nowlocation_x(1) nowlocation_x(num_node)],[nowlocation_y(1) nowlocation_y(num_node)],'r');
        h4=plot(nowlocation_x(route),nowlocation_y(route));
        if length(route) ~=0
            for q=1:length(route)
                h3(q)=text(nowlocation_x(route(q)),nowlocation_y(route(q)),num2str(route(q)));
            end
        end
        [thp,density_tp,loss,time]=perform_custom(route);
        tp(counter,:)=thp;
        ploss(counter,:)=loss;
        delay(counter,:)=time;
        density_sum=density_sum+density_tp;
        counter=counter+1;
        
        pause(1);
        
        set(h7,'Visible','off');
        set(h9,'Visible','off');
        set(h4,'Visible','off');
        set(h3,'Visible','off');
        
        
        
end
avg_density_tp=density_sum/10;

%plot results
figure(2)
plot(tp/10e6,'Linewidth',1.5)
xlabel('Number of times path found during simulation of VANET')
ylabel('Throughput in MBps ')
title('Throughput plot for different data rates')
legend('Data Rate=4 pckts/sec','Data Rate=6 pckts/sec','Data Rate=8 pckts/sec','Data Rate=10 pckts/sec','Data Rate=12 pckts/sec','Data Rate=14 pckts/sec')
grid on

figure(3)
plot(ploss,'Linewidth',1.5)
xlabel('Number of times path found during simulation of VANET')
ylabel('Packet loss ratio ')
title('Packet loss ratio for different data rates')
legend('Data Rate=4 pckts/sec','Data Rate=6 pckts/sec','Data Rate=8 pckts/sec','Data Rate=10 pckts/sec','Data Rate=12 pckts/sec','Data Rate=14 pckts/sec')
grid on

figure(5)
plot(delay/10e8,'Linewidth',1.5)
xlabel('Number of times path found during simulation of VANET')
ylabel('End to End delay(s)')
grid on
clear h3;