function relaxed = relax(initests, compatfam, iters, delta, degree, adapt)

relaxed = bound(initests, 0, 1);

ndirs = compatfam.params.ndirs;
kin = compatfam.kin;

[nimrows nimcols ntotdirs nks] = size(initests);
dodual = (ntotdirs == 2*ndirs) && ~strcmpi(compatfam.params.type, 'edge');

nsupdirs = ndirs + ~dodual*ndirs;

primsupport = zeros(nimrows, nimcols, nsupdirs, nks);

if dodual
  dualsupport = zeros(nimrows, nimcols, ndirs, nks);
end

total = iters*nsupdirs*nks;
completed = 0;
% wbh = waitbar(completed/total, 'Relaxing...');

for iter = 1:iters
  for tii = 1:nsupdirs
    primkisupport = zeros(nimrows, nimcols, nks);
    dualkisupport = zeros(nimrows, nimcols, nks);
    
    for kii = 1:nks
      if dodual
        [primkisupport(:,:,kii) dualkisupport(:,:,kii)] = ...
          execopset(relaxed, kin(tii,kii), degree, adapt);
      else
        primkisupport(:,:,kii) = ...
          execopset(relaxed, kin(tii,kii), degree, adapt);
      end
      
      completed = completed + 1;
%       waitbar(completed/total, wbh);
    end
    
    primsupport(:,:,tii,:) = primkisupport;
    
    if dodual
      dualsupport(:,:,tii,:) = dualkisupport;
    end
  end
  
  if dodual
    support = cat(3, primsupport, dualsupport);
  else
    support = primsupport;
  end
  
  relaxed = bound(relaxed + delta*support, 0, 1);
end

% close(wbh);
