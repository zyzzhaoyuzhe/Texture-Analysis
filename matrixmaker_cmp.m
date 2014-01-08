function [output1,output2] = matrixmaker_cmp(patch,prob,edgethr1,edgethr2)
N = size(patch,4);
probsort = sort(prob,'descend');
edgepick1 = prob > edgethr1;
edgepick2 = prob > edgethr2;
len1 = sum(edgepick1);
len2 = sum(edgepick2);
summation1 = zeros(len1,len1);
summation2 = zeros(len2,len2);

%key
index = edgepick2+0;
index(edgepick2 == 1 & edgepick1 == 1) = 1;
index(edgepick2 == 1 & edgepick1 == 0) = 2;
index(index == 0) = [];
index(index == 2) = 0;
[~,index] = sort(index,'descend');
for i = 1:N
    temp = patch(:,:,:,i);
    temp = squeeze(temp);
    vec = reshape(temp,[],1);
    vec_new1 = vec(edgepick1 == 1)+0;
    vec_new2 = vec(edgepick2 == 1)+0;
    summation1 = summation1+vec_new1*vec_new1';
    summation2 = summation2+vec_new2*vec_new2';
end
output1 = summation1/N;
output2 = summation2/N;
output2 = output2(index,index);
end
    