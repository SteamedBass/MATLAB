clear all
clc

% %

% D^6+D^4+D^3+D^1+1
% D^6+D^5+1
% D^6+D^5+D^2+D^1+1
% D^6+D^5+D^3+D^2+1
% D^6+D^5+D^4+D^1+1
% %


% D^6+D^1+1

% D^5+D^2+1

%% Generate PN
% Np=63;                           % alter
Np=31;
% Np=127;
% Np=15;
delta_T = 1;
a=1;

% %
M(1)=1;
M(2)=1;
M(3)=1;
M(4)=1;
M(5)=1;
% M(6)=1;                            % alter
% M(7)=1;
M_XuLie = [];  %Initiation
for n = 1 : Np
    %    temp = xor(xor(xor(xor(xor(M(7), M(6)),M(5)),M(3)),M(2)),M(1));          % alter
    temp=xor(M(5), M(3));
    M_XuLie(n)=M(5);               % alter
    
    %    M(7) = M(6);
    %    M(6) = M(5);                        % alter
        M(5) = M(4);
        M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end


clear M_XuLie_all;
M_XuLie_all=[];
for r=1:200
    M_XuLie_all=[M_XuLie_all,M_XuLie];    % Extend
end
%% output sequence
% % compare 2 digits


Z=[];
k=1;
for i=2:length(M_XuLie_all)
    M=mod(i,2);
    if M==0
        if  M_XuLie_all(i-1)==1
            Z(k)=M_XuLie_all(i);
            k=k+1;
        end
    end
    
end

%% linear complexity

p=BM_Alg([Z,Z]);
LC=length(p)-1;


%% period


D= Z';
period=seqperiod(D);




