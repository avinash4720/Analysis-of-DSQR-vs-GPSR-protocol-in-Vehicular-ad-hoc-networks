function [link_matrix] = lsprInitialLink()

    global R num_node;
    global node_x node_y;
    global fis;
    
    %��ȡԤ����Ƶ�ģ������ϵͳ
    %fis = readfis('lspRefer');
    fis = readfis('lspFuzzy');
    
    %����link��ؾ���
    for node_i = 1:num_node
        for node_j = 1:num_node
            d = sqrt((node_x(node_i) - node_x(node_j))^2 + (node_y(node_i) - node_y(node_j))^2);
            if (node_i ~= node_j)
                if (d <= R)
                    link_matrix(node_i,node_j) = 1 - linkStabPre(node_i,node_j); %ע��Dijkstra�ǻ��ڱ�Ȩֵ��С����ģ������õ����ȶ�����Խ��Խ�ã��� 1- ת��
                else
                    link_matrix(node_i,node_j) = inf;
                end
            else
                link_matrix(node_i,node_j) = 0;
            end
        end
    end
end