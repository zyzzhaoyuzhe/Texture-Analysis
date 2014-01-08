function output = matrixone(patch_source,edgepos,patch_target,prob,edgethr)
%% the 4th dimension of patch_source and patch_target should be the same
% "prob" and "edgethr" should be compatible with "patch_target"
if size(patch_source,4) ~= size(patch_target,4);
    error('the 4th dimension of patch_source and patch_target are not equal');
end
source = patch_source(edgepos(1),edgepos(2),edgepos(3),:);
source = squeeze(source);
N = size(patch_target,4);
edgepick = prob > edgethr;
len = sum(edgepick);
summation = zeros(1,len);
for i = 1:N
    temp = patch_target(:,:,:,i);
    temp = squeeze(temp);
    vec = reshape(temp,1,[]);
    vec_new = vec(edgepick == 1);
    clear vec;
    summation = summation + vec_new*source(i);
end
output = summation/N;
end

