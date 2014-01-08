function output = orisuppression(patch)
% Orientation Suppression
% The input should have 8 Orientation
patchsize = size(patch,1);
[M,IX] = max(patch,[],3);
[Y,X] = meshgrid(1:patchsize,1:patchsize);
X = reshape(X,[],1);
Y = reshape(Y,[],1);
IX = reshape(IX,[],1);
IX = X+(Y-1)*patchsize+(IX-1)*patchsize*patchsize;
M = reshape(M,[],1);
output = zeros(size(patch));
output(IX) = M;

% [M,IX] = min(patch,[],3);
% IX = reshape(IX,[],1);
% IX = X+(Y-1)*patchsize+(IX-1)*patchsize*patchsize;
% M = reshape(M,[],1);
% output(IX) = M;