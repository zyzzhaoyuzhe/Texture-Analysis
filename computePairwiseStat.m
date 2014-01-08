function [result, numones] = computePairwiseStat(imagestack, maxnumpoints, threshold)

%--------------BUILD FILTERS
SIGMA = 1;
SCALE = SIGMA;
NUMRANDROTS = 8;
FILTERSIZE = 5;

result = zeros(11, 11, 8);
numones = 0;

gratingbank = zeros(FILTERSIZE, FILTERSIZE, 8);
gratingbank2 = zeros(FILTERSIZE, FILTERSIZE, 8);
counter = 0;
for i=0:pi/8:(pi-pi/8)
    counter = counter + 1;
    gratingbank(:,:,counter) = buildgrating(-i+pi/2, 2*SIGMA, 0, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .5);
    gratingbank2(:,:,counter) = buildgrating(-i+pi/2, 2*SIGMA, pi/2, SIGMA, (FILTERSIZE - 1)/2, (FILTERSIZE - 1)/2, .5);
    average = sum(sum(gratingbank2(:,:,counter)))/numel(gratingbank2(:,:,counter));
    gratingbank2(:,:,counter) = gratingbank2(:,:,counter)-average;
    magnitude = sum(sum(abs(gratingbank(:,:,counter))));
    magnitude2 = sum(sum(abs(gratingbank2(:,:,counter))));
    gratingbank(:,:,counter) = gratingbank(:,:,counter)/magnitude;
    gratingbank2(:,:,counter) = gratingbank2(:,:,counter)/magnitude2; 
end

%--------------IMAGE CONVOLUTION
[imrows, imcols, numimages] = size(imagestack);
validwidth = floor(.9*2^-.5 * min(imrows, imcols));
numpatper = floor(maxnumpoints/(numimages*NUMRANDROTS));
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
        for j = 1:8
            im1 = conv2(validim, squeeze(gratingbank(:,:,j)), 'valid');
            im2 = conv2(validim, squeeze(gratingbank2(:,:,j)), 'valid');
            if j == 1
                einitests = zeros([size(im1), 8]);
            end
            temp = (im1.^2 + im2.^2).^.5;
            einitests(:,:,j) = (im1.^2 + im2.^2).^.5 > threshold;
        end
        %imagesc(sum(einitests, 3));
        %pause(.5);
        %imagesc(validim);
        [nrows, ncols] = size(einitests(:,:,1));
        [rowidx, colidx] = ndgrid(1:nrows, 1:ncols);
        [row, col] = find(einitests(:,:,1) > 0 & rowidx > 6*SCALE & ...
            rowidx < nrows - 6*SCALE & colidx > 6*SCALE & ...
            colidx < ncols - 6*SCALE);
        %if (length(row) < 100)
         %   sprintf('Skipped image %d, rotation %d', [i,randrots])
          %  continue;
        %end
        idxlist = randperm(min(numpatper, length(row)));
        for idx = idxlist
            result = result + einitests((row(idx) - 5*SCALE) : SCALE : (row(idx) + 5*SCALE), ...
                (col(idx) - 5*SCALE) : SCALE : (col(idx) + 5*SCALE), :);
            numones = numones + sum(sum(sum(einitests((row(idx) - 5*SCALE) : SCALE : (row(idx) + 5*SCALE), ...
                (col(idx) - 5*SCALE) : SCALE : (col(idx) + 5*SCALE), :)))) - 1;
        end
    end
end
end


