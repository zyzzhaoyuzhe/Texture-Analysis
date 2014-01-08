function imageout = NIshow(idx)
figure;
nargoutchk(0,1);
pre = 'G:\VanHateren\vanhateren_imc\imk';
filename = pre;
num = floor(log10(idx)+1);
while num<5
    filename = strcat(filename,'0');
    num = num+1;
end 
filename = strcat(filename,num2str(idx),'.imc');
f1 = fopen(filename, 'rb', 'ieee-be');
w = 1536; h = 1024;
buf = fread(f1, [w, h], 'uint16');
image = buf';
image = ImageNormalize(image);
image = imresize(image,0.6);
imshow(image);
if nargout == 1
    imageout = image;
end