function    a=dilation(a,ite,row,col)
for i=1:row
    for j=1:col
        b(i,j)=a(i,j,mod(ite,2)+1);
         a(i,j,ite)=a(i,j,mod(ite,2)+1);
    end
end
for i=1:row
    for j=1:col
        if b(i,j)==1
            for x=i-1:i+1
                for y=j-1:j+1
                    if x>0 &&y>0 && x<=row &&x<=col
                        a(x,y,ite)=1;
                    end
                end
            end
        end
    end
end