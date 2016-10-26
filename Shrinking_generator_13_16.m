% D^16+D^15+D^4+D^1+1

% D^13+D^12+D^10+D^9+1

%%

clear all
clc
%%
delta_T = 1;
a=1;
%% LFSR1
% R1 : p1(x) =D^13+D^12+D^10+D^9+1, T1 =8191

N1=8191;               

M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=0;                                 % alter
M(6)=0; 
M(7)=0;
M(8)=0;
M(9)=0;
M(10)=0;
M(11)=0;
M(12)=0;
M(13)=1;


Sequence1=[];  %Initiation
for n = 1 : N1
    temp = xor(xor(xor(M(13), M(4)),M(3)),M(1));               % alter
    
    Sequence1(n)=M(13);                 % alter
    

   
    M(13) = M(12);
    M(12) = M(11);
    M(11) = M(10);
    M(10) = M(9);
    M(9) = M(8);
    M(8) = M(7);
    M(7) = M(6);
    M(6) = M(5);
    M(5) = M(4);                       % alter
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
    
end



clear Sequence1_all;
Sequence1_all=[];
for r=1:1
    Sequence1_all=[Sequence1_all,Sequence1];  % Extend the sequence
end




%% LFSR2
N2=65535;
% R1 : p1(x) =D^16+D^15+D^4+D^1+1, T1 =8191

M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=0;
M(6)=0;
M(7)=0;
M(8)=0;
M(9)=0;
M(10)=0;
M(11)=0;
M(12)=0;
M(13)=0;
M(14)=0;
M(15)=0;

M(16)=1;                                  % alter  % start from here

Sequence2=[];  %Initiation
for m= 1 : N2
    
    temp=xor(xor(xor(M(16), M(15)),M(12)),M(1));
    Sequence2(m)=M(16);      % alter
    
    M(16) = M(15);
    M(15) = M(14);
    M(14) = M(13);
    M(13) = M(12);
    
    M(12) = M(11);
    M(11) = M(10);
    M(10) = M(9);
    M(9) = M(8);
    M(8) = M(7);
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
for r=1:1
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