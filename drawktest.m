function image = drawktest(type, theta, k, yoff, thickness, imsize, aameth)

if nargin > 6 && strcmpi(aameth, 'resize')
  k = k/10;
  thickness = thickness*10;
  imsize = imsize*10;
  yoff = yoff*10;
end

halfsize = floor(imsize/2);
if k > 0
  rad = 1/k;
  lower = rad - halfsize + yoff;
  upper = lower + 2*halfsize;
  [xs ys] = meshgrid(-halfsize:halfsize, lower:upper);
elseif k < 0
  rad = -1/k;
  lower = -rad - halfsize + yoff;
  upper = lower + 2*halfsize;
  [xs ys] = meshgrid(-halfsize:halfsize, lower:upper);
elseif k == 0
  rad = 0;
  xs = zeros(imsize + 1 - mod(imsize,2));
  ys = repmat( ...
    transpose(-halfsize + yoff:halfsize + yoff), ...
    1, imsize + 1 - mod(imsize, 2) ...
  );
end

offs = sqrt(xs.*xs + ys.*ys) - rad;

if k ~= 0
  inside = offs < 0;
else
  inside = ys < 0;
end

dists = abs(offs);
overlaps = thickness/2 - dists + .5;

if nargin > 6 && (strcmpi(aameth, 'resize') || strcmpi(aameth, 'none'))
  overlaps = overlaps > 0;
end

if strcmpi(type,'edge')
  image = bound(max(overlaps, inside),0,1);
  if k < 0
    image = 1 - image;
  end
else
  image = bound(overlaps, 0, 1);
end

if nargin > 6 && strcmpi(aameth,'resize')
  imsize = imsize/10;
  imsize = imsize + 1 - mod(imsize, 2);
  image = imresize(image, [imsize imsize]);
  image = bound(image, 0, 1);
  if max(image(:)) < 1
    image = image/max(image(:));
  end
end

image = imrotate(image, rad2deg(theta), 'bilinear', 'crop');