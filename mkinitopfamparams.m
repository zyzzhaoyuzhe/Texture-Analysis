function params = mkinitopfamparams(varargin)

nargs = size(varargin, 2);

if mod(nargs, 2) ~= 0
  error('Each parameter type must have a corresponding value');
end

typeparam = 'edge';
for i = 1:nargs
  if strcmpi(varargin{i}, 'featuretype') || strcmpi(varargin{i}, 'type')
    typeparam = varargin{i + 1};
  end
end

params = ...
  struct('type', typeparam, ...
         'ndirs', 8, ...
         'nks', 5, ...
         'tancomb', 'simple', ...
         'sts', [2.8 0; 2.4 3.2; 1.67 2.3], ...
         'ntancs', [4 0; 4 4; 2 4], ...
         'degrees', 2, ...
         'stabs', [0.2 0], ...
         'sns', sqrt(2), ...
         'seps', sqrt(2)/2);

if strcmpi(typeparam, 'edge')
  params.scls = [1.5 0; 1.6 3; 1.75 3.5];
elseif strcmpi(typeparam, 'line')
  params.scls = [1.1 0; 1.2 2.2; 1.3 2.8];
end

scale = 1;

paramindx = 1;
while paramindx + 1 <= nargs
  switch lower(varargin{paramindx})
    case 'featuretype'
      varargin{paramindx} = 'type';
    case 'directions'
      varargin{paramindx} = 'ndirs';
    case 'tangentialcombination'
      varargin{paramindx} = 'tancomb';
    case 'tangentialsigmas'
      varargin{paramindx} = 'sts';
    case 'tangentialcomponents'
      varargin{paramindx} = 'ntancs';
    case 'stabilizers'
      varargin{paramindx} = 'stabs';
    case 'normalsigmas'
      varargin{paramindx} = 'sns';
    case 'offsets'
      varargin{paramindx} = 'seps';
    case 'curvatureclasses'
      varargin{paramindx} = 'nks';
    otherwise
      varargin{paramindx} = lower(varargin{paramindx});
  end

  if isfield(params, varargin{paramindx})
    params.(varargin{paramindx}) = varargin{paramindx + 1};
    if strcmpi(varargin{paramindx}, 'sts')
      params.nks = length(params.sts)*2 - 1;
    end
  elseif strcmp(varargin{paramindx}, 'scale') || ...
         strcmp(varargin{paramindx}, 'scl')
    scale = varargin{paramindx + 1};
  else    
    error(['Unrecognized parameter type: ' varargin{paramindx}]);
  end
  
  paramindx = paramindx + 2;
end

params.sts = params.sts*scale;
params.sns = params.sns*scale;
params.seps = params.seps*scale;

params.dirincs = pi/params.ndirs;
params.nabsks = min(length(params.sts), ceil(params.nks/2));
      