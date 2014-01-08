function output = LL(imagestack,dist)
%% Generate edge map after Random rotation
NUMRANDROTS = 5;
NUMANGLE = 16;

%--------------IMAGE CONVOLUTION
[~, ~, numimages] = size(imagestack);
ori = RandOri(dist,numimages*NUMRANDROTS,1);
% LL operator family
einitopfam = mkinitopfam('nks',1);

completed = 0;
total = numimages;
wbh = waitbar(completed/total, 'Calculating initial estimates...');
output = cell(numimages*NUMRANDROTS,1);
count = 0;
for i = 1:numimages
    image = squeeze(imagestack(:,:,i));
    for randrots = 1:NUMRANDROTS;
        % Random Rotation
        orientation = ori(i*randrots);
        image_rotated = imrotate(image,orientation,'bilinear');
        L2 = size(image_rotated,1);
        L1 = size(image,1);
        if orientation > 90
            orientation = mod(orientation,90);
        end
        theta = orientation/180*pi;
        l = L1*sin(theta)/(1+tan(theta));
        xmin = l;
        ymin = l;
        width = L2-2*l;
        height = L2-2*l;
        validim = imcrop(image_rotated,[xmin,ymin,width,height]);
        
        % LL Operator
        count = count+1;
        einitests = convinitopfam(validim, einitopfam, NUMANGLE, false);
        output{count} = einitests;
    end
    completed = completed+1;
    waitbar(completed/total, wbh);
end
close(wbh);