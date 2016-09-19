
clear all
clc
%%  CA shrinking generator

LC=60;

CA=[];   %% Initiation

% CA(:,LC)=ones(22,1);
CA(:,1)=[1,0,1,1,1,0,1,1,0,0,0,1,1,1,0,1,0,0,0,0,1,0,1,0,1,1,0,0,1,1,0,1,1,0,1,0,0,1,1,0,0,0,0,1,0,1,1,1,1,1,0,0,0,1,1,1,0,1,1,0]';


for j=2:LC                                 %  coloum
    for i=1:size(CA,1)                 %  row
        if i==size(CA,1)
            CA(i,j)=xor(CA(1,j-1),CA(i,j-1));
        else
            CA(i,j)=xor(CA(i+1,j-1),CA(i,j-1));
        end
    end
end


