function params = mkcompatfamparams(varargin)

nargs = size(varargin, 2);

if mod(nargs, 2) ~= 0
  error('Each parameter type must have a corresponding value');
end

params = ...
  struct('type', 'edge', ...
         'ksize', 19, ...
         'ndirs', 8, ...
         'nks', 5, ...
         'kincs', 0.1, ...
         'ntancs', 4, ...
         'stab', 0.55, ...
         'stabtype', 'combination', ...
         'degree', 2, ...
         'sxy', sqrt(2)/2, ...
         'sth', sqrt(2)/2, ...
         'sk', 0.75, ...
         'str', 3, ...
         'dilation', 0.1, ...
         'sep', sqrt(2)/2);

paramindx = 1;
while paramindx + 1 <= nargs
  switch lower(varargin{paramindx})
    case 'featuretype'
      varargin{paramindx} = 'type';
    case 'kernelsize'
      varargin{paramindx} = 'ksize';
    case 'directions'
      varargin{paramindx} = 'ndirs';
    case 'curvatureclasses'
      varargin{paramindx} = 'nks';
    case 'curvatureincrements'
      varargin{paramindx} = 'kincs';
    case 'tangentialcomponents'
      varargin{paramindx} = 'ntancs';
    case 'stabilizer'
      varargin{paramindx} = 'stab';
    case 'stabilizertype'
      varargin{paramindx} = 'stabtype';
    case 'normalsigma'
      varargin{paramindx} = 'sxy';
    case 'thetasigma'
      varargin{paramindx} = 'sth';
    case 'curvaturesigma'
      varargin{paramindx} = 'sk';
    case 'transportsigma'
      varargin{paramindx} = 'str';
    case 'offset'
      varargin{paramindx} = 'sep';
    otherwise
      varargin{paramindx} = lower(varargin{paramindx});
  end

  if isfield(params, varargin{paramindx})
    params.(varargin{paramindx}) = varargin{paramindx + 1};
  else
    error(['Unrecognized parameter type: ' varargin{paramindx}]);
  end
  
  paramindx = paramindx + 2;
end

params.ksize = params.ksize + (mod(params.ksize, 2) == 0);
params.dirincs = pi/params.ndirs;
params.npis = strcmpi(params.type, 'line') + 2*strcmpi(params.type, 'edge');
params.ntotdirs = params.npis*params.ndirs;
params.nabsks = ceil(params.nks/2);
params.nnormcs = 4 + 2*(params.nks > 1);
      