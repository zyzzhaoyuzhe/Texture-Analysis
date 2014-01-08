function compatfam = mkcompatfam(varargin)

if isempty(varargin) || ~isstruct(varargin{1})
  p = mkcompatfamparams(varargin{:});
else
  p = varargin{1};
end

xi = floor(p.ksize/2);
yi = floor(p.ksize/2);
[xjs, yjs] = meshgrid(0:p.ksize - 1, p.ksize - 1:-1:0);

kin = repmat(struct('ops', []), [p.ntotdirs p.nks]);

total = p.ntotdirs*p.nks;
completed = 0;
wbh = waitbar(completed/total, 'Creating compatibilities...');

for tii = 1:p.ntotdirs
  ti = (tii - 1)*p.dirincs;

  kiis = repmat(struct('ops', []), [1 p.nks]);
  for kii = 1:p.nks
    ki = (kii - p.nabsks)*p.kincs;
    
    compat = mkcompat(xi, yi, ti, ki, xjs, yjs, p);
    kiis(kii) = mkcompatopset(compat, p);
    
    completed = completed + 1;
    waitbar(completed/total, wbh);
  end
  
  kin(tii,:) = kiis;
end

compatfam = struct('params', p, 'kin', kin);

close(wbh);