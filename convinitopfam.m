function initests = convinitopfam(image, family, degree, adapt)

if ~exist('degree', 'var')
    degree = 16;
end

if ~exist('adapt', 'var')
    adapt = false;
end

[nimrows nimcols] = size(image);

kin = family.kin;
[ndirs nabsks] = size(kin);
nks = nabsks*2 - 1;
ck = ceil(nks/2);

prims = zeros(nimrows, nimcols, ndirs, nks);
duals = zeros(nimrows, nimcols, ndirs, nks);

total = ndirs*nabsks;
completed = 0;
% wbh = waitbar(completed/total, 'Calculating initial estimates...');

for diri = 1:ndirs;
  localprims = zeros(nimrows, nimcols, nks);
  localduals = zeros(nimrows, nimcols, nks);
  localkin = kin(diri,:);
  
  for abski = 1:nabsks
    if abski == 1
      [localprims(:,:,ck) localduals(:,:,ck)] = ...
        execopset(image, localkin(1).exc, degree, adapt);
    else
      [excprim excdual] = ...
        execopset(image, localkin(abski).exc, degree, adapt);
      [poskinhprim poskinhdual] = ...
        execopset(image, localkin(abski).poskinh, degree, adapt);
      [negkinhprim negkinhdual] = ...
        execopset(image, localkin(abski).negkinh, degree, adapt);
      localprims(:,:,ck + abski - 1) = ...
        halfrect(excprim) - halfrect(poskinhprim);
      localduals(:,:,ck - abski + 1) = ...
        halfrect(excdual) - halfrect(poskinhdual);
      localprims(:,:,ck - abski + 1) = ...
        halfrect(excprim) - halfrect(negkinhprim);
      localduals(:,:,ck + abski - 1) = ...
        halfrect(excdual) - halfrect(negkinhdual);
    end
  
    completed = completed + 1;
%     waitbar(completed/total, wbh);
  end
  
  prims(:,:,diri,:) = localprims;
  duals(:,:,diri,:) = localduals;
end

initests = cat(3, prims, duals);

% close(wbh);