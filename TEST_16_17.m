
tic
clear all
clc
%      clock
delta_T = 1;
%D^15+D^14+D^5+D^2+1
%
T1=16;
T2=17;
% Zech Logorithm
N2=2^T2-1;              %

alpha0=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
alpha1=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
alpha2=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0];
alpha3=[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
alpha4=[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
alpha5=[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0];
alpha6=[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
alpha7=[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
alpha8=[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0];
alpha9=[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
alpha10=[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0];
alpha11=[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
alpha12=[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
alpha13=[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha14=[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha15=[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha16=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha17=[1,1,0,0,0,1,0,0,0,1,1,0,0,0,0,0,1];       % p(x) is different with p2(x)


alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10,alpha11,alpha12,alpha13,alpha14,alpha15,alpha16,alpha17); %

for al=18:N2
    
    alpha(:,:,al)=xor(xor(xor(xor(xor(alpha(:,:,al-1),alpha(:,:,al-2)),alpha(:,:,al-6)),alpha(:,:,al-10)),alpha(:,:,al-11)),alpha(:,:,al-17));  % p(x)   +1:-10
end
load Shrunken_Sequence_16_17.mat;

actual_position=[];

load Sequence1_all_16.mat
Sequence1_all=Sequence1_all';
N1=2^T1-1;
count=1:N1;
initial_state=dec2bin(count);
state=1;
correct_state=[];
d=modula(N1,N2);
Correct_state=cat(3);     % Store correct initial states
correct_counter=1;
states=zeros(1,log2(N1+1));



num_int=50;
Times_positions_founded=zeros(num_int+1,1);

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
pos_original=[];
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
pos1=[];

for counter1=1:length(pos_original)
    pos1(counter1)=mod(pos_original(counter1)*d,N2);
end


%% Zech Logorithm generating rest of positions


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
                Times_positions_founded(gen_row)=Times_positions_founded(gen_row)+1;
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
pos_original=pos_original';
actual_position=actual_position';
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
    
    counter_once=1;
    
    
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
        eval(strcat('pos',num2str(row_counter),'(end)=ZechLog_16_17(pos',...
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

save workspace_15_16_50



