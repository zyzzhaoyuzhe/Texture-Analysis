function compat2ps( ...
  filename, openafter, compatfam, ti, ki, kjcls, ...
  normcs, tancs, len, threshold, color ...
)

p = compatfam.params;
ops = compatfam.kin(ti,ki).ops;
nops = length(ops);

reductions = cell(p.ntotdirs);

for diri = 1:p.ntotdirs
  reductions{diri} = 0;
end

for opi = 1:nops
  if ~strcmpi(ops(opi).type, 'conv')
    continue;
  end
  
  tji = ops(opi).args.target.tji;
  kji = ops(opi).args.target.kji;
  tani = ops(opi).info.tani;
  normi = ops(opi).info.normi;
  
  if isempty(find(normcs == normi, 1)) || ...
     isempty(find(tancs == tani, 1)) || ...
     isempty(find(kjcls == kji, 1))
    continue;
  end

  kern = ops(opi).args.kern;
  reductions{tji} = reductions{tji} + kern.*(kern >= 0);
end

args = [];
maxval = -inf;
width = size(reductions{1}, 2);
height = size(reductions{1}, 1);

for diri = 1:p.ntotdirs
  kern = reductions{diri};
  dir = (diri - 1)*p.dirincs;
  [rs cs] = size(kern);
  [xs ys] = meshgrid(1:cs, rs:-1:1);
  selected = kern > threshold;
  if ~any(selected(:))
      continue;
  end
  vals = kern(selected);
  maxval = max(maxval, max(abs(vals)));
  pxs = xs(selected);
  pys = ys(selected);
  dx = len*cos(dir)/2;
  dy = len*sin(dir)/2;
  args = [args; (vals) (pxs - dx) (pys - dy) (pxs + dx) (pys + dy) ...
    NaN(size(vals, 1), 3)]; %#ok<AGROW>
end

args(:,1) = (args(:,1) - threshold)/(maxval - threshold);
args = sortrows(args);

if isempty(regexp(filename, '\.eps$', 'once'))
  filename = [filename '.eps'];
end
file = fopen(filename, 'w');

fprintf(file, '%%!PS-Adobe-3.0 EPSF-3.0\n');
fprintf(file, '%%%%BoundingBox: 0 0 %i %i\n', (width + 1), (height + 1));
fprintf(file, '%f setlinewidth\n', 0.2);
fprintf(file, '1 setlinecap\n');
% fprintf(file, ...
%         ['.50 setgray 0 0 moveto 0 %i rlineto %i 0 ' ...
%          ' rlineto 0 %i rlineto %i 0 rlineto fill\n'], ...
%         height + 1, width + 1, -height - 2, -width - 2);

nrows = size(args, 1);
for i = 1:nrows
  if sum(isnan(args(i,5:8))) > 0
    rgb = color*args(i,1) + (1 - args(i,1))*[1 1 1];
    fprintf(file, '%f %f %f setrgbcolor %f %f moveto %f %f lineto stroke\n', ...
            rgb, args(i,2), args(i,3), args(i,4), args(i,5));
  else
    fprintf(file, '%f setgray %f %f moveto %f %f %f %f %f arc stroke\n', ...
            args(i,1), args(i,2), args(i,3), args(i,4), ...
            args(i,5), args(i,6), args(i,7), args(i,8));
  end
end

fclose(file);

if openafter
  system(['open ' filename]);
end