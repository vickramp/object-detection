clc;
clear all;
k0=input('1 for known object (or) 2 for unknown object detection');
if k0==1
    k1=input('1 for giving training set or 2 for testing set');
    if(k1<1 &&k1>2)
        disp('input error');
        return;
    end
else if k0~=2
        disp('input error');
        return;
    end
end
he = imread('3.png');
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(he,1);
ncols = size(he,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 5;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',5);
 pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels,[]);
%{
tmp=pixel_labels(1,1);
for j=1:ncols
    for i=1:nrows
        if(pixel_labels(i,j)==tmp)
            pixel_labels(i,j)=0;
        else
            pixel_labels(i,j)=1;
        end
    end
end
imshow(pixel_labels);
%}
for k = 1:nColors
    for i=1:nrows
            for j=1:ncols
                    if pixel_labels(i,j)==k
                              
                        img(i,j,k)=1;
                    else
                        img(i,j,k)=0;
                    end
            end
    end
end
for k=1:nColors
    if img(1,1,k)==1
            for i=1:nrows
                for j=1:ncols
                    img(i,j,k)=0;
                end
            end
    end
end
%{
for k=1:nColors
    if (img(1,1,k)==0)
        continue;
    else
        for i=1:nrows
            for j=1:ncols
                if(img(i,j,k)==1)
                    img(i,j,k)=0;
                else
                    img(i,j,k)=1;
                end
            end
        end
    end
end
%}
% for k=1:nColors
%     imshow(img(:,:,k),[]);
%     figure;
% end
i=0;
SE=[1 1 1;1 1 1;1 1 1];
for k=1:nColors
   t0=imerode(img(:,:,k),SE);
  while(true)   
       if nonew(t0,nrows,ncols)==1;
           break;
       end
       i=i+1;
       [tmp,t0]=getnew(t0,nrows,ncols);
                  sum(sum(tmp))
                  if(sum(sum(tmp))<(ncols*nrows/500))
                      i=i-1;
                      continue;
                  end
       for x=1:nrows
           for y=1:ncols
               im(x,y,i)=tmp(x,y);
           end
       end
  end
end
for k=1:i
   %imshow(im(:,:,k),[]);
%figure;
  % disp('hi'); 
  % imshow(scaleimg(im(:,:,k),nrows,ncols),[]);
  [img1,r,c]=scaleimg(im(:,:,k),nrows,ncols);
img1=im2bw(img1);
c0=regionprops(img1,'Area','Centroid','MajorAxisLength','MinorAxisLength','Eccentricity','Orientation','EquivDiameter','Perimeter');
 c0.Area=c0.Area/30000;
 c0.Centroid(1)=c0.Centroid(1)/150;
 c0.Centroid(2)=c0.Centroid(2)/200;
 c0.MajorAxisLength=c0.MajorAxisLength/250;
 c0.MinorAxisLength=c0.MinorAxisLength/250;
 c0.Orientation=(c0.Orientation+180)/360;
 c0.EquivDiameter=c0.EquivDiameter/196;
 c0.Perimeter=c0.Perimeter/700;
 c1(1)=c0.Area;
 c1(2)=c0.Centroid(1);
 c1(3)=c0.Centroid(2);
 c1(4)=c0.MajorAxisLength;
 c1(5)=c0.MinorAxisLength;
 c1(6)=c0.Eccentricity;
 c1(7)=c0.Orientation;
 c1(8)=c0.EquivDiameter;
 c1(9)=c0.Perimeter; 
 if k0==1
     if k1==1
        a=xlsread('data.xlsx','','','basic');
        sze=0;
        if ~isempty(a)
        sze=length(a(:,1));
        end
         sze=sze+1;
         a(sze,1)=c0.Area;
         a(sze,2)=c0.Centroid(1);
         a(sze,3)=c0.Centroid(2);
         a(sze,4)=c0.MajorAxisLength;
         a(sze,5)=c0.MinorAxisLength;
         a(sze,6)=c0.Eccentricity;
         a(sze,7)=c0.Orientation;
         a(sze,8)=c0.EquivDiameter;
         a(sze,9)=c0.Perimeter;
         xlswrite('data.xlsx',a);
     else
        a=xlsread('data.xlsx','','','basic');
        min=9999;
        ind=-1;
        for ii=1:length(a(:,1))
            tmin=0;
            for ij=1:length(a(1,:))
                tmin=tmin+(a(ii,ij)-c1(ij))^2;
            end
            tmin=tmin^0.5;
            if(tmin<min)
                ind=ii;
                min=tmin;
            end
        end
        imshow(img1);title(strcat('belongs to group ','  ',int2str(ind),' , deviation: ',num2str(min)));
        figure;
     end
 else
      a=xlsread('data.xlsx','','','basic');
        min=9999;
        ind=-1;
        thresh=0.02;
        ii=1;
        if ~isempty(a)
        for ii=1:length(a(:,1))
            tmin=0;
            for ij=1:length(a(1,:))
                tmin=tmin+(a(ii,ij)-c1(ij))^2;
            end
            tmin=tmin^0.5;
            if(tmin<min)
                ind=ii;
                min=tmin;
            end
        end
        end
        if(min<thresh)
        imshow(img1);title(strcat('belongs to group ','  ',int2str(ind),' ,deviation: ',num2str(min)));
        figure;
        else
            if ind==-1
                ind=1;
            else 
                ind=length(a(:,1))+1;
            end
        imshow(img1);title(strcat('belongs to group ','  ',int2str(ind),' ,deviation: ',num2str(min)));
        figure;
        sze=0;
        if ~isempty(a)
        sze=length(a(:,1));
        end
         sze=sze+1;
         a(sze,1)=c0.Area;
         a(sze,2)=c0.Centroid(1);
         a(sze,3)=c0.Centroid(2);
         a(sze,4)=c0.MajorAxisLength;
         a(sze,5)=c0.MinorAxisLength;
         a(sze,6)=c0.Eccentricity;
         a(sze,7)=c0.Orientation;
         a(sze,8)=c0.EquivDiameter;
         a(sze,9)=c0.Perimeter;
         xlswrite('data.xlsx',a);
        end
        
 end
end

