clear all
clc



%% Generate PN
% Np=63;          % D^6+D^1+1                         %%%% alter
% Np=127;      %% D^7+D^1+1
Np=31;       %% D^5+D^2+1
% Np=7;         %D^3+D^1+1
% Np=15;      %D^4+D^1+1
% Np=255;
% Np=511;
% Np=1023;
% Np=32767;
delta_T = 1;
a=1;

% %
M(1)=1;
M(2)=1;
M(3)=1;
M(4)=1;
M(5)=1;
% M(6)=1;                                       % alter
% M(7)=1;
% M(8)=1;
% M(9)=1;
% M(10)=1;
% M(11)=1;
% M(12)=1;
% M(13)=1;
% M(14)=1;
% M(15)=1;

M_XuLie(Np) = 0;                              %Initiation
for n = 1 : Np
    %         temp =xor(xor(xor(xor( xor(M(7), M(6)),M(5)),M(4)),M(3)),M(2));                   % alter
%     temp = xor(xor(xor(xor(xor(xor(xor(M(10), M(9)),M(8)),M(7)),M(6)),M(5)),M(4)),M(1));
    %     temp = xor(xor(xor(M(9), M(8)),M(4)),M(1));
            temp =xor(M(5), M(3));
    M_XuLie(n)=M(5);                        %%% alter
    
    %        M_XuLie(n)=M(5);
    
    
%         M(15) = M(14);
%         M(14) = M(13);
%         M(13) = M(12);
%         M(12) = M(11);
%         M(11) = M(10);
%     M(10) = M(9);
%     M(9) = M(8);
%     M(8) = M(7);
%     M(7) = M(6);
%     M(6) = M(5);                              % alter
    M(5) = M(4);
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end
%%  Extend
clear M_XuLie_all;
M_XuLie_all=[];
for r=1:10
    M_XuLie_all=[M_XuLie_all,M_XuLie];
end



%%
% %  Compare 3 digits in each group
Z=[];
k=1;
for i=1:length(M_XuLie_all)
    for j=3*i
        
        if j>length(M_XuLie_all)
            break;
        else
            judge = xor(M_XuLie_all(j-1),M_XuLie_all(j-2));
            if judge==1;
                
                Z(k)=M_XuLie_all(j);
                k=k+1;
            end
        end
    end
end

%% linear complexiity

p=BM_Alg([Z',Z']);
LC=length(p)-1;


%% period



D= Z';
period=seqperiod(D);


% half=ceil(length(Z)/2);
% for i=1:half-1
%     h=half-i;
%     x=h-1;
%     j=1;
%     while Z(j)==Z(h)
%         j=j+1;
%         h=h+1;
%
%
%
%         if j==x
%            x
%         end
%     end
%
%
% end


