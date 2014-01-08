function output = structure(im,threshold)

%% Show structure of the texture 

SIGMA = 2;
PERIOD = 6;
SCALE = 1;
FILTERSIZE = 15;
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
validim = im;
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
% Orientation Suppression
% einitests_origin = orisuppression(einitests_origin);

output = sum(einitests_origin,3);



