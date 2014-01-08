function output = imagestackRead(filename_pre,texture,orientation)
%Output
if texture == 1
    folder = 'textureSamples/';
else
    folder = 'noiseSamples/';
end
% filename_pre = 'tex-320x320-im103';
for i = 1:100
    if orientation ~= 90
        filename = strcat(folder,filename_pre,'-smp',num2str(i),'.mat');
        load(filename);
        res_rotated = imrotate(res,orientation,'bilinear');
        L2 = size(res_rotated,1);
        L1 = size(res,1);
        if orientation > 90
            orientation = mod(orientation,90);
        end
        theta = orientation/180*pi;
        l = L1*sin(theta)/(1+tan(theta));
        xmin = l;
        ymin = l;
        width = L2-2*l;
        height = L2-2*l;
        im(:,:,i) = imcrop(res_rotated,[xmin,ymin,width,height]);
        clear res;
    else
        filename = strcat(folder,filename_pre,'-smp',num2str(i),'.mat');
        load(filename);
        res_rotated = res';
        res_rotated = fliplr(res_rotated);
        im(:,:,i) = res_rotated;
    end
end
output = im;
end