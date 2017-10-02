function c=same(a,x,y)
for i=1:x
    for j=1:y
        if a(i,j,1)~=a(i,j,2)
            c=0;
            return ;
        end
    end
end
c=1;
return ;