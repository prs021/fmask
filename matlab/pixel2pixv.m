function outim=pixel2pixv(jiul1,jiul2,resolu1,resolu2,im2,jidim1,jidim2)
% from stack images of different resolution and different projection 
% Improved version of lndpixel2pixv
% match image2 with image1
% Input 1) jiul1 (upperleft corner of the pixel) of image 1
% Input 2) jiul2 (upperleft corner of the pixel) of image 2
% Input 3&4) j cols, i rows of image 1
% Input 5&6) resolution of images 1&2
% Input 7) image 2 data 
% Input 8&9) image 1 and 2 dimension
% output matched data = outim(f(i),f(j))=>im1(i,j)
% i.e. matchdata=pixel2pixv(ul1,ul2,res1,res2,data2,dim1,dim2);
j=1:jidim1(1);
i=1:jidim1(2);
[x,y]=lndpixel2map(jiul1,j,i,resolu1);
[j2,i2]=lndmap2pixel(jiul2,x,y,resolu2);

% the first data is assume to be the filled value
fill_v=im2(1,1);
outim=fill_v*ones(jidim1(2),jidim1(1),class(fill_v)); % give filled data first


jexist=(((j2 > 0)&(j2 <= jidim2(1)))); % matched data i,j exit in data2
iexist=(((i2 > 0)&(i2 <= jidim2(2))));

%jexistv=j2(((j2 > 0)&(j2 <= jidim2(1)))); % exist i,j => data2 (f(i),f(j))
%iexistv=i2(((i2 > 0)&(i2 <= jidim2(2))));

jexistv=j2(jexist); % exist i,j => data2 (f(i),f(j))
iexistv=i2(iexist);

outim(iexist,jexist)=im2(iexistv,jexistv);
end

% pixel to map
function [x,y]=lndpixel2map(jiUL,j,i,resolu)
% from pixel to map
% Input jiUL (upperleft corner of the pixel) meters (x,y)
% resolution [x, y]
% output x, y of center of the pixel i,j
% i.e. [x,y]=lndpixel2maplndpixel2map(jiUL,j,i,resolu)
x=jiUL(1)+resolu(1)/2+(j-1)*resolu(1);
y=jiUL(2)-resolu(2)/2+(1-i)*resolu(2);

end

% map to pixel
function [j,i]=lndmap2pixel(jiUL,x,y,resolu)
% from map to pixel
% Input jiUL (upperleft corner of the pixel), and x meters, and y meters, and
% resolution [x, y]
% output j cols, i rows
% i.e. [j,i]=lndmap2pixel(jiUL,x,y,resolu)
j=ceil((x-jiUL(1))/resolu(1));
i=ceil((jiUL(2)-y)/resolu(2));

end


