xm=100;
ym=100;
sink.x=50;
sink.y=50;
n=100;
p=0.1;
Eo=0.5;
ETX=50*0.000000001;  %tx energy
ERX=50*0.000000001;  %rx energy
Efs=10*0.000000000001;  %free space loss
Emp=0.0013*0.000000000001;   %multipath loss
%Data Aggregation Energy
EDA=5*0.000000001;  %compression energy
rmax=5000;
do=sqrt(Efs/Emp);
Et=0;  
for h=1:1
    S(n+1).xd=sink.x;
    S(n+1).yd=sink.y;
    Et=0;
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
    S(i).distance=distance;
    S(i).G=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo*(1+rand);
    Et=Et+S(i).E;
end

countCHs=0;  %variable, counts the cluster head
cluster=1;  %cluster is initialized as 1
flag_first_dead=0; %flag tells the first node dead
flag_half_dead=0;  %flag tells the 10th node dead
flag_all_dead=0;  %flag tells all nodes dead
first_dead1=0;
half_dead=0;
all_dead=0;
allive=n;
%counter for bit transmitted to Bases Station and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
packets_TO_BS_per_round=0;
for r=0:1:rmax
    r
    packets_TO_BS_per_round=0;
    %Operations for epochs
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            S(i).cl=0;
        end
    end
   
    %hold off;
   
    %Number of dead nodes
    dead=0;
   
     for i=1:1:n
        %checking if there is a dead node
        if (S(i).E<=0)
            %plot(S(i).xd,S(i).yd,'red .');
           
            dead=dead+1;
            if (dead==1)
              if(flag_first_dead==0)
                 first_dead1=r;
                 flag_first_dead=1;
              end
            end
            if(dead==0.5*n)
              if(flag_half_dead==0)
                  half_dead=r;
                  flag_half_dead=1;
              end
            end
            if(dead==n)
              if(flag_all_dead==0)
                  all_dead=r;
                  flag_all_dead=1;
              end
            end
           
            %hold on;
        end
        if S(i).E>0
            S(i).type='N';
        end
    end
   
        %plot(S(n+1).xd,S(n+1).yd,'x');
        STATISTICS.DEAD(h,r+1)=dead;
        STATISTICS.ALLIVE(h,r+1)=allive-dead;
  
   countCHs=0;
    cluster=1;
    for i=1:1:n
        if(S(i).E>0)
            temp_rand=rand;
            if ( (S(i).G)<=0)
               
                %Election of Cluster Heads for normal nodes
                if ( temp_rand <= ( p/ ( 1 - p * mod(r,round(1/p)) )) )
                   
                    countCHs=countCHs+1;
                    packets_TO_BS=packets_TO_BS+1;
                    packets_TO_BS_per_round=packets_TO_BS_per_round+1;
                    PACKETS_TO_BS(r+1)=packets_TO_BS;
                   
                   
                    S(i).type='C';
                    S(i).G=round(1/p)-1;
                    C(cluster).xd=S(i).xd;
                    C(cluster).yd=S(i).yd;
              
                   
                    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
                    C(cluster).distance=distance;
                    C(cluster).id=i;
                    X(cluster)=S(i).xd;
                    Y(cluster)=S(i).yd;
                    cluster=cluster+1;
                   
                    %Calculation of Energy dissipated
                    distance;
                    if (distance>do)
                        S(i).E=S(i).E- ( (ETX+EDA)(4000) + Emp*4000( distance*distance*distance*distance ));
                    end
                    if (distance<=do)
                        S(i).E=S(i).E- ( (ETX+EDA)(4000)  + Efs*4000( distance * distance ));
                    end
                end
   
            end    
        end
    end
       
         STATISTICS.COUNTCHS(h,r+1)=countCHs;
    
 %Election of Associated Cluster Head for Normal Nodes
     for i=1:1:n
       if ( S(i).type=='N' && S(i).E>0 )
        if(cluster-1>=1)
       min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
       min_dis_cluster=0;
         for c=1:1:cluster-1
           temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
           end
       end
       %Calculating the culsterheads%
       if(min_dis_cluster~=0)    
            min_dis;
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
            end
     
            S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 );
            packets_TO_CH=packets_TO_CH+1;
       else
            min_dis;
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
            end
            packets_TO_BS=packets_TO_BS+1;
            packets_TO_BS_per_round=packets_TO_BS_per_round+1;
            PACKETS_TO_BS(r+1)=packets_TO_BS;
       end
        S(i).min_dis=min_dis;
       S(i).min_dis_cluster=min_dis_cluster;
   else
            min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
            end
            packets_TO_BS=packets_TO_BS+1;
            packets_TO_BS_per_round=packets_TO_BS_per_round+1;
           
   end
  end
