
clear all 
clc



%% Generate PN sequence
% 
% % Np=31;
% % delta_T = 1;
% % a=1;
% 
% % % %
% % M(1)=1;
% % M(2)=1;
% % M(3)=1;
% % M(4)=1;
% % M(5)=1;
% %
% % PN_Sequence = [];  %Initiation
% % for n = 1 : Np
% %     temp=xor(M(5), M(3));
% %     PN_Sequence(n)=M(5);               % alter
% %
% %
% %     M(5) = M(4);
% %     M(4) = M(3);
% %     M(3) = M(2);
% %     M(2) = M(1);
% %     M(1) = temp;
% % end


%%  CA

LC=12;

CA=[];   %% Initiation

CA(:,LC)=ones(16,1);
CA(:,1)=[0,1,0,1,1,1,0,0,1,0,1,1,0,0,1,0]';


for j=2:LC                                 %  coloum
    for i=1:size(CA,1)-j+1                 %  row
        CA(i,j)=xor(CA(i,j-1),CA(i+1,j-1));
    end
end


for x=1:LC-2
    y=LC-x;                               %coloum
    for z= i+1 :size(CA,1)        %row
        
        CA(z,y)=xor(CA(z-1,y),CA(z-1,y+1));
        
    end
end
