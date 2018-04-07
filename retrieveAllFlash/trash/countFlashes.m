target=zeros(28867,1);
for id=1:28867
    x=allFlashes(:,1)==allROIs(id,1) & allFlashes(:,2)==allROIs(id,2);
    target(id)=sum(x);
end
