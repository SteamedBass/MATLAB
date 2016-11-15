function y=ZechLog_14_15(d1,d0)

N2=2^15-1;              %D^15+D^14+D^5+D^2+1

alpha0=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
alpha1=[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
alpha2=[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0];
alpha3=[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
alpha4=[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
alpha5=[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0];
alpha6=[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
alpha7=[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
alpha8=[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0];
alpha9=[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
alpha10=[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0];
alpha11=[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
alpha12=[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
alpha13=[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha14=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha15=[0,1,0,0,1,0,0,0,0,0,0,0,0,1,1]; % p(x) is different with p2(x)


alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10,alpha11,alpha12,alpha13,alpha14,alpha15); %

for al=16:N2
    alpha(:,:,al)=xor(xor(xor(alpha(:,:,al-2),alpha(:,:,al-5)),alpha(:,:,al-14)),...
        alpha(:,:,al-15));  % p(x)   +1:-10                     

end

if d1-d0<0
    d1=d1+N2;
end

k=xor(alpha(:,:,(d1-d0)+1),alpha(:,:,1));      % result of Zech

for m=1:N2
    
    if k==alpha(:,:,m)
        break;
    end
end

zech=m-1+d0;              % decrease the order
if zech>N2
    zech=zech-N2;
end

y=zech;