function  im=del(im,id2,nrows,ncols,i)
for x=1:nrows
    for y=1:ncols
        im(x,y,id2)=im(x,y,i);
    end
end