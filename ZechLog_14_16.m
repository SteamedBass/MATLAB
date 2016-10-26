function y=ZechLog_14_16(d1,d0)

N2=65535;              %

alpha0=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
alpha1=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
alpha2=[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0];
alpha3=[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
alpha4=[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
alpha5=[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0];
alpha6=[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
alpha7=[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
alpha8=[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0];
alpha9=[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
alpha10=[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0];
alpha11=[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
alpha12=[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0];
alpha13=[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha14=[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha15=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
alpha16=[1,1,1,1,1,1,0,1,0,1,1,1,0,0,1,1];       % p(x)=D^16+D^15+D^14+D^13+D^12+D^11+D^10+D^8+D^6+D^5+D^4+D+1


alpha=cat(3,alpha0,alpha1,alpha2,alpha3,alpha4,alpha5,alpha6,alpha7,alpha8,alpha9,alpha10,alpha11,alpha12,alpha13,alpha14,alpha15,alpha16); %

for al=17:N2
    alpha(:,:,al)=xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(xor(alpha(:,:,al-1),alpha(:,:,al-2)),alpha(:,:,al-3)),alpha(:,:,al-4)),alpha(:,:,al-5)),alpha(:,:,al-6))...
        ,alpha(:,:,al-8)),alpha(:,:,al-10)),alpha(:,:,al-11)),alpha(:,:,al-12)),alpha(:,:,al-15)),alpha(:,:,al-16));  % p(x)   +1:-10                     

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