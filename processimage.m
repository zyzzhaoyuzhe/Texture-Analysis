function [cols initcols] = processimage(image, initopfam, compatfam)

dorelax = ...
  nargin > 2 && (~islogical(compatfam) || (islogical(compatfam) && compatfam));

if ~dorelax && nargout > 1
  error('Only one output should be specified when relaxation is not run.');
end

if ischar(image)
  image = imload(image);
end

if ischar(initopfam)
  initopfam = mkinitopfam('FeatureType', initopfam);
elseif iscell(initopfam)
  initopfam = mkinitopfam(initopfam{:});
end

tic;
cols = convinitopfam(image, initopfam, 16, false);
elapsedtime = toc;

fprintf('Finished calculating initial estimates in %f seconds.\n', elapsedtime);

if dorelax
  initcols = cols;
  
  if ischar(compatfam)
    tic;
    compatfam = mkcompatfam('FeatureType', compatfam);
    elapsedtime = toc;
    
    fprintf('Finished creating compatibilities in %f seconds.\n', elapsedtime);
  elseif iscell(compatfam)
    tic;
    compatfam = mkinitopfam(compatfam{:});
    elapsedtime = toc;
    
    fprintf('Finished creating compatibilities in %f seconds.\n', elapsedtime);
  elseif islogical(compatfam)
    initopfamtype = initopfam.params.type;
    
    tic;
    compatfam = mkcompatfam('FeatureType', initopfamtype);
    elapsedtime = toc;
    
    fprintf('Finished creating compatibilities in %f seconds.\n', elapsedtime);
  end
  
  tic;
  cols = relax(initcols, compatfam, 5, 1, 4, true);
  elapsedtime = toc;
  
  fprintf('Finished relaxing in %f seconds.\n', elapsedtime);
end