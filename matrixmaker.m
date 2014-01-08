function output = matrixmaker(patch,prob,edgethr)
N = size(patch,4);
edgepick = prob > edgethr;
len = sum(edgepick);
summation = zeros(len,len);
for i = 1:N
    temp = patch(:,:,:,i);
    temp = squeeze(temp);
    vec = reshape(temp,[],1);
    vec_new = vec(edgepick == 1)+0;
    summation = summation+vec_new*vec_new';
end
output = summation/N;
end
    