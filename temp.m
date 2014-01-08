function temp(filename_pre)
%Output
folder = 'textureSamples\';
% filename_pre = 'tex-320x320-im103';
for i = 1:100
    filename = strcat(folder,filename_pre,'-smp',num2str(i),'.mat');
    load(filename);
    im(:,:,i) = res;
    clear res;
end
[result,numones] = computePairwiseStat(im,1000000,0.4);
subplot(3,3,1);
imshow(im(:,:,1));
for i = 1:8
    subplot(3,3,i+1);
    imagesc(result(:,:,i));
    colorbar
    axis image;
    colormap gray;
    title(num2str(i));
end
set(gcf,'outerposition',[100,0,1200,800]);
picname = strcat('0719\',filename_pre,'.jpg');
saveas(gcf,picname);
close gcf
end