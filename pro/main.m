clc;
clear all;
he = imread('44.png');
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,2:3));
thresh=0;
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
%     for k=1:nColors
%         imshow(img(:,:,k),[]);
%         figure;
%     end
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
k=0;
i
while (k<i)
   k=k+1;
% figure;
%   % disp('hi');
%  imshow(im(:,:,k));
%[img1,r,c]=scaleimg(im(:,:,k),nrows,ncols);
%img1=im2bw(img1);
c0=regionprops(im(:,:,k),'Centroid');
thresh=1;                        %max distance threshold
[topc,botr,botc]=getframe(im(:,:,k),nrows,ncols);
topr=botr;
botr=botr+thresh;
y=int64(c0.Centroid(1));
x=int64(c0.Centroid(2));
c0
while( x<nrows && im(x,y,k)~=0)
        x=x+1;
end
if x+thresh>=nrows
    continue;
end
[i,k,im]=localstab(im,k,x,y,topr,botr,topc,botc,i,ncols,nrows,thresh);

if k==0
    continue;
end

end
stat(i)=0;
for k=1:i
   %imshow(im(:,:,k),[]);
%figure;
  % disp('hi'); 150 200
  % imshow(scaleimg(im(:,:,k),nrows,ncols),[]);
  dim1=76; %optimal 76
  dim2=128; %optimal 128
  [img1,r,c]=scaleimg(im(:,:,k),nrows,ncols,dim1,dim2);
img1=im2bw(img1);
c0=regionprops(img1,'Area','Centroid','MajorAxisLength','MinorAxisLength','Eccentricity','Orientation','EquivDiameter','Perimeter');
 if length(c0.Area==1)  
 c1(k,1)=(c0.Area)/(r*c);
 else
     c1(k,1)=(sum(c0.Area)/(length(c0.Area)*r*c));
 end
 
 if length(c0.Centroid(1)==1)  
 c1(k,2)=c0.Centroid(1)/r;
 else
 c1(k,2)=sum(c0.Centroid(1))/(r*length(c0.Centroid(1)));
 end
 
  if length(c0.Centroid(1)==1)  
 c1(k,3)=c0.Centroid(2)/c;
  else
 c1(k,3)=sum(c0.Centroid(2))/(c*c0.Centroid(2));
      
  end
  if length(c0.MajorAxisLength==1)
 c1(k,4)=c0.MajorAxisLength/((r+c));
  else
 c1(k,4)=sum(c0.MajorAxisLength)/(length(c0.MajorAxisLength)*(r+c));
  end
  if length(c0.MinorAxisLength==1)
 c1(k,5)=c0.MinorAxisLength/((r+c));
  else
 c1(k,5)=sum(c0.MinorAxisLength)/((length(c0.MinorAxisLength))*(r+c));
  end
  if length(c0.Orientation==1)
 c1(k,7)=(c0.Orientation+180)/360;
  else
 c1(k,7)=(sum(c0.Orientation)+180)/(360*length(c0.Orientation));
  end
  if length(c0.EquivDiameter==1)
 c1(k,8)=c0.EquivDiameter/(2*(r+c)/3);
  else
 c1(k,8)=sum(c0.EquivDiameter)/((length(c0.EquivDiameter)*(2*(r+c)/3)));
  end   
  if length (c0.Perimeter==1)
 c1(k,9)=c0.Perimeter/(4*(r+c));
  else
 c1(k,9)=sum(c0.Perimeter)/(length(c0.Perimeter*(4*(r+c))));
  end  
  if length (c0.Eccentricity==1)
 c1(k,6)=c0.Eccentricity;
  else
 c1(k,6)=sum(c0.Eccentricity)/length(c0.Eccentricity);
  end      
      a=xlsread('data.xlsx','','','basic');
        min=9999;
        ind=-1;`
        thresh=0.2;
        ii=1;
        if ~isempty(a)
        for ii=1:length(a(:,1))
            tmin=0;
            for ij=1:length(a(1,:))
                tmin=tmin+(a(ii,ij)-c1(k,ij))^2;
            end
            tmin=tmin^0.5;
            if(tmin<min)
                ind=ii;
                min=tmin;
            end
        end
        end
        if(min<thresh)
%         imshow(img1);title(strcat('belongs to group ','  ',int2str(ind),' ,deviation: ',num2str(min)));
%         figure;
        else
            if ind==-1
                ind=1;
            else
                ind=length(a(:,1))+1;
            end

%         imshow(img1);title(strcat('belongs to group ','  ',int2str(ind),' ,deviation: ',num2str(min)));
%         figure;
        sze=0;
        if ~isempty(a)
        sze=length(a(:,1));
        end
         sze=sze+1;
         a(sze,1)=c1(k,1);
         a(sze,2)=c1(k,2);
         a(sze,3)=c1(k,3);
         a(sze,4)=c1(k,4);
         a(sze,5)=c1(k,5);
         a(sze,6)=c1(k,6);
         a(sze,7)=c1(k,7);
         a(sze,8)=c1(k,8);
         a(sze,9)=c1(k,9);
         stat(k)=1;
         xlswrite('data.xlsx',a);
        end

 end
for k=1:i
    if stat(k)==1
        min=0;
        thresh=0.2;
        ii=1;
        
        for ii=1:length(c1(:,1))
           tmin=0;
            for ij=1:length(c1(1,:))
                tmin=tmin+((c1(ii,ij)-c1(k,ij))^2);
            end
            tmin=tmin^0.5;
            if(tmin<thresh)
                min=min+1;
            end
        end
        imshow(im(:,:,k),[]);
        title(strcat('number of similar elements',num2str(min)));
        figure;
    end
end
