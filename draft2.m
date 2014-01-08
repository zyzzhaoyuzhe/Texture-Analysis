clear result_t;
clear result_n;
orientation = 0;
for j = 1:5
    tic
    thr = 0.6;
    probthr = 0.2;
    numcluster = 3;
    clear result_texture;
    for i = 1:15
        image_texture = imagestackRead(filename_pre_texture{i},1,orientation);
        [patch,patchorigin] = computePatch(image_texture,1000,thr);
        prob = edgeprob(patch);
        matrix = matrixmaker(patch,prob,probthr);
        [output,eigenvector,eigenvalue] = computeThirdOrderEmbed(matrix);
        edgepick = prob > probthr;
        [IDX,C] = ProbKmeans(output,numcluster);
        result_texture(i) = CurveLenEx(output,IDX,C);
    end
    result_t(j,:) = result_texture;
    % noise
    thr = 0.3;
    probthr = 0.01;
    numcluster = 3;
    clear result_noise;
    for i = 1:15
        image_noise = imagestackRead(filename_pre_noise{i},0,orientation);
        [patch,patchorigin] = computePatch(image_noise,1000,thr);
        prob = edgeprob(patch);
        matrix = matrixmaker(patch,prob,probthr);
        [output,eigenvector,eigenvalue] = computeThirdOrderEmbed(matrix);
        edgepick = prob > probthr;
        [IDX,C] = ProbKmeans(output,numcluster);
        result_noise(i) = CurveLenEx(output,IDX,C);
    end
    result_n(j,:) = result_noise;
    toc
end

result_texture = mean(result_t,1);
result_noise = mean(result_n,1);
result = (result_texture-result_noise)./(result_texture+result_noise);



%% show texture result
result_texture = mean(result_t,1);
[B,IX] = sort(result_texture,'descend');
figure;
for i = 1:15
    image_texture = imagestackRead(filename_pre_texture{IX(i)},1,0);
    image_texture = ImageNormalize(image_texture);
    subplot(2,8,i);
    imshow(image_texture(:,:,1));
    title(strcat(num2str(B(i)),10,num2str(IX(i))));
end

%% show noise result
result_noise = mean(result_n,1);
[B,IX] = sort(result_noise,'descend');
figure;
for i = 1:15
    image_noise = imagestackRead(filename_pre_noise{IX(i)},0,0);
    image_noise = ImageNormalize(image_noise);
    subplot(2,8,i);
    imshow(image_noise(:,:,1));
    title(strcat(num2str(B(i)),10,num2str(IX(i))));
end


%% Modulation
ratio = 1;
% Make result_modulation
size_t = size(result_t,1);
size_n = size(result_n,1);

temp_t = repmat(result_t,size_n,1);
temp_n = repmat(result_n,size_t,1);
temp_n = sort(temp_n,1);

result_modulation = (temp_t-ratio*temp_n)./(temp_t+ratio*temp_n);

paperorder = 1:15;
[index,order] = sort(paperorder);
result = mean(result_modulation,1);
% result_texture./result_noise;
%(result_texture-result_noise)./(result_texture+result_noise);
[B,IX] = sort(result,'descend');
% ttest
for i = 1:14
    [h,result_ttest(i)] = ttest2(result_modulation(:,IX(i)),result_modulation(:,IX(i+1)));
end

figure;
for i = 1:15
    image_texture = imagestackRead(filename_pre_texture{IX(i)},1,0);
    image_texture = ImageNormalize(image_texture);
    subplot(2,15,i);
    imshow(image_texture(:,:,1));
    title(strcat(num2str(B(i)),10,num2str(IX(i))));
    image_noise = imagestackRead(filename_pre_noise{IX(i)},0,0);
    image_noise = ImageNormalize(image_noise);
    subplot(2,15,i+15);
    imshow(image_noise(:,:,1));
    if i < 15
        title(strcat(num2str(-i+order(IX(i))),'(',num2str(result_ttest(i),'%.2f'),')'));
    else
        title(strcat(num2str(-i+order(IX(i)))));
    end
end

%% Ranking Uncertainty
figure;
hold on;
for i = 1:15
    plot(result_modulation(:,IX(i)),(15-i+1)*ones(size(result_modulation(:,IX(i)))),'.');
end
hold off;





    