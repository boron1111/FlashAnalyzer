% x=cpYFP(119,:);
x=TMRM(218,:);
b=ones(length(x),1)*x;

a=zeros(length(x));
for id=1:length(x)
    a(id,id:end)=x(1:length(x)+1-id);
end

c=b-a;
imtool(c)