end
STATISTICS.PACKETS_TO_CH(h,r+1)=packets_TO_CH;
STATISTICS.PACKETS_TO_BS(h,r+1)=packets_TO_BS;
STATISTICS.PACKETS_TO_BS_PER_ROUND(h,r+1)=packets_TO_BS_per_round;
STATISTICS.THROUGHPUT(h,r+1)=STATISTICS.PACKETS_TO_BS(h,r+1)+STATISTICS.PACKETS_TO_CH(h,r+1);

 En=0;
for i=1:n
    if S(i).E<=0
        continue;
    end
    En=En+S(i).E;
end
ENERGY(r+1)=En;
STATISTICS.ENERGY(h,r+1)=En;

end
first_dead_LEACH(h)=first_dead1
half_dead_LEACH(h)=half_dead
all_dead_LEACH(h)=all_dead

% cluster head display-------

end
for r=0:rmax
    STATISTICS.DEAD(h+1,r+1)=sum(STATISTICS.DEAD(:,r+1))/h;
    STATISTICS.ALLIVE(h+1,r+1)=sum(STATISTICS.ALLIVE(:,r+1))/h;
    STATISTICS.PACKETS_TO_CH(h+1,r+1)=sum(STATISTICS.PACKETS_TO_CH(:,r+1))/h;
    STATISTICS.PACKETS_TO_BS(h+1,r+1)=sum(STATISTICS.PACKETS_TO_BS(:,r+1))/h;
    STATISTICS.PACKETS_TO_BS_PER_ROUND(h+1,r+1)=sum(STATISTICS.PACKETS_TO_BS_PER_ROUND(:,r+1))/h;
    STATISTICS.THROUGHPUT(h+1,r+1)=sum(STATISTICS.THROUGHPUT(:,r+1))/h;
    STATISTICS.COUNTCHS(h+1,r+1)=sum(STATISTICS.COUNTCHS(:,r+1))/h;
    STATISTICS.ENERGY(h+1,r+1)=sum(STATISTICS.ENERGY(:,r+1))/h;
end

first_dead1=sum(first_dead_LEACH)/h;
half_dead=sum(half_dead_LEACH)/h;
all_dead=sum(all_dead_LEACH)/h;

r=0:rmax;
figure(1);
subplot(3,3,1);
plot(r,STATISTICS.DEAD);
hold on;
subplot(3,3,2);
plot(r,STATISTICS.ALLIVE);
hold on;
subplot(3,3,3);
plot(r,STATISTICS.PACKETS_TO_BS);
hold on;
subplot(3,3,4);
plot(r,STATISTICS.COUNTCHS);
hold on;
subplot(3,3,5);
plot(r,STATISTICS.ENERGY);
hold on;
subplot(3,3,6);
plot(r,STATISTICS.THROUGHPUT);
hold on;
subplot(3,3,7);
plot(r, STATISTICS.PACKETS_TO_BS_PER_ROUND);
hold on;
subplot(3,3,8);
plot(r,STATISTICS.PACKETS_TO_CH);
hold on;
first_dead1

