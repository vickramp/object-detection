function [i,k,im]=localstab(im,k,x,y,topr,botr,topc,botc,i,ncols,nrows,thresh)
id1=-1;
id2=-1;
id3=-1;


for i1=1:nrows
    for j1=1:ncols
        tmp(i1,j1)=im(i1,j1,k);
    end
end


for j=1:i
    if j==k
        continue;
    end
    sm0=sum(im(x:x+thresh,y,j));   
     if(sm0>0)
      tmp(x:x+thresh,y)=1;
      tmp=merge(tmp,im(:,:,j),nrows,ncols);
      id1=j;
      break;
     end
end


for j=1:i
   if j==k ||j==id1
       continue;
   end
   sm1=sum(sum(im(x:x+thresh,topc:y,j)));
  if sm1>0
        id2=j;
  end
end


if id2~=-1 
for j=1:i
   if j==k ||j==id1
       continue;
   end
   sm1=sum(sum(im(x:x+thresh,y+1:botc,j)));
  if sm1>0
     tmp(topr:botr,y:y+thresh)=1;
      tmp=merge(tmp,im(:,:,j),nrows,ncols);
      tmp=merge(tmp,im(:,:,id2),nrows,ncols);
      id3=j;
  end
end
end


if(id1~=-1)
    im=del(im,id1,nrows,ncols,i);
    i=i-1;
end

    
if(id2~=-1&&id3~=-1)
    im=del(im,id2,nrows,ncols,i);
    if~(id2==id3)
    im=del(im,id3,nrows,ncols,i-1);
        i=i+1;
    end
    i=i-2;
end


for i1=1:nrows
    for j1=1:ncols
       im(i1,j1,k)=tmp(i1,j1);
    end
end


if id1~=-1 &&id2~=-1 &&id3~=-1
    k=0;
end