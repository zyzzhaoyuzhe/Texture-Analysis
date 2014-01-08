function NIedge(idx,thr)
narginchk(1,2)
if nargin == 1
    thr = 0;
end
pre = 'G:\VanHateren\matlab\';
filename = strcat(pre,num2str(idx),'_sparse.mat');
load(filename);
for k = 1:size(image_edgemap,1)
    temp = image_edgemap{k};
    temp = full(temp);
    len = size(temp,1);
    image_edgemap{k} = reshape(temp,[len,len,16]);
end
if nargin == 1
    cols2ps('test1.eps',image_edgemap{1},'Open',false);
else
    cols2ps('test1.eps',image_edgemap{1}>thr,'Open',false);
end