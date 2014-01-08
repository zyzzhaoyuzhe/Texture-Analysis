function cols2ps(filename, cols1, varargin)

if isempty(varargin)
  p = mkcols2psparams(varargin{:});
elseif ~ischar(varargin{1}) && ~isstruct(varargin{1})
  cols2 = varargin{1};
  
  if length(varargin) > 1 && isstruct(varargin{2})
    p = varargin{2};
  else
    p = mkcols2psparams(varargin{2:end});
  end
elseif isstruct(varargin{1})
  p = varargin{1};
else
  p = mkcols2psparams(varargin{:});
end

if ~isempty(cols1)
  p.maxx = size(cols1, 2);
  p.maxy = size(cols1, 1);
  p.nabsks = floor(size(cols1, 4)/2);
else
  p.maxx = size(cols2, 2);
  p.maxy = size(cols2, 1);
  p.nabsks = floor(size(cols2, 4)/2);
end

if ~exist('cols2', 'var')
  args = cols2args(cols1, 'proportional', p);
else
  args = [cols2args(cols1, 'edge', p); cols2args(cols2, 'line', p)];
end

args = sortrows(args);
args = args(:,2:end);

if isempty(regexp(filename, '\.eps$', 'once'))
  filename = [filename '.eps'];
end
file = fopen(filename, 'w');

linefmtstring = '%f %f %f setrgbcolor %f %f moveto %f %f lineto stroke\n';
circfmtstring = '%f %f %f setrgbcolor %f %f moveto %f %f %f %f %f arc stroke\n';

fprintf(file, '%%!PS-Adobe-3.0 EPSF-3.0\n');
fprintf(file, '%%%%BoundingBox: 1 1 %i %i\n', p.maxx + 1, p.maxy + 1);
fprintf(file, sprintf('%f setlinewidth\n', p.linewidth));
fprintf(file, '1 setlinecap\n');

nrows = size(args, 1);
for i = 1:nrows
  if sum(isnan(args(i,5:8))) > 0
    fprintf(file, linefmtstring, ...
            args(i,1), args(i,2), args(i,3), args(i,4), ...
            args(i,5), args(i,6), args(i,7));
  else
    fprintf(file, circfmtstring, ...
            args(i,1), args(i,2), args(i,3), args(i,4), ...
            args(i,5), args(i,6), args(i,7), args(i,8), ...
            args(i,9), args(i,10));
  end
end

fprintf(file, 'showpage\n');

fclose(file);

if islogical(p.open) && p.open
  system(['open "' filename '"']);
elseif ischar(p.open)
  system([p.open '"' filename '"']);
end

function args = cols2args(cols, intensitytype, p)

nks = size(cols, 4);
ncoldirs = size(cols, 3);

[xs, ys] = meshgrid(1:p.maxx, p.maxy:-1:1);

if isempty(cols)
  args = [];
  return;
else
  args = zeros(0, 11);
end

for kn = 1:nks
  k = p.kenhance*(kn - ceil(nks/2))*p.kincs*p.nabsks/2;
  phi = abs(p.len*k);

  for diri = 1:ncoldirs
    dir = pi*(diri - 1)/p.ndirs;
    visible = (cols(:,:,diri,kn) > p.thresh);
    nelems = length(nonzeros(visible));
    vals = bound(nonzeros(cols(:,:,diri,kn).*visible), 0, 1);
    
    x = nonzeros(xs.*visible) + p.len/2;
    y = nonzeros(ys.*visible) + p.len/2;
    cosdir = cos(dir);
    sindir = sin(dir);
    
    if strcmpi(intensitytype, 'proportional')
      colors = repmat((1 - vals.^(1 - p.darken)), 1, 3);
    elseif strcmpi(intensitytype, 'edge')
      colors = repmat(p.edgecolor, nelems, 1);
    elseif strcmpi(intensitytype, 'line')
      if diri > p.ndirs
        colors = repmat(p.darklinecolor, nelems, 1);
      else
        colors = repmat(p.brightlinecolor, nelems, 1);
      end
    else
      error(['Invalid intensity type: ' intensitytype '.']);
    end
    
    if kn == ceil(nks/2)
      args = ...
        [args;
         vals ...
         colors ...
         (x - p.len*cosdir/2) ...
         (y - p.len*sindir/2) ...
         (x + p.len*cosdir/2) ...
         (y + p.len*sindir/2) ...
         repmat(NaN, nelems, 3)]; %#ok<AGROW>
    else
      x0 = sin(-phi/2)/k;
      y0 = (1 - cos(-phi/2))/k;
      reldx = cosdir*x0 - sindir*y0;
      reldy = sindir*x0 + cosdir*y0;
      centerdx = -sindir/k;
      centerdy = cosdir/k;
      
      args = ...
        [args; 
         vals ...
         colors ...
         (x + reldx) ...
         (y + reldy) ...
         (x + centerdx) ...
         (y + centerdy) ...
         repmat(1/k, nelems, 1) ...
         repmat(rad2deg(-pi/2 - phi/2 + dir), nelems, 1) ...
         repmat(rad2deg(-pi/2 + phi/2 + dir), nelems, 1)]; %#ok<AGROW>
    end
  end
end