clear all
clc

%  p(x)=x^7+x^6+x^4+x^2+1                  No change if R2 does not change.
%  polynomial=[1 1 0 1 0 1 0 1];
%  polynomial=poly2str(polynomial,'x');


% R1 : p1(x) = 1 + x3 + x5,  T1 = 31
% R2 : p2(x) = 1 + x + x6, T2 = 63

% %      clock
% delta_T = 1;

load Shrunken_Sequence100000000.mat;
%% LFSR1

N1=511;
count=1:N1;
initial_state=dec2bin(count);
bit=2;
state=1;
Number_of_InterceptedBits=[];      % Number of Intercepted bits needed
Contradiction_positions=[];      % postions when contraditions are found
N2=1023;
d=modula(N1,N2);
Correct_state=cat(3);     % Store correct initial states
correct_counter=1;
No_correct_state=[];    % # of correct states

% M(1)=0;
% M(2)=0;
% M(3)=0;
% M(4)=0;
% M(5)=0;                                 % alter
% M(6)=0;
% M(7)=0;
% M(8)=0;
% M(9)=1;

%%  1.Try all initial states
for state=1:N1
    %%   clear parameters
    clear temp trans tf s posOrg p0 p1 p2 i j Int_row Int_col Pos_row Pos_col...
        IntBits1 IntBits2 IntBits3 IntBits4 Recovery CheckArray ...
        IntBits5 IntBits6 IntBits7 IntBits8 IntBits9 IntBits10 IntBits11 IntBits12...
        IntBits13 IntBits14 IntBits15 IntBits16 IntBits17 IntBits18 IntBits19 IntBits20 IntBits21...
        IntBits22 IntBits23 IntBits24 IntBits25 IntBits26 IntBits27 IntBits28 IntBits29...
        pos1 pos2 pos3 pos4 pos5 pos6 pos7 pos8 pos9 pos10 pos11 pos12 pos13...
        pos14 pos15 pos16 pos17 pos18 pos19 pos20 pos21 pos22 pos23 pos24 pos25 pos26 pos27 pos28 pos29 pos30 pos31 pos32 assign M
    
    fprintf('%d. \n',state);
    M(1)=str2double(initial_state(state,1));
    M(2)=str2double(initial_state(state,2));
    M(3)=str2double(initial_state(state,3));
    M(4)=str2double(initial_state(state,4));
    M(5)=str2double(initial_state(state,5));
    M(6)=str2double(initial_state(state,6));
    M(7)=str2double(initial_state(state,7));
    M(8)=str2double(initial_state(state,8));
    M(9)=str2double(initial_state(state,9));
    
    
    if M(9)==0                         % Reject initial states starting with 0
        continue;
    end
    
    Sequence1=[];  %Initiation
    for n = 1 : N1
        temp = xor(M(9), M(5));               % alter%!!!!!!!!!!!!!!!!!!
        
        Sequence1(n)=M(9);                 % alter
        
        M(9) = M(8);
        M(8) = M(7);
        M(7) = M(6);
        M(6) = M(5);
        M(5) = M(4);                       % alter
        M(4) = M(3);
        M(3) = M(2);
        M(2) = M(1);
        M(1) =temp;
    end
    clear Sequence1_all;                 % Extend the sequence
    Sequence1_all=[];
    for seq_counter=1:5
        Sequence1_all=[Sequence1_all,Sequence1];
    end
    
    Sequence1_all=Sequence1_all';
    %% Increase the number of Intercepted Bits until contradiction is found
    bit=19;
    %     for bit=2:N1
    %%  2.Find positions of 1s in Seq 1
    IntBits1=Shrunken_Sequence(1:bit);
    
    p0=0;
    p1=1;
    posOrg=[];    % Initiation
    
    for p1=1:length(Sequence1_all)
        
        if Sequence1_all(p1)==1
            p0=p0+1;             % counter
            posOrg(p0)=p1-1;     % positions of 1s in Seq 1
        end
        if p0==length(IntBits1)
            break;
        end
    end
    posOrg=posOrg';
    %% 3.Find positions of 1s in Recovery
    
    
    pos1=[]; % Initiation
    p2=1;
    for p2=1:length(IntBits1)
        pos1(p2)=mod(posOrg(p2)*d,N2);
    end
    
    pos1=pos1';
    %% 4.Assign intercepted bits to Recovery
    assign=1;
    Recovery=[];  % Initiation
    CheckArray=zeros(N2+1,1);  % Initiation
    for assign=1:length(IntBits1)
        Recovery(pos1(assign)+1)=IntBits1(assign);
        CheckArray(pos1(assign)+1)=1;
    end
    Recovery=Recovery';
    %%  5.New intercepted bits
    
    tf=0;
    gen_row=1;          % j
    gen_col=1;          % i
    
    for gen_row=1:length(IntBits1)-1
        for gen_col=1:length( eval(strcat('IntBits',num2str(gen_row))))-1             %coloum
            
            
            eval(strcat('IntBits',num2str(gen_row+1),'(gen_col)=xor(IntBits',...          % Bits
                num2str(gen_row),'(gen_col),IntBits',num2str(gen_row),'(gen_col+1));'));
            
            eval(strcat('pos',num2str(gen_row+1),'(gen_col)=ZechLog_9_10(pos',...             % positions
                num2str(gen_row),'(gen_col),pos',num2str(gen_row),'(gen_col+1));'));
            
            if eval(strcat('CheckArray(pos', num2str(gen_row+1),'(gen_col)+1)==1'))                    %  compare
                if    eval(strcat('Recovery(pos',num2str(gen_row+1),'(gen_col)+1)~=IntBits',...
                        num2str(gen_row+1),'(gen_col);'    ));
                    tf=1;                                                                             % contradiction
                    
                    eval(strcat('Contradiction_positions(state)=pos',...
                        num2str(gen_row+1),'(gen_col);'));
                    fprintf('Wrong!\n');
                    fprintf('Contradiction found: line %d #%d, position: %d\n',gen_row+1,...
                        gen_col,eval(strcat('pos',num2str(gen_row+1),'(gen_col)')));
                    break;
                end
            end
            
            eval(strcat('Recovery(pos',num2str(gen_row+1),'(gen_col)+1)=IntBits',...             %
        num2str(gen_row+1),'(gen_col);'));
    eval(strcat('CheckArray(pos',num2str(gen_row+1),'(gen_col)+1)=1;'    ));                     % check
        end
        if tf==1
            break;
        end
        
    end
    
    
    %% If it is correct, assign new bits
    if tf==1
        continue;
    end
    

% if tf==1
%     break;
% end

          %% # of line

%         if tf==1             %% fixed
%             Number_of_InterceptedBits(state)=bit;
%             break;
%         end
%

%     end   %% # of Intercepted Bits








%% If correct, print right states
if tf==0
    Number_of_InterceptedBits(state)=bit;
    Correct_state(:,:,correct_counter)=M;
    No_correct_state(correct_counter)=state;
    correct_counter=correct_counter+1;
    fprintf('Correct!\n');
    fprintf('%d',M);
    fprintf('\n*******************************************************\n');
    
end

 end  %% Different states

% [Order,index]=sort(Number_of_InterceptedBits);
% index_m=find(Order==Order(end));     %% Find out positons of largest numbers
% target_maximum_number=Order(index_m(1)-1)      %% Find out what is the second largest number
% positon_2=index(Order==target_maximum_number); %% Find out where is the second largest number

%
%
% %% Transpose Rows into Coloums
% for trans=2:bit
%     eval(strcat('pos',num2str(trans),'=pos',num2str(trans),''';'));
% end
%



