function tmp=merge(img1,img2,nrows,ncols)
for i=1:nrows
    for j=1:ncols
        if img1(i,j)==1 || img2(i,j)==1
            tmp(i,j)=1;
        else
            tmp(i,j)=0;
        end
    end
end
