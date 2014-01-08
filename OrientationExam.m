function output = OrientationExam(image,step)
% Check the orientation preference of the texture
imnum = size(image,3);

SIGMA = 2;
PERIOD = 4;
FILTERSIZE = 15;

grating1 = buildgrating(pi/2, PERIOD, 0, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .7);
grating2 = buildgrating(pi/2, PERIOD, pi/2, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .7);
average = sum(sum(grating2))/numel(grating2);
grating2 = grating2-average;
magnitude = sum(sum(abs(grating1)));
magnitude2 = sum(sum(abs(grating2)));
grating1 = grating1/magnitude;
grating2 = grating2/magnitude2; 

output = zeros(floor(90/step)+1,imnum);
ori = 0:step:180;
ori = mod(ori,90);

wbh = waitbar(0,'OrientationExam Processing');
for i = 1:imnum
    count = 0;
    for orientation = 0:step:90
        count = count + 1;
        image_rotated = imrotate(image(:,:,i),orientation,'bilinear');
        L2 = size(image_rotated,1);
        L1 = size(image,1);
        theta = ori(count)/180*pi;
        l = L1*sin(theta)/(1+tan(theta));
        xmin = l;
        ymin = l;
        width = L2-2*l;
        height = L2-2*l;
        validim = imcrop(image_rotated,[xmin,ymin,width,height]);
        im1 = conv2(validim, grating1, 'valid');
        im2 = conv2(validim, grating2, 'valid');
        temp = sqrt(im1.^2+im2.^2);
        output(count,i) = mean(mean(temp));
    end
    waitbar(i/imnum,wbh);
end
close(wbh);
output = mean(output,2);

    

