for i = 1:15
    image_texture = imagestackRead(filename_pre_texture{i},1,0);
    image_texture = ImageNormalize(image_texture);
    %% Get Orientation preference
    output = OrientationExam(image_texture,1);
    [~,IX] = sort(output);
    output(IX(1:45)) = 0;
    dist = output/sum(output);
    dist = cumsum(dist);
    clear output;
    %
    image_edgemap = LL(image_texture,dist);
    save(strcat('H:\Matt\textureEdge\',num2str(i),'.mat'),'image_edgemap','-v7.3');
end

for i = 3:15
    image_noise = imagestackRead(filename_pre_noise{i},0,0);
    image_noise = ImageNormalize(image_noise);
    %% Get Orientation preference
    output = OrientationExam(image_noise,1);
    [~,IX] = sort(output);
    output(IX(1:45)) = 0;
    dist = output/sum(output);
    dist = cumsum(dist);
    clear output;
    %
    image_edgemap = LL(image_noise,dist);
    save(strcat('G:\Matt\noiseEdge\',num2str(i),'.mat'),'image_edgemap','-v7.3');
end

%% Score Based on RRLL
embeddim = 60;
thr = 0.25;
numcluster = 3;
clear result_t
for i = 1:15
    
    %% Read edgemap
    load(strcat('G:\Matt\textureEdge\',num2str(i),'_sparse.mat'));
    for k = 1:size(image_edgemap,1)
        temp = image_edgemap{k};
        temp = full(temp);
        len = size(temp,1);
        image_edgemap{k} = reshape(temp,[len,len,16]);
    end
%     temp = image_edgemap{1};
%     cols2ps(strcat('texture',num2str(i),'.eps'), temp, 'Open', false);
%     cols2ps(strcat('texture',num2str(i),'_thr.eps'), temp>thr, 'Open', false);
    for j = 1:10
        patch = ComputePatchRRLL(image_edgemap,5000,thr);
        %% Calc. Edge Probabilities
        prob = edgeprob(patch);
        probsort = sort(prob,'descend');
        probthr = probsort(embeddim+1);
        edgepick = prob > probthr;
%         if j==1
%             edge2ps(strcat('texture',num2str(i),'_edge.eps'),prob>=0,[41,41,16],prob);
%         end
        
        %% Probability Matrix
        matrix = matrixmaker(patch,prob,probthr);
        %% Spectrum Embedding
        [output,eigenvector,eigenvalue] = computeThirdOrderEmbed(matrix);
        
        %% Clusting
%         [IDX,C] = ProbKmeans(output,numcluster);
        [IDX,L] = SLCluster(matrix,0.9);
        clear C;
        for k = 1:length(unique(IDX))
            [~,C(k)] = max(prob(edgepick).*(IDX == k));
        end
        %% Calc. Score
%         result_t(j,i) = CurveLenEx(output,IDX,C);
        result_t(j,i) = CurveScore(matrix,IDX,C);
    end
end

%% noise pattern
embeddim = 60;
thr = 0.5;
numcluster = 3;
clear result_n

list = 1:15;
list(3) = [];
wb = waitbar(0,'Ranking');
for i = 1:15
    waitbar(i/15,wb);
    %% Read edgemap
    load(strcat('G:\Matt\noiseEdge\',num2str(i),'_relax.mat'));
%     for k = 1:size(image_edgemap,1)
%         temp = image_edgemap{k};
%         temp = full(temp);
%         len = size(temp,1);
%         image_edgemap{k} = reshape(temp,[len,len,16]);
%     end
%     temp = image_edgemap{1};
%     cols2ps(strcat('noise',num2str(i),'.eps'), temp, 'Open', false);
%     cols2ps(strcat('noise',num2str(i),'_thr.eps'), temp>thr, 'Open', false);
    for j = 1:10
        patch = ComputePatchRRLL(image_edgemap,5000,thr);
        %% Calc. Edge Probabilities
        prob = edgeprob(patch);
        probsort = sort(prob,'descend');
        probthr = probsort(embeddim+1);
        edgepick = prob > probthr;
%         if j==1
%             edge2ps(strcat('noise',num2str(i),'_edge.eps'),prob>=0,[41,41,16],prob);
%         end
        
        %% Probability Matrix
        matrix = matrixmaker(patch,prob,probthr);
        %% Spectrum Embedding
%         [output,eigenvector,eigenvalue] = computeThirdOrderEmbed(matrix);
        
        %% Clusting
%         [IDX,C] = ProbKmeans(output,numcluster);
        [IDX,L] = SLCluster(matrix,0.9);
        clear C;
        for k = 1:length(unique(IDX))
            [~,C(k)] = max(prob(edgepick).*(IDX == k));
        end        
        %% Calc. Score
%         result_n(j,i) = CurveLenEx(output,IDX,C);
        result_t(j,i) = CurveScore(matrix,IDX,C);
    end
end
delete(wb);