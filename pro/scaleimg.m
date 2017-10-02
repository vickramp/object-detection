function [im,r,c]=scaleimg(img,nrows,ncols,d1,d2)
topr=1;
topc=1;
botr=nrows;
botc=ncols;
for i=1:nrows
    if sum(img(i,:)) >0
        topr=i;
        break;
    end
end
for i=1:ncols
   if sum(img(:,i)) >0
        topc=i;
        break;
    end
end
for i=nrows:-1:1
    if sum(img(i,:)) >0
        botr=i;
        break;
    end
end
for i=ncols:-1:1
    if sum(img(:,i)) >0
        botc=i;
        break;
    end
end
k=1;
img1=[];    
for i=topr:botr
    l=1;
    for j=topc:botc
        img1(k,l)=img(i,j);

        l=l+1;
    end
            k=k+1;
end
r=d1;
c=d2;
im=imresize(img1,[r,c]);