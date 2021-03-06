function y=ZechLog(d1,d0)

N2=127;
alpha0=[0,0,0,0,0,0,1];
alpha1=[0,0,0,0,0,1,0];
alpha2=[0,0,0,0,1,0,0];
alpha3=[0,0,0,1,0,0,0];
alpha4=[0,0,1,0,0,0,0];
alpha5=[0,1,0,0,0,0,0];
alpha6=[1,0,0,0,0,0,0];
alpha7=[0,0,1,0,0,0,1];

alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7);

for al=8:N2
%     alpha(:,:,al)=xor(xor(xor(alpha(:,:,al-1),alpha(:,:,al-3) ),alpha(:,:,al-5)),alpha(:,:,al-7));
    alpha(:,:,al)=xor(alpha(:,:,al-3),alpha(:,:,al-7));
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