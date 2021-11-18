% For calculating packet loss and throughput, The throughput function is used.
function throughput_mou ()
thrgh= [];
global di_sd
global dfa
global pr
global datarate
global E
% The total distance from source to destination is computed using di_sd array and stored in a variable called total_distance.
total_distance = sum(di_sd);
total_distance
% The delay is total distance divided by velocity.
delay = total_distance/ (3*10^8);
delay
%packet size is taken in bytes.
packetsize=64;
% datarate defines the number of packets per second.
datarate=[21,20,19,17,16,14,13];
% Etx is initialised to 1 which is in joules
Etx=1;
Eini=Etx;
% Elec is the Amount of energy consumption per bit in the transmitter.
Elec=50e-9; 
Emp=0.0015e-12;
% EDA is the data aggregation energy
EDA=5e-9;
% These are the parameters used for packet loss calculation and energy.

alpha1=50e-9; %J/bit
alpha2=0.1e-9; %J/bit/m2
alpha=2;
% Ebit is energy assigned to each bit.
Ebit=0.3e-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to radio model, Energy Consumption is
% E = alpha1 + alpha2*(dist) ^ alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pr is the array to store Packet loss ratio
% pl iabls a varie to store number of packets lost
%Intially some amount of energy is assigned to packets. After reaching destination the Energy is again calculated. If the energy is less than 0.997 that packet is considered to be lost.
pr=[];
c=0;
pl=0;
for ff=1: length(datarate)
            Etx=1;
            c=0;
            pl=0;
 % Energy loss calculation in transmitting packets at  datarate         E(ff)=(alpha1*datarate(ff)*pktsize*8)+(alpha2*datarate(ff)*pktsize*8)*(total_distance)^alpha;
            Edata(ff)=Ebit*datarate(ff)*pktsize*8;
            for ll=1:datarate(ff)
                Etx=Etx-(Elec*8*pktsize+Emp*8*pktsize); %energy remaining
                Erx=Eini-Etx;
                Erx=Erx-(Elec+EDA)*8*pktsize;
                Eini=Etx;
	     % Etx
	    % If Etx is less than 0.9997
              % Then consider that packet is lost.
                if Etx<=0.9997
                    packetloss(ll)=1;
                    packetloss(ll);
                    c=c+1;
                else
                    packetloss(ll)=0;
                    packetloss(ll);
                end
                
            end
           %pl is calculated as number of packets lost divided by total number of packets sent.
 pl = c/datarate(ff);
disp(“ Loss ratio “)
            pr = [pr,pl];  
disp ("energies")
end
% END of throughput function
end
