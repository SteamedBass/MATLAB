
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

N1=31;               %D^2+D^1+1



M(1)=0;
M(2)=0;
M(3)=0;
M(4)=0;
M(5)=1;                                 % alter

Sequence1=[];  %Initiation
for n = 1 : N1
    temp = xor(M(5), M(2));               % alter
    
    Sequence1(n)=M(5);                 % alter
    
    M(5) = M(4);                       % alter
    M(4) = M(3);
    M(3) = M(2);
    M(2) = M(1);
    M(1) = temp;
    
end



clear Sequence1_all;
Sequence1_all=[];
for r=1:500
    Sequence1_all=[Sequence1_all,Sequence1];  % Extend the sequence
end




%% LFSR2

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
for r=1:500
    Sequence2_all=[Sequence2_all,Sequence2];  % Extend the sequence
end



%% output sequence
clear Z;
Z=[];            %% generate only one keystream
k=1;
for a=1:min(length(Sequence1_all),length(Sequence2_all))
    if Sequence1_all(a)==1
        Z(k)=Sequence2_all(a);
        k=k+1;
    end
end

%% period

period=seqperiod(Z');


%%  linear sequence

p=BM_Alg([Z',Z']);
LC=length(p)-1;



%% CA

S=[];
si=1;
for s=1:length(Z)
    if mod(s,4)==0
        S(si,4)=Z(s);
        S(si,3)=Z(s-1);
        S(si,2)=Z(s-2);
        S(si,1)=Z(s-3);
        si=si+1;
    end
end

%% Find Strings
Z=Z';


K='1111111011100';
Z_str=num2str(Z);
K_len=length(K);

for ii=1:period
    for jj=1:length(K)
        if K(jj)==Z_str(ii+jj-1)
        else
            jj=jj-1;
            break;
        end
    end
    if jj==length(K)
        ii
        break;
    end
end
fprintf('Done!');