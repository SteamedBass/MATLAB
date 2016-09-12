clear all
clc

%%
% D^6+D^1+1
% D^6+D^4+D^3+D^1+1
% D^6+D^5+1
% D^6+D^5+D^2+D^1+1
% D^6+D^5+D^3+D^2+1
% D^6+D^5+D^4+D^1+1
% %
% D^7+D^6+1
% x^17 + x^16 + x^15 + x^11 + x^6 + x^4 + 1
% D^15+D^1+1
% D^9+D^5+1
% 

% %
%%  Generate PN
Np=31;
% Np=63;                                                       % alter
% Np=511;
delta_T = 1;
a=1;

% %
M(1)=1;
M(2)=1;
M(3)=1;
M(4)=1;
M(5)=1;
% M(6)=1;                                                         % alter
% M(7)=1;
% M(8)=1;
% M(9)=1;
% M(10)=1;
% M(11)=1;
% M(12)=1;
% M(13)=1;
% M(14)=1;
% M(15)=1;

Sequence(Np) = 0;  %Initiation
for n = 1 : Np
    temp = xor(xor(xor(M(5), M(4)),M(3)),M(1));                                    % alter
%        temp = xor(M(5), M(3));
    Sequence(n)=M(5);                                         % alter
    %    Sequence(n)=M(5);
    
    
    
%     M(15) = M(14);
%     M(14) = M(13);
%     M(13) = M(12);
%     M(12) = M(11);
%     M(11) = M(10);
%     M(10) = M(9);
%     M(9) = M(8);
%     M(8) = M(7);
%     M(7) = M(6);
%     M(6) = M(5);                                           % alter
    M(5) = M(4);
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end
% figure(4);
% stairs(Sequence);
% ylim([-2 2]);

clear Sequence_all;
Sequence_all=[];
for r=1:10
    
    Sequence_all=[Sequence_all,Sequence];  % Extend the sequence
end
%% decide how many bits you want to move
% % % % Shift
% % M_change=[]; %Initiation
% % m=input('How many you want to move: ');
% % for j=1:Np-m
% % M_change(j)=Sequence(j+m);
% % end
% %
% % for o=1:m
% %     M_change=[M_change,Sequence(o)];
% % end
% %
% % % % Output
% %
% %
% % Z=[];%Initiation
% % k=1;
% % for i=1:Np
% %     if Sequence(i)==1;
% %         Z(k)=M_change(i);
% %     k=k+1;
% %     end
% % end

%%  Family
% % %
A=[];   % Initiation

for a=1:length(Sequence_all)-1
    for j=1:length(Sequence_all)-a
        A(a,j)=Sequence_all(j+a);
    end
    
    for o=1:a
        A(a,length(Sequence_all)-a+o)=Sequence_all(o);
    end
    
end




%%  Genarate output Sequences

B=[];
for b=1:length(Sequence_all)-1
    q=1;
    for b1=1:size(A,1)
        
        if Sequence_all(b1)==1
            B(b,q)=A(b,b1);
            q=q+1;
        end
    end
    
end

%% period


D= B';
period=seqperiod(D);
period=period';

%% linear complexity
for k=1:size(B,1)
    
    p=BM_Alg([B(k,:),B(k,:)]);
    LC(k)=length(p)-1;
end

LC=LC';


%     p=[];
%
%     for k=1:size(B,1)
%
%
%        p(k,1:size(B,1))=BM_Alg([B(k,:),B(k,:)]);
%
%
%
%        LC(k)=length(p(k,:))-1;
%
%     end

% p=BM_Alg([B(5,:),B(5,:)]);
