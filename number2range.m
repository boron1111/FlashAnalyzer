function range=number2range(loc)

col=loc(2);

a=floor((col-1)/26);
if a==0
    char1='';
else
    char1=char('A'+a-1);
end

b=mod(col,26);
if b==0
    b=26;
end
char2=char('A'+b-1);

range=strcat(char1,char2,num2str(loc(1)));