rng('shuffle')
x=rand(100,10000);
x=double(x>0.98);
y=sum(x,1);
x=x.*10.*rand(100,10000)+rand(100,10000);
% z=zeros(max(y)+1,size(x,2));
% for id=1:size(z,2)
%     z(y(id)+1,id)=1;
% end