function cols = readlab(filename)

fid = fopen(filename);
w = fread(fid, 1, 'int16');
h = fread(fid, 1, 'int16');
ndirs = fread(fid, 1, 'int8');
nks = fread(fid, 1, 'int8');

cols = zeros(h, w, ndirs, nks);
for diri = 1:ndirs
  for ki = 1:nks
    cols(:,:,mod(1 - diri, ndirs) + 1,nks + 1 - ki) = ...
      reshape(fread(fid, w*h, 'int16'), [w h])'/255;
  end
end