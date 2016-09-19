
clear all
clc
%%
delta_T = 1;
a=1;
%% LFSR1
% R1 : p1(x) = 1 + x + x6, T1 = 63

N1=63;               %D^2+D^1+1



M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=0;                                 % alter
M(6)=1; 

Sequence1=[];  %Initiation
for n = 1 : N1
    temp = xor(M(6), M(5));               % alter
    
    Sequence1(n)=M(6);                 % alter
    
    M(6) = M(5);
    M(5) = M(4);                       % alter
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
    
end



clear Sequence1_all;
Sequence1_all=[];
for r=1:300
    Sequence1_all=[Sequence1_all,Sequence1];  % Extend the sequence
end




%% LFSR2
% R2 : p2(x) = 1 + x^3 + x^7, T2 = 127
N2=127;


M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=0;
M(6)=0;
M(7)=1;                 % alter  % start from here

Sequence2=[];  %Initiation
for m= 1 : N2
    
    temp=xor(M(7), M(4));
    Sequence2(m)=M(7);      % alter
    
    M(7) = M(6);
    M(6) = M(5);
    M(5) = M(4);          % alter
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end

clear Sequence2_all;
Sequence2_all=[];
for r=1:300
    Sequence2_all=[Sequence2_all,Sequence2];  % Extend the sequence
end



%% output sequence
clear Shrunken_Sequence;
Shrunken_Sequence=[];            %% generate only one keystream
k=1;
for a=1:min(length(Sequence1_all),length(Sequence2_all))
    if Sequence1_all(a)==1
        Shrunken_Sequence(k)=Sequence2_all(a);
        k=k+1;
    end
end

%% period

period=seqperiod(Shrunken_Sequence');
Aperiod=seqperiod(Sequence1_all);
Bperiod=seqperiod(Sequence2_all);


%%  linear complexity

p=BM_Alg([Shrunken_Sequence',Shrunken_Sequence']);
LC=length(p)-1;



%% CA
% 
% S=[];
% si=1;
% for s=1:length(Shrunken_Sequence)
%     if mod(s,4)==0
%         S(si,4)=Shrunken_Sequence(s);
%         S(si,3)=Shrunken_Sequence(s-1);
%         S(si,2)=Shrunken_Sequence(s-2);
%         S(si,1)=Shrunken_Sequence(s-3);
%         si=si+1;
%     end
% end

%% Find Strings
% Shrunken_Sequence=Shrunken_Sequence';
% 
% 
% K='1010001101010111';
% Shunken_str=num2str(Shrunken_Sequence);
% K_len=length(K);
% 
% for ii=1:period
%     for jj=1:length(K)
%         if K(jj)==Shunken_str(ii+jj-1)
%         else 
%             jj=jj-1;
%             break;
%             
%         end
%     end
%     if jj==length(K)
%         ii
%         break;
%     end
% end
% fprintf('Done!');