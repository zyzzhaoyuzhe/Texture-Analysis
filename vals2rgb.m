function [rgbmat] = vals2rgb(valuelist,colormap)
numrows = size(colormap,1);
minval = min(valuelist);
maxval = max(valuelist);
valuelist = round((valuelist - minval)/(maxval-minval)*(numrows - 1)) + 1;
rgbmat = zeros(length(valuelist),3);
rgbmat(:,:) = colormap(valuelist,:);