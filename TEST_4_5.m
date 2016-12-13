function [runningtime]=TEST_4_5(~)
clear all
clc
%      clock
tic
% Zech Logorithm
N2=31;
alpha0=[0,0,0,0,1];
alpha1=[0,0,0,1,0];
alpha2=[0,0,1,0,0];
alpha3=[0,1,0,0,0];
alpha4=[1,0,0,0,0];        %D^4+D^1+1
alpha5=[0,0,1,0,1];
alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4,alpha5); %
for al=6:N2
    alpha(:,:,al)=xor(alpha(:,:,al-3),alpha(:,:,al-5));  % p(x)   +1:-10
end
load Shrunken_Sequence1000.mat;   %load shrunken sequence
load Sequence1_all1000.mat        %load PN sequence of R1
num_int=8;                   % numnber of intercepted bits
actual_position=zeros(num_int,1);  
Sequence1_all=Sequence1_all';
N1=15;
state=1;
d=modula(N1,N2);          %compute d
Correct_state=cat(3);     % Store correct initial states
correct_state=[];
correct_counter=1;
Times_positions_founded=zeros(N1+1,1);
% Generate Intercepted Bits set
Intercepted_Bits1=Shrunken_Sequence(1:num_int);
for gen_row=1:length(Intercepted_Bits1)-1
    for gen_col=1:length( eval(strcat('Intercepted_Bits',num2str(gen_row))))-1             %coloum
        eval(strcat('Intercepted_Bits',num2str(gen_row+1),'(gen_col)=xor(Intercepted_Bits',...          % Bits
            num2str(gen_row),'(gen_col),Intercepted_Bits',num2str(gen_row),'(gen_col+1));'));
    end
end
% Find positions of 1s in sequence1
nom_ones=1;
pos_original=zeros(num_int,1);
counter_ones=1;
while 1
    if Sequence1_all(counter_ones)==1
        actual_position(nom_ones)=counter_ones-1;
        pos_original(nom_ones)=counter_ones-1;
        nom_ones=nom_ones+1;
    end
    counter_ones=counter_ones+1;
    if nom_ones-1==num_int
        break;
    end
end
counter_ones=counter_ones-1;
% Calculate position 1 (No Zech Logorithm)
pos1=zeros(num_int,1);

for counter1=1:length(pos_original)
    pos1(counter1)=mod(pos_original(counter1)*d,N2);
end
% Zech Logorithm generating rest of positions
for row_counter=1:num_int
    for col_counter=1:length(eval(strcat('pos',num2str(row_counter))))-1
        if eval(strcat('pos',num2str(row_counter),'(col_counter)-pos',num2str(row_counter),...
                '(col_counter+1)<0'))     % increase
            eval(strcat('pos',num2str(row_counter),'(col_counter)=pos',num2str(row_counter),...
                '(col_counter)+N2;'));
        end
        eval(strcat('Zech_counter=xor(alpha(:,:,(pos',num2str(row_counter),...
            '(col_counter)-pos',num2str(row_counter),'(col_counter+1))+1),alpha(:,:,1));'))
        for search_counter=1:N2
            if Zech_counter==alpha(:,:,search_counter)
                break;
            end
        end
        eval(strcat('zech=search_counter-1+pos',num2str(row_counter),'(col_counter+1);'))          % decrease the order
        if zech>N2
            zech=zech-N2;
        end
        eval(strcat('pos',num2str(row_counter+1),'(col_counter)=zech;'))
        if eval(strcat('pos',num2str(row_counter),'(col_counter)-N2>=0'))        % decrease
            eval(strcat('pos',num2str(row_counter),'(col_counter)=pos',...
                num2str(row_counter),'(col_counter)-N2;'))
        end
    end
end
% Assign Intercepted Bits and judge
fprintf('%d.\n',state);
tf=0;
Recovery=[];
CheckArray=zeros(N2+1,1);
for gen_row=1:length(Intercepted_Bits1)
    for gen_col=1:length( eval(strcat('Intercepted_Bits',num2str(gen_row))))
        if eval(strcat('CheckArray(pos', num2str(gen_row),'(gen_col)+1)==1'))    %  compare
            if    eval(strcat('Recovery(pos',num2str(gen_row),'(gen_col)+1)~=Intercepted_Bits',...
                    num2str(gen_row),'(gen_col);'    ));
                tf=1;     % contradiction
                fprintf('Wrong!\n');
                fprintf('Contradiction found: line %d #%d, position: %d\n',gen_row,...
                    gen_col,eval(strcat('pos',num2str(gen_row),'(gen_col)')));
                break;
            end
        end
        eval(strcat('Recovery(pos',num2str(gen_row),'(gen_col)+1)=Intercepted_Bits',...             %
            num2str(gen_row),'(gen_col);'));
        eval(strcat('CheckArray(pos',num2str(gen_row),'(gen_col)+1)=1;'    ));                     % check
    end
    if tf==1
        break;
    end
