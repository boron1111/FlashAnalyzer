function result=netPatternRecogIDL(para1)

tmp=load('normalize');
leftM=ones(size(para1,1),1);
para_mean=leftM*tmp.character(1,:);
para_std=leftM*tmp.character(2,:);
para_max=leftM*tmp.character(3,:);
para_min=leftM*tmp.character(4,:);

inputs=(para1-para_mean)./para_std;
inputs=1./(1+exp(-inputs));
inputs=(inputs-para_min)./(para_max-para_min)*2-1;

tmp1=load('weights');

a1=inputs*tmp1.IW{1}';
b1=leftM*tmp1.b{1}';
a1=a1+b1;
a1=2./(1+exp(-2*a1))-1;

a1=(a1-tmp.hidden_normalize(2))/...
    (tmp.hidden_normalize(1)-tmp.hidden_normalize(2))*2-1;

a1=a1*tmp1.LW{2}';
b1=leftM*tmp1.b{2}';
a1=a1+b1;
a1=1./(1+exp(-2*a1));
a1=a1';

result=a1(1,:);