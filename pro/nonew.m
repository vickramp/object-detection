function k=nonew(img,r,c)
for i=1:r
    for j=1:c
            if img(i,j)==1
                k=0;
                return;
            end
    end
end
k=1;
return;