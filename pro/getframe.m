function [topc,botr,botc]=getframe(img,nrows,ncols)
topc=1;
botr=nrows;
botc=ncols;
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