end
Recovery=Recovery';
if tf==0
    Correct_state(:,:,correct_counter)=Sequence1_all(pos_original(1)+1:pos_original(1)+log2(N1+1));
    correct_state(correct_counter)=state;
    correct_counter=correct_counter+1;
    fprintf('Correct!\n');
    fprintf('%d',Sequence1_all(pos_original(1)+1:pos_original(1)+log2(N1+1)));
    fprintf('\n**********************************************************************\n');
end
pos1=pos1';
%% Other States !!!!!!!!!!!!
while state<=(N1-1)/2    
    state=state+1;
    fprintf('%d.\n',state);
    states=zeros(1,log2(N1+1));
    %% Shift line 1
    minus_num=pos1(2);
    pos1=pos1-minus_num;
    for counter_once=1:length(pos1)                     % get positions
        if pos1(counter_once)<0
            pos1(counter_once)=pos1(counter_once)+N2;
        end
    end
    pos1(1:end-1)=pos1(2:end);                       % shift 1 position,
    %% select the Original Position of the last bit
    pos_original(1:end)=pos_original(1:end)-pos_original(2);
    pos_original(1:end-1)=pos_original(2:end);
    actual_position(1:end-1)=actual_position(2:end);
    while 1
        counter_ones=counter_ones+1;
        if Sequence1_all(counter_ones)==1
            pos_original(end)=counter_ones-actual_position(1)-1;
            break;
        end
    end
    actual_position(end)=counter_ones-1;
    i=1;
    while 1
        if pos_original(i)>=log2(N1+1)
            break;
        end
        states(pos_original(i)+1)=1;
        i=i+1;
    end
    %% shift the rest of positions    
    for row_counter=2:num_int-1
        for col_counter=1:length(eval(strcat('pos',num2str(row_counter))))-1
            eval(strcat('pos',num2str(row_counter),'(col_counter)=pos',num2str(row_counter),...
                '(col_counter+1)-minus_num;'))
            if eval(strcat('pos',num2str(row_counter),'(col_counter)<0'))
                eval(strcat('pos',num2str(row_counter),'(col_counter)=pos',num2str(row_counter),...
                    '(col_counter)+N2;'))
            end
        end
    end
    %% calculate the last position in pos1, and rest of poitions
    pos1(end)=mod(pos_original(end)*d,N2);    
    for row_counter=2:num_int
        eval(strcat('pos',num2str(row_counter),'(end)=ZechLog_4_5(pos',...
            num2str(row_counter-1),'(end),pos',...
            num2str(row_counter-1),'(end-1));'))
    end
    %% Assign Intercepted Bits to new positions
    tf=0;
    Recovery=[];
    CheckArray=zeros(N2+1,1);
    for gen_row=1:length(Intercepted_Bits1)
        for gen_col=1:length( eval(strcat('Intercepted_Bits',num2str(gen_row))))
            if eval(strcat('CheckArray(pos', num2str(gen_row),'(gen_col)+1)==1'))    %  compare
                if    eval(strcat('Recovery(pos',num2str(gen_row),'(gen_col)+1)~=Intercepted_Bits',...
                        num2str(gen_row),'(gen_col);'    ));
                    tf=1;     % contradiction
                    Times_positions_founded(gen_row)=Times_positions_founded(gen_row)+1;
                    fprintf('%d',states);
                    fprintf('\nWrong!\n');
                    fprintf('Contradiction found: line %d #%d, position: %d\n',gen_row,...
                        gen_col,eval(strcat('pos',num2str(gen_row),'(gen_col)')));
                    break;
                end
            end
            eval(strcat('Recovery(pos',num2str(gen_row),'(gen_col)+1)=Intercepted_Bits',...             %
                num2str(gen_row),'(gen_col);'));
            eval(strcat('CheckArray(pos',num2str(gen_row),'(gen_col)+1)=1;'));                     % check
        end
        if tf==1
            break;
        end
    end
    if tf==0
        Correct_state(:,:,correct_counter)=states;
        correct_state(correct_counter)=state;
        correct_counter=correct_counter+1;
        fprintf('Correct!\n');
        fprintf('%d',states);
        fprintf('\n**********************************************************************\n');
    end
end   %while
runningtime=toc
Correct_state
correct_state
Times_positions_founded
save workspace_4_5_19
end

