function output = ImageNormalize(imagestack)
output = imagestack;
for i = 1:size(imagestack,3)
    temp = imagestack(:,:,i);
    temp = temp-min(min(temp));
    temp = temp/max(max(temp));
    output(:,:,i) = temp;
end