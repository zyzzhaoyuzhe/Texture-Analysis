function displaycompats( ...
  compatfam, ti, ki, kjcls, normcs, tancs, len, width, threshold ...
)

p = compatfam.params;

newplot;
h = gcf;

set(h, 'Color', [.55 .55 .55]);

hold on;

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

  reductions{tji} = reductions{tji} + ops(opi).args.kern;
end

for diri = 1:p.ntotdirs
  kern = reductions{diri};
  dir = (diri - 1)*p.dirincs;
  [rs cs] = size(kern);
  [xs ys] = meshgrid(1:cs, rs:-1:1);
  pxs = transpose(nonzeros(xs.*(kern > threshold)));
  nxs = transpose(nonzeros(xs.*(-kern > threshold)));
  pys = transpose(nonzeros(ys.*(kern > threshold)));
  nys = transpose(nonzeros(ys.*(-kern > threshold)));
  dx = len*cos(dir)/2;
  dy = len*sin(dir)/2;
  line([pxs - dx; pxs + dx], [pys - dy; pys + dy], ...
       'LineWidth', width, 'Color', [.8 .8 .8]);
  line([nxs - dx; nxs + dx], [nys - dy; nys + dy], ...
       'LineWidth', width, 'Color', [.3 .3 .3]);
end

a = gca;
set(a, 'Visible', 'off');
axis image;
hold off;