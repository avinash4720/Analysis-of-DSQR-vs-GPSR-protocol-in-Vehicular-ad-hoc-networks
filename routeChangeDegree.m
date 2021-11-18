function [rsd] = routeChangeDegree(routeTrace_x,routeTrace_y)
    global R;
    
    trace_num = length(routeTrace_x(:,1));
    hop_num = length(routeTrace_x(1,:));
    
    %�����trace��ÿ����·ֵ
    link_len = []; %��·����
    link_angle = []; %��·�����ˮƽ����ĽǶ�ֵ
    link_off = []; %��·ͨ��ֵ 0��ʾͨ��1��ʾ��
    for i = 1:trace_num
        for j = 1:(hop_num - 1)
            d =sqrt((routeTrace_x(i,j + 1) - routeTrace_x(i,j))^2 + (routeTrace_y(i,j + 1) - routeTrace_y(i,j))^2);
            link_len(i,j) = d;
            link_angle(i,j) = atan2(routeTrace_y(i,j + 1) - routeTrace_y(i,j),routeTrace_x(i,j + 1) - routeTrace_x(i,j))*180/pi; %atan2 -pi~pi
            if(d <= R)
                link_off(i,j) = 0;
            else
                link_off(i,j) = 1;
            end
        end
    end
    
    %������·ֵ�����now_time=0ʱ�̵ı仯��
    deta_len = [];
    deta_angle = [];
    for i = 1:(trace_num - 1)
        for j = 1:(hop_num - 1)
            deta_len(i,j) = link_len(i + 1,j) - link_len(1,j);
            deta_angle(i,j) = link_angle(i + 1,j) - link_angle(1,j); %������step_timeʱ���ڵ��˶��켣����ֵ��ʾ��·˳ʱ��ת������ֵ��ʾ��·��ʱ��ת��
        end
    end
    
    %������·ֵ�仯���ľ����� ��ʾÿ����·�仯��һ���� �������ÿ����·���ȶ��䳤�ܶ��أ�
    %kexi_len = std(deta_len,0,2); %kexi_lenΪ������
    %kexi_angle = std(deta_angle,0,2);
    
    %������·ֵ�仯���ľ�ֵ
    kexi_len = mean(abs(deta_len),2);
    kexi_angle = mean(abs(deta_angle),2);
    
    %kexi_len kexi_angle��һ�� sigmoid����
    kexi_len_1 = [];
    kexi_angle_1 = [];
    for i = 1:(trace_num - 1)
        kexi_len_1 = [kexi_len_1 (1 - 1.2^(-(kexi_len(i))))];
        kexi_angle_1 = [kexi_angle_1 (1 - 1.2^(-(kexi_angle(i))))];
    end
    
    %�����trace����·ͨ����
    link_off_rate = []; %ԭʼ·�ɱض���100%ͨ
    for i = 2:trace_num
        link_off_rate = [link_off_rate sum(link_off(i,:))/(hop_num - 1)];
    end
    %����·�ɱ仯�� ��Ȩ ��·�ж��ʿ��Ե�����Ϊһ������ָ�꣬����·�ɱ仯����Ҫ������Э����бȽ�
    %link_len_angle = 0.85*kexi_len_1 + 0.15*kexi_angle_1;
    %link_len_angle = kexi_len_1;
    rsd = 0.65*kexi_len_1 + 0.25*kexi_angle_1 + 0.1*link_off_rate;
end