clear all
xm=100;
ym=100;
sink.x=0.5*xm;  %location of sink on x-axis
sink.y=0.5*ym;  %location of sink on y-axis
n=100  %nodes
P=0.1;  %probability of cluster heads
Eo=0.5;%initial energy
ETX=50*0.000000001;  %tx energy
ERX=50*0.000000001;  %rx energy
Efs=10*0.000000000001;  %free space loss
Emp=0.0013*0.000000000001;   %multipath loss
%Data Aggregation Energy
EDA=5*0.000000001;  %compression energy
a=1.5;   %fraction of energy enhancment of advance nodes
rmax=5000; %maximum number of rounds
do=sqrt(Efs/Emp);  %distance do is measured
Et=0;  %variable just use below
m=0.5;
mo=0.4;
b=2;
normal=n*(1-m);
advance=n*m*(1-mo);
super=n*m*mo;
for i=1:1:super
H(i).xd=rand(1,1)*xm;  %generates a random no. use to randomly distibutes nodes on x axis
XR(i)=H(i).xd;
H(i).yd=rand(1,1)*ym;  %generates a random no. use to randomly distibutes nodes on y axis
YR(i)=H(i).yd;
H(i).G=0; %node is elegible to become cluster head
H(i).E=Eo*(1+b);
E(i)= H(i).E;
Et=Et+E(i);  %estimating total energy of the network
%initially there are no cluster heads only nodes
H(i).type='N';
end
talha1=super+advance;
for i=super:1:talha1
H(i).xd=rand(1,1)*xm;  %generates a random no. use to randomly distibutes nodes on x axis
XR(i)=H(i).xd;
H(i).yd=rand(1,1)*ym;  %generates a random no. use to randomly distibutes nodes on y axis
YR(i)=H(i).yd;
H(i).G=0; %node is elegible to become cluster head
%talhar=rand*a
H(i).E=Eo*(1+a);
%H(i).A=talhar;
E(i)= H(i).E;
Et=Et+E(i);  %estimating total energy of the network
%initially there are no cluster heads only nodes
H(i).type='N';
end
for i=talha1:1:n
H(i).xd=rand(1,1)*xm;  %generates a random no. use to randomly distibutes nodes on x axis
XR(i)=H(i).xd;
H(i).yd=rand(1,1)*ym;  %generates a random no. use to randomly distibutes nodes on y axis
YR(i)=H(i).yd;
H(i).G=0; %node is elegible to become cluster head
H(i).E=Eo;
E(i)= H(i).E;
Et=Et+E(i);  %estimating total energy of the network
%initially there are no cluster heads only nodes
H(i).type='N';
end
d1=0.765*xm/2;  %distance between cluster head and base station
K=sqrt(0.5*n*do/pi)*xm/d1^2; %optimal no. of cluster heads
d2=xm/sqrt(2*pi*K);  %distance between cluster members and cluster head
Er=4000*(2*n*ETX+n*EDA+K*Emp*d1^4+n*Efs*d2^2);  %energy desipated in a round
H(n+1).xd=sink.x; %sink is a n+1 node, x-axis postion of a node
H(n+1).yd=sink.y; %sink is a n+1 node, y-axis postion of a node
countCHs=0;  %variable, counts the cluster head
cluster=1;  %cluster is initialized as 1
flag_first_dead=0; %flag tells the first node dead
dead=0;  %dead nodes count initialized to 0
first_dead=0;
allive=n;
%counter for bit transmitted to Bases Station and to Cluster Heads
packets_TO_BS=0;
packets_TO_CH=0;
for r=0:1:rmax
r
packets_TO_BS_per_round=0;
if(mod(r, round(1/P) )==0)
for i=1:1:n
H(i).G=0;
H(i).cl=0;
end
end
Ea=Et*(1-r/rmax)/n;
dead=0;
for i=1:1:n
if (H(i).E<=0)
dead=dead+1;
if (dead==1)
if(flag_first_dead==0)
x1=r;
flag_first_dead=1;
end
end
end
if H(i).E>0
H(i).type='N';
end
end
STATISTICS.DEAD(r+1)=dead;
STATISTICS.ALLIVE(r+1)=allive-dead;
countCHs=0;
cluster=1;
for i=1:1:n

