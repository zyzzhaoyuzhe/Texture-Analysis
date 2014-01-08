pre = 'G:\VanHateren\vanhateren_imc\imk';

einitopfam = mkinitopfam('nks',1);
for i = 257:500
    num = floor(log10(i)+1);
    filename = pre;
    while num<5
        filename = strcat(filename,'0');
        num = num+1;
    end 
    filename = strcat(filename,num2str(i),'.imc');
    f1 = fopen(filename, 'rb', 'ieee-be');
    w = 1536; h = 1024;
    buf = fread(f1, [w, h], 'uint16');
    image = buf';
    image = ImageNormalize(image);
    image = imresize(image,0.6);
    [nrow,ncol] = size(image);
    len = min(nrow,ncol);
    image=image((floor(nrow/2)-floor(len/2)+1):(floor(nrow/2)+floor(len/2)-1),(floor(ncol/2)-floor(len/2)+1):(floor(ncol/2)+floor(len/2)-1));
    image_edgemap = cell(4,1);
    for j = 1:4
        orientation = (j-1)*45;
        image_rotated = imrotate(image,orientation,'bilinear');
        L2 = size(image_rotated,1);
        L1 = size(image,1);
        if orientation > 90
            orientation = mod(orientation,90);
        end
        theta = orientation/180*pi;
        l = L1*sin(theta)/(1+tan(theta));
        xmin = l;
        ymin = l;
        width = L2-2*l;
        height = L2-2*l;
        validim = imcrop(image_rotated,[xmin,ymin,width,height]);
        einitests = convinitopfam(validim, einitopfam, 16, false);
        
        % orisuppression
        einitests = orisuppression(einitests);
        % Spars
        len = size(einitests,1);
        einitests = reshape(einitests,len,[]);
        einitests = sparse(einitests);
        image_edgemap{j} = einitests;
    end
    save(strcat('G:\VanHateren\matlab\',num2str(i),'_sparse.mat'),'image_edgemap','-v7.3');
end

%% reading sparse files
thr = 0.1;
numcluster = 3;
pre = 'G:\VanHateren\matlab\';
N = 5;
patch_temp = cell(N,1);
for j = 1:N
    TT = cell(400,1);
    for i = 1+(j-1)*100:j*100
        filename = strcat(pre,num2str(i),'_sparse.mat');
        load(filename);
        for k = 1:size(image_edgemap,1)
            temp = image_edgemap{k};
            temp = full(temp);
            len = size(temp,1);
            image_edgemap{k} = reshape(temp,[len,len,16]);
        end
        idx = i-(j-1)*100;
        TT(((idx-1)*4+1):(idx*4)) = image_edgemap;
    end
    image_edgemap = TT;
    clear TT;
    patch_temp{j} = ComputePatchRRLL(image_edgemap,5000,thr);
    clear image_edgemap
end

clear patch
patch = patch_temp{1};
for j = 2:N
    patch(:,:,:,end+1:end+size(patch_temp{j},4)) = patch_temp{j};
end

    
%% cal. patch
embeddim = 200;
prob = edgeprob(patch);
probsort = sort(prob,'descend');
probthr = probsort(embeddim+1);
edgepick = prob > probthr;
matrix = matrixmaker(patch,prob,probthr);
%% Spectrum Embedding
[output,eigenvector,eigenvalue] = computeThirdOrderEmbed(matrix);