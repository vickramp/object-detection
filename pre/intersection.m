function a=intersection(a,img,ite,row,col)
for i=1:row
    for j=1:col
        if img(i,j)==a(i,j,ite) && img(i,j)==1
           a(i,j,ite)=1;
        else
            a(i,j,ite)=0;
        end
    end
end
