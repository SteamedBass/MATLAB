


clear Auto
Auto=[];

    
    for row=1:length(Sequence)
        auto=0;
        for coloum=1:length(Sequence)
            if A(row,coloum)==Sequence(coloum)
                auto=auto+1;
                
            end
            
        end
        diff=length(Sequence)-auto;
           Auto(row)=(auto-diff)/length(Sequence);
    end
 

Auto=Auto';