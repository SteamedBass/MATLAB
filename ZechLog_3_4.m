function y=ZechLog_3_4(d1,d0)

N2=15;
alpha0=[0,0,0,1];
alpha1=[0,0,1,0];
alpha2=[0,1,0,0];
alpha3=[1,0,0,0];
alpha4=[0,0,1,1];    %D^4+D^1+1

alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4);

for al=5:N2
    alpha(:,:,al)=xor(alpha(:,:,al-3),alpha(:,:,al-4) );
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