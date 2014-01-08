function output = ComputePatchRRLL(image_edgemap, maxnumpoints, threshold)
%% Use Logical/Linear Operator as edge detector
SCALE = 1;
PATCHSIZE = 21;

%--------------IMAGE CONVOLUTION
numimages = size(image_edgemap,1);
numpatper = floor(maxnumpoints/(numimages));
count = 0;

completed = 0;
total = numimages;
% wbh = waitbar(completed/total, 'Calculating initial estimates...');
for i = 1:numimages
    einitests = image_edgemap{i};
    % Orientation Suppression
    einitests = orisuppression(einitests);
    einitests_origin = einitests;
    einitests = einitests > threshold;
    
    % Patch candidate
    [nrows, ncols] = size(einitests(:,:,1));
    [rowidx, colidx] = ndgrid(1:nrows, 1:ncols);
    [row, col] = find(einitests(:,:,1) > 0 & rowidx > ((PATCHSIZE+1)/2*SCALE) & ...
        rowidx < nrows - (PATCHSIZE+1)/2*SCALE & colidx > ((PATCHSIZE+1)/2*SCALE) & ...
        colidx < ncols - (PATCHSIZE+1)/2*SCALE);
    idxlist = randperm(length(row));
    count2 = 0;
    % Random patch candidates; Local nonmax suppression; Check is patch
    % is real
    for idx = idxlist
        temp = einitests_origin((row(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (row(idx) + (PATCHSIZE-1)/2*SCALE), (col(idx) - (PATCHSIZE-1)/2*SCALE) : SCALE : (col(idx) + (PATCHSIZE-1)/2*SCALE), :);
        NUMANGLE = size(einitests,3);
        % Non Maximum suppresion
        for j = 1:NUMANGLE
            temp(:,:,j) = nonmaxsuppression(temp(:,:,j),(j-1)/NUMANGLE*2*pi);
        end

        temp = temp > threshold;
        nr = size(temp,1);
        nc = size(temp,2);
        if temp(round((nr+1)/2),round((nc+1)/2),1) == 1
            count = count+1;
            count2 = count2+1;
            output(:,:,:,count) = temp;
        end
        if count2 >= numpatper
            break;
        end
    end
    completed = completed+1;
    %     waitbar(completed/total, wbh);
end
if exist('output') == 0
    output = 0;
end
% close(wbh);
end