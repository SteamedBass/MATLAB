function  y=modula(L1,L2)



for d=1:L2
    if mod(L1*d,L2)==1
        break;
    end
end
y=d;
end