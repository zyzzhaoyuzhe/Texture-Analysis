function [output,output_origin] = computePatch(imagestack, maxnumpoints, threshold)
%--------------BUILD FILTERS
SIGMA = 2;
PERIOD = 4;
SCALE = 1;
NUMRANDROTS = 1;
FILTERSIZE = 15;
NUMANGLE = 8;
PATCHSIZE = 15;

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
validwidth = floor(.9*2^-.5 * min(imrows, imcols));
numpatper = floor(maxnumpoints/(numimages*NUMRANDROTS));
count = 0;
for i = 1:numimages
%     sprintf('On image %d', i)
    image = squeeze(imagestack(:,:,i));
    center = round(size(image)/2);
    for randrots = 1:NUMRANDROTS;
        % Random Rotation
%         validim = roirotate(image, [center(2) - round(validwidth/2), ...
%             center(1) - round(validwidth/2), ...
%             validwidth, validwidth], round(rand()*360), 'bilinear');
        validim = image;
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
        clear temp;
        %imagesc(sum(einitests, 3));
        %pause(.5);
        %imagesc(validim);
        [nrows, ncols] = size(einitests(:,:,1));
        [rowidx, colidx] = ndgrid(1:nrows, 1:ncols);
        [row, col] = find(einitests(:,:,1) > 0 & rowidx > ((PATCHSIZE+1)/2*SCALE) & ...
            rowidx < nrows - (PATCHSIZE+1)/2*SCALE & colidx > ((PATCHSIZE+1)/2*SCALE) & ...
            colidx < ncols - (PATCHSIZE+1)/2*SCALE);
        %if (length(row) < 100)
         %   sprintf('Skipped image %d, rotation %d', [i,randrots])
          %  continue;
        %end
        idxlist = randperm(length(row));
        count2 = 0;
        for idx = idxlist
            temp = einitests_origin((row(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (row(idx) + (PATCHSIZE-1)/2*SCALE), (col(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (col(idx) + (PATCHSIZE-1)/2*SCALE), :);
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
                output_origin(:,:,:,count) = temp_origin;
            end
            if count2 >= numpatper
                break;
            end
        end
        
    end
end
if exist('output') == 0
    output = 0;
    output_origin = 0;
end
end


