function [distance,path] = Dijkstra(W,st,e)
   
    %W Ȩֵ����
    %st ���������  
    %e �������յ�
    
    %W weight matrix
    %st start of search
    %e end of search
    
    n = length(W);
    D = W(st,:);
    visit = ones(1,n);
    visit(st) = 0;
    parent = zeros(1,n);
    path =[];
  
    for i = 1:n-1
        temp = [];
        %��������������̾������һ���㣬ÿ�β����ظ�ԭ���Ĺ켣������visit�жϽڵ��Ƿ��ѱ�����  
        for j = 1:n
            if visit(j)
                temp = [temp D(j)];
            else
                temp = [temp inf];
            end
        end
        [value,index] = min(temp);
        visit(index) = 0;
        %���� �������index�ڵ㣬����㵽ÿ���ڵ��·�����ȸ�С������£���¼ǰ���ڵ㣬�������ѭ�� Starting from the starting point, find the next point with the shortest distance, and will not repeat the original trajectory each time, set visit to determine whether the node has been visited
        for k = 1:n
            if D(k) > D(index) + W(index,k)
                D(k) = D(index) + W(index,k);
                parent(k) = index;
            end
        end
    end
    distance = D(e);%��̾��� Shortest distance
    %���ݷ�  ��β����ǰѰ������·�� Backtracking method Find the search path from the tail forward
    t = e; 
    while t ~= st && t > 0
        path = [t,path];
        t = parent(t);
    end
    path = [st,path];%���·��  Shortest path
end