if Ea>0
if (H(i).E<= Eo)
p(i)=P*E(i)/(1+m*(a+mo*b))*Ea;
end
if (H(i).E<=Eo*(1+a))
p(i)=P*(1+a)E(i)/(1+m(a+mo*b))*Ea;
end
if (H(i).E<=Eo*(1+b))
p(i)=P*(1+b)E(i)/(1+m(a+mo*b))*Ea;
end
if(H(i).E>0)
temp_rand=rand;
if ( (H(i).G)<=0)
if(temp_rand<= (p(i)/(1-(p(i)*(r*mod(1,p(i)))))))
countCHs=countCHs+1;
packets_TO_BS=packets_TO_BS+1;
PACKETS_TO_BS(r+1)=packets_TO_BS;
H(i).type='C';
H(i).G=round(1/p(i))-1;
C(cluster).xd=H(i).xd;
C(cluster).yd=H(i).yd;
distance=sqrt( (H(i).xd-(H(n+1).xd) )^2 + (H(i).yd-(H(n+1).yd) )^2 );
C(cluster).distance=distance;
C(cluster).id=i;
X(cluster)=H(i).xd;
Y(cluster)=H(i).yd;
cluster=cluster+1;
distance;
if (distance>do)
H(i).E=H(i).E- ( (ETX+EDA)(4000) + Emp*4000( distance*distance*distance*distance ));
end
if (distance<=do)
H(i).E=H(i).E- ( (ETX+EDA)(4000)  + Efs*4000( distance * distance ));
end
end
end
end
end
end
STATISTICS.COUNTCHS(r+1)=countCHs;
for i=1:1:n
if ( H(i).type=='N' && H(i).E>0 )
if(cluster-1>=1)
min_dis=sqrt( (H(i).xd-H(n+1).xd)^2 + (H(i).yd-H(n+1).yd)^2 );
min_dis_cluster=0;
for c=1:1:cluster-1
temp=min(min_dis,sqrt( (H(i).xd-C(c).xd)^2 + (H(i).yd-C(c).yd)^2 ) );
if ( temp<min_dis )
min_dis=temp;
min_dis_cluster=c;
end
end
if(min_dis_cluster~=0)
min_dis;
if (min_dis>do)
H(i).E=H(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
end
if (min_dis<=do)
H(i).E=H(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
end
H(C(min_dis_cluster).id).E = H(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 );
packets_TO_CH=packets_TO_CH+1;
else
min_dis;
if (min_dis>do)
H(i).E=H(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
end
if (min_dis<=do)
H(i).E=H(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
end
packets_TO_BS=packets_TO_BS+1;
end
H(i).min_dis=min_dis;
H(i).min_dis_cluster=min_dis_cluster;
else
min_dis=sqrt( (H(i).xd-H(n+1).xd)^2 + (H(i).yd-H(n+1).yd)^2 );
if (min_dis>do)
H(i).E=H(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
end
if (min_dis<=do)
H(i).E=H(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
end
packets_TO_BS=packets_TO_BS+1;
packets_TO_BS_per_round=packets_TO_BS_per_round+1;
end
end
end
STATISTICS.PACKETS_TO_CH(r+1)=packets_TO_CH;
STATISTICS.PACKETS_TO_BS(r+1)=packets_TO_BS;
STATISTICS.THROUGHPUT(r+1)=STATISTICS.PACKETS_TO_BS(r+1)+STATISTICS.PACKETS_TO_CH(r+1);
STATISTICS.packets_TO_BS_per_round(r+1)=packets_TO_BS_per_round;
En=0;
for i=1:n
    if H(i).E<=0
        continue;
    end
    En=En+H(i).E;
end
ENERGY(r+1)=En;
STATISTICS.ENERGY(r+1)=En;
En
end

r=0:5000;
subplot(3,3,1);
plot(r,STATISTICS.DEAD);
legend('Leach','Edeec')
subplot(3,3,2);
plot(r,STATISTICS.ALLIVE);
legend('Leach','Edeec')
subplot(3,3,3);
plot(r,STATISTICS.PACKETS_TO_BS);
legend('Leach','Edeec')
subplot(3,3,4);
plot(r,STATISTICS.COUNTCHS);
legend('Leach','Edeec')
subplot(3,3,5);
plot(r,STATISTICS.ENERGY);
legend('Leach','Edeec')
subplot(3,3,6);
plot(r,STATISTICS.THROUGHPUT);
legend('Leach','Edeec')
subplot(3,3,7);
plot(r, STATISTICS.packets_TO_BS_per_round);
legend('Leach','Edeec')
subplot(3,3,8);
plot(r,STATISTICS.PACKETS_TO_CH);
legend('Leach','Edeec')