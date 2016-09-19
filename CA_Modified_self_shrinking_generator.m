
%% Generate PN sequence

Np=31;
delta_T = 1;
a=1;

% % %
% M(1)=1;
% M(2)=1;
% M(3)=1;
% M(4)=1;
% M(5)=1;
% 
% PN_Sequence = [];  %Initiation
% for n = 1 : Np
%     temp=xor(M(5), M(3));
%     PN_Sequence(n)=M(5);               % alter
%     
%     
%     M(5) = M(4);
%     M(4) = M(3);
%     M(3) = M(2);
%     M(2) = M(1);
%     M(1) = temp;
% end


%%  CA 

LC=12;

CA_MSSG=[];   %% Initiation

CA_MSSG(LC,:)=1;








