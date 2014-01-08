function h = plotcols(columns, subset, color, maxlen, scalelens, ...
  width, threshold, image, a)

u = zeros(size(columns, 1), size(columns, 2), size(columns, 3));
v = zeros(size(columns, 1), size(columns, 2), size(columns, 3));

ndirs = size(columns, 3)/2;

for dir = 1 : size(columns, 3)
  u(:,:,dir) = (columns(:,:,dir) > threshold)*cos((dir - 1)*pi/ndirs);
  v(:,:,dir) = (columns(:,:,dir) > threshold)*sin((dir - 1)*pi/ndirs);
end

newplot;
h = gcf;

hold on;
grid on;
box on;
axis square;
axis off;
maxx = size(columns, 2);
maxy = size(columns, 1);
[x, y] = meshgrid(1 : maxx, maxy :-1: 1);
xlim([-.5 (maxx - .5)]);
ylim([-.5 (maxy - .5)]);
zlim([0 pi]);
if nargin > 7
  surf(0:maxx - 1, 0:maxy - 1, zeros(maxy,maxx), ...
    'CData',flipud(image),'FaceColor','texturemap','EdgeColor','None');
  colormap('gray');
  alpha(a);
end
ndirs = size(columns, 3);
for dir = subset
  rads = pi*(dir - 1)/ndirs;
  show = (u(:,:,dir).^2 + v(:,:,dir).^2) > 0;
  showx = transpose(nonzeros(x.*show));
  showy = transpose(nonzeros(y.*show));
  if scalelens
    vals = maxlen*transpose(nonzeros(columns(:,:,dir).*show))/2;
  else
    vals = zeros(size(showx)) + maxlen/2;
  end
  zs = zeros(size(showx)) + rads;
  c = (color ~= 0)*hsv2rgb([rads/(2*pi) 1 1]);
  line([showx - vals*cos(rads) - 1; showx + vals*cos(rads) - 1], ...
    [showy - vals*sin(rads) - 1; showy + vals*sin(rads) - 1], ...
    [zs; zs], ...
    'LineWidth', width, 'Color', c);
end
hold off;