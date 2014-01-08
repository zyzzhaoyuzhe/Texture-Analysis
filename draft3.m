ecompatfam = mkcompatfam('nks',1);
for i = 3:3
    %% Read edgemap
    load(strcat('G:\Matt\noiseEdge\',num2str(i),'_sparse.mat'));
    for k = 1:size(image_edgemap,1)
        temp = image_edgemap{k};
        temp = full(temp);
        len = size(temp,1);
        image_edgemap{k} = reshape(temp,[len,len,16]);
    end
    bw = waitbar(0,'processing');
    for j = 1:500
        waitbar(j/500,bw);
        temp = image_edgemap{j};
        image_edgemap{j} = relax(temp,ecompatfam,5,1,4,true);
    end
    close(bw);
    save(strcat('G:\Matt\noiseEdge\',num2str(i),'_relax.mat'),'image_edgemap','-v7.3');
end