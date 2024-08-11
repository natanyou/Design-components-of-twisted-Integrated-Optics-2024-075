x=ones(2,2);
y=ones(2,2)*2;
z=zeros(2,size(x,1),size(x,2));
z(1,:,:)=x;
z(2,:,:)=y