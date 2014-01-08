function [output] = computePatchRandomRotation(imagestack, maxnumpoints, threshold,dist)
%--------------BUILD FILTERS

SIGMA = 1.7;
PERIOD = 4;
SCALE = 1;
NUMRANDROTS = 5;
FILTERSIZE = 11;
NUMANGLE = 8;
PATCHSIZE = 31;

gratingbank = zeros(FILTERSIZE, FILTERSIZE, NUMANGLE);
gratingbank2 = zeros(FILTERSIZE, FILTERSIZE, NUMANGLE);
counter = 0;
for i=0:pi/NUMANGLE:(pi-pi/NUMANGLE)
    counter = counter + 1;
    gratingbank(:,:,counter) = buildgrating(-i+pi/2, PERIOD, 0, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .7);
    gratingbank2(:,:,counter) = buildgrating(-i+pi/2, PERIOD, pi/2, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .7);
    average = sum(sum(gratingbank2(:,:,counter)))/numel(gratingbank2(:,:,counter));
    gratingbank2(:,:,counter) = gratingbank2(:,:,counter)-average;
    magnitude = sum(sum(abs(gratingbank(:,:,counter))));
    magnitude2 = sum(sum(abs(gratingbank2(:,:,counter))));
    gratingbank(:,:,counter) = gratingbank(:,:,counter)/magnitude;
    gratingbank2(:,:,counter) = gratingbank2(:,:,counter)/magnitude2; 
end
clear counter

% gratingbank(:,:,5) = zeros(size(gratingbank(:,:,5)));
% gratingbank2(:,:,5) = zeros(size(gratingbank2(:,:,5)));


%--------------IMAGE CONVOLUTION
[imrows, imcols, numimages] = size(imagestack);
numpatper = floor(maxnumpoints/(numimages*NUMRANDROTS));
ori = RandOri(dist,numimages*NUMRANDROTS,1);
count = 0;
for i = 1:numimages
%     sprintf('On image %d', i)
    image = squeeze(imagestack(:,:,i));
    center = round(size(image)/2);
    flag = 0;
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
        
        % Calc. Edge Energy
        for j = 1:NUMANGLE
            im1 = conv2(validim, squeeze(gratingbank(:,:,j)), 'valid');
            im2 = conv2(validim, squeeze(gratingbank2(:,:,j)), 'valid');
            if j == 1
                einitests = zeros([size(im1), NUMANGLE]);
                einitests_origin = einitests;
            end
            temp = (im1.^2 + im2.^2).^.5;
            einitests(:,:,j) = temp > threshold;
            einitests_origin(:,:,j) = temp;
        end
        % Patch Candidates, Center edge is on
        clear temp;
        [nrows, ncols] = size(einitests(:,:,1));
        [rowidx, colidx] = ndgrid(1:nrows, 1:ncols);
        [row, col] = find(einitests(:,:,1) > 0 & rowidx > ((PATCHSIZE+1)/2*SCALE) & ...
            rowidx < nrows - (PATCHSIZE+1)/2*SCALE & colidx > ((PATCHSIZE+1)/2*SCALE) & ...
            colidx < ncols - (PATCHSIZE+1)/2*SCALE);
        idxlist = randperm(length(row));
        count2 = 0;
        % Random patch candidates; Local nonmax suppression; Check is patch
        % is real
        for idx = idxlist
            temp = einitests_origin((row(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (row(idx) + (PATCHSIZE-1)/2*SCALE), (col(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (col(idx) + (PATCHSIZE-1)/2*SCALE), :);
            temp = orisuppression(temp);
            % Non Maximum suppresion
            for j = 1:NUMANGLE
                temp(:,:,j) = nonmaxsuppression(temp(:,:,j),(j-1)/NUMANGLE*pi);
            end
            temp_origin = temp;
            temp = temp_origin > threshold;
            nr = size(temp,1);
            nc = size(temp,2);
            if temp(round((nr+1)/2),round((nc+1)/2),1) == 1
                count = count+1;
                count2 = count2+1;
                output(:,:,:,count) = temp;
            end
            if count2 >= numpatper
                break;
            end
        end
    end
end
if exist('output') == 0
    output = 0;
end
end


