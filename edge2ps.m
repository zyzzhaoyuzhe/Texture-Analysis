% writes a postscript file with an edge map. 
% filename - filename of output *.ps
% probs    - probability of edges, should be zero for edges you don't want
% to display, preferably one or zero
% mysize   - size of patch for example [21 21 8]
% color    - (optional) vector of values to determine color.  

function [] = edge2ps(filename, probs, mysize, color)

temp = zeros([mysize, 5]);
temp(:,:,:,3) = reshape(probs, mysize);
color2 = zeros(size(probs));
color2(probs > 0) = color;
if nargin == 3
    cols2ps(filename, temp);
else
    colorcols2ps(filename, temp, color2)
end


