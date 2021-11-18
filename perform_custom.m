function [through,dens_tp,pr,time_consumed]=perform_custom(route)
    global nowlocation_x nowlocation_y;
    global r_source alq_source r alq;
    format shortG;
    for ii=1:length(route)-1
       % dist(ii)=sqrt((nowlocation_x(route(ii+1))-nowlocation_x(route(ii)))^2+(nowlocation_y(route(ii+1)))-nowlocation_y(route(ii))^2);
       dist(ii)=norm([nowlocation_x(route(ii+1)) nowlocation_x(route(ii))]-[nowlocation_y(route(ii+1)) nowlocation_y(route(ii))]);
        %fprintf('%d',dist(ii));
        scale_alq=(mean([alq(route(ii)) alq(route(ii+1))])-50)/5.0;
        scale_RSS=(15-std([r(route(ii)) r(route(ii+1))]));
        cc=scale_alq+scale_RSS;
        cm(ii)=(cc*4)/100;
    end
    total_dist=sum(dist);
    %fprintf('%d',total_dist);
    %fprintf('\n');
    time_consumed=total_dist/(3);
    pktsize=64;% in bytes
    datarate=[4,6,8,10,12,14]; % packets/sec
    pr=[];
    for ff=1:length(datarate)
        through(1,ff)= (datarate(ff)*pktsize*10e8)/time_consumed;
       % fprintf('%d',through(1,i));
       c=0;
       pl=0;
        for kk=1:length(cm)
           for dd=1:datarate(ff)
              if(cm(kk)<=0.6)
                  c=c+1;
              end
           end
        end
        pl= c/(datarate(ff)*length(cm));
        pr=[pr pl];
        
    end
    
    dens_tp=through(1,4);
    
end