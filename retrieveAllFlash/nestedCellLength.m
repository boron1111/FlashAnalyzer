function Rt=nestedCellLength(cell1)

Rt=0;
for id=1:length(cell1)    
    if iscell(cell1{id})
        Rt=Rt+nestedCellLength(cell1{id});
    else
        Rt=Rt+length(cell1{id});
    end
end