
clear all
clc
% D^5+D^2+1
% D^5+D^3+1
% D^5+D^3+D^2+D^1+1
% D^5+D^4+D^2+D^1+1
% D^5+D^4+D^3+D^1+1
% D^5+D^4+D^3+D^2+1
% %

% %
% D^6+D^4+D^3+D^1+1
% D^6+D^5+1
% D^6+D^5+D^2+D^1+1
% D^6+D^5+D^3+D^2+1
% D^6+D^5+D^4+D^1+1
% D^6+D^1+1
% %

% D^3+D^1+1
% D^3+D^2+1


% D^4+D^1+1
% D^4+D^3+1

%%

% N2=63;

% N2=15;                                     % alter

delta_T = 1;
a=1;

%D^5+D^2+1

%  D^3+D^1+1



%% LFSR1

N1=15;               %D^3+D^2+1



M(1)=0;
M(2)=0;
M(3)=0;
M(4)=1;

Sequence1=[];  %Initiation
for n = 1 : N1
    temp = xor(M(4), M(1));               % alter
    
    Sequence1(n)=M(4);                 % alter
    
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end



clear Sequence1_all;
Sequence1_all=[];
for r=1:100
    Sequence1_all=[Sequence1_all,Sequence1];  % Extend the sequence
end




%% LFSR2

N2=31;
%   D^4+D^3+1


M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=1;

Sequence2=[];  %Initiation
for m= 1 : N2
 
    temp=xor(M(5), M(2));
    Sequence2(m)=M(5);      % alter
    
    M(5) = M(4);
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
end

clear Sequence2_all;
Sequence2_all=[];
for r=1:100
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
Aperiod=seqperiod(Sequence1_all');
Bperiod=seqperiod(Sequence2_all');
%%  linear sequence

p=BM_Alg([Shrunken_Sequence',Shrunken_Sequence']);
LC=length(p)-1;



%% CA

S=[];
si=1;
for s=1:length(Shrunken_Sequence)
    if mod(s,4)==0
        S(si,4)=Shrunken_Sequence(s);
        S(si,3)=Shrunken_Sequence(s-1);
        S(si,2)=Shrunken_Sequence(s-2);
        S(si,1)=Shrunken_Sequence(s-3);
        si=si+1;
    end
end