function [im,img]=getnew(img,row,col)
for i=1:row
    for j=1:col
        a(i,j,1)=0;
    end
end
flag=0;
for i=1:row
    for j=1:col
        if(img(i,j)==1)
           a(i,j,1)=1;
           flag=1;  
           break;
        end
    end
    if flag==1
        break;
    end
end
ite=2;
while true
    a=dilation(a,ite,row,col);   
    a=intersection(a,img,ite,row,col);
     ite=mod(ite,2)+1;
      if(same(a,row,col)==1)
        break;
      end
end
for i=1:row
    for j=1:col
        im(i,j)=a(i,j,mod(ite,2)+1);
    end
end
for i=1:row
    for j=1:col
        if(im(i,j)==1)
            img(i,j)=0;
        end
    end
end


