function params = mkcols2psparams(varargin)

nargs = size(varargin, 2);

if mod(nargs, 2) ~= 0
  error('Each parameter type must have a corresponding value');
end

params = ...
  struct('open', false, ...
         'ndirs', 8, ...
         'kincs', 0.1, ...
         'len', 1.1, ...
         'kenhance', 10, ...
         'darken', 0.3, ...
         'thresh', 0.02, ...
         'linewidth', 0.2, ...
         'edgecolor', [0 0 0], ...
         'brightlinecolor', [1 1 0], ...
         'darklinecolor', [0 0 1]);

paramindx = 1;
while paramindx + 1 <= nargs
  switch lower(varargin{paramindx})
    case 'featuretype'
      varargin{paramindx} = 'type';
    case 'directions'
      varargin{paramindx} = 'ndirs';
    case 'curvatureincrements'
      varargin{paramindx} = 'kincs';
    case 'linelength'
      varargin{paramindx} = 'len';
    case 'curvatureenhancement'
      varargin{paramindx} = 'kenhance';
    case 'threshold'
      varargin{paramindx} = 'thresh';
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