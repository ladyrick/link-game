function [pics,biash, biasw, pich, picw] = recognizePics()
mainscreen = rgb2gray(imread('test.png'));
%imshow(mainscreen);
addpath('tools');

[height, width] = size(mainscreen);
reduce_height = mean(mainscreen,1)';
reduce_height = reduce_height-mean(reduce_height);

[t,omg,FT,IFT] = prefourier([0,width-1],width,[0,pi],1000);
fh = FT*reduce_height;
figure;plot(omg,abs(fh));
[~,index] = max(abs(fh));
picw = 2*pi/omg(index);
if angle(fh(index))<0
    biasw = picw/(2*pi)*(-angle(fh(index)));
else
    biasw = picw/(2*pi)*(2*pi-angle(fh(index)));
end



reduce_width = mean(mainscreen,2);



t = biasw;
while(round(t) < width)
mainscreen(:,round(t))=0;
t = t + picw;
end
imshow(mainscreen)

end
