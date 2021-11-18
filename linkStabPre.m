function [link_stability] = linkStabPre(link_fnode_id,link_bnode_id)
    
    global mobi_model_speed mobi_model_direct;
    global num_neb;
    global fis;
    
    %����ģ���������������ٶ���Զ�
    vmax = 16.7;
    detav = abs(mobi_model_speed(link_fnode_id) - mobi_model_speed(link_bnode_id))/vmax;
    
    %����ģ��������������������Զ�
    detadp = abs(mobi_model_direct(link_fnode_id) - mobi_model_direct(link_bnode_id));
    if (detadp > pi)
        detad = (2*pi - detadp)/pi;
    else
        detad = detadp/pi;
    end
    
    %����ģ����������������·�����ܶ�
    nmax = 1.1*max(num_neb);  %ȡ�ڵ��ھ��������ֵ ����aven��ƫ������Ǽ�����ĳ��ֵ����������������ӣ�
    aven = (num_neb(link_fnode_id) + num_neb(link_bnode_id))/(2*nmax);
    
    %����ģ���������������·�ȶ���
    %link_stability = evalfis([detav detad],fis);
    link_stability = evalfis([detav detad aven],fis);
end