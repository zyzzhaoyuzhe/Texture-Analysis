function output = RandOri(dist,nrow,ncol)
% Generate random orientation according to the distribution between 0~90
len = length(dist);
num = nrow*ncol;
dist = dist(:);
dist = repmat(dist,1,num);
dist = dist-repmat(rand(1,num),len,1);
dist = abs(dist);
[~,I] = min(dist,[],1);
output = I;
end