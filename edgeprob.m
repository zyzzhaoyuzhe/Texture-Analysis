function output = edgeprob(patch)
N = size(patch,4);
len = size(patch,1)*size(patch,2)*size(patch,3);
sum = zeros(len,1);
for i = 1:N
    temp = patch(:,:,:,i);
    temp = squeeze(temp);
    vec = reshape(temp,[],1);
    sum = sum + vec;
end
output = sum/N;
end