function fam = mkinitopfam(varargin)

if isempty(varargin) || ~isstruct(varargin{1})
  p = mkinitopfamparams(varargin{:});
else
  p = varargin{1};
end

inhdegi = length(p.degrees);
inhstabi = length(p.stabs);
inhsni = length(p.sns);
inhsepi = length(p.seps);

if strcmpi(p.type, 'edge')
  excbns = mkedgebasiscx(p.sns(1), p.seps(1));
  
  if p.nabsks > 1
    poskinhbns = mkinhedgebasiscx(p.sns(inhsni), p.seps(inhsepi), 1);
    negkinhbns = mkinhedgebasiscx(p.sns(inhsni), p.seps(inhsepi), -1);
  end
else
  excbns = mklinebasiscx(p.sns(1), p.seps(1));
  
  if p.nabsks > 1
    poskinhbns = mkinhlinebasiscx(p.sns(inhsni), p.seps(inhsepi), 1);
    negkinhbns = mkinhlinebasiscx(p.sns(inhsni), p.seps(inhsepi), -1);
  end
end
  
fam = struct('params', p, 'kin', repmat(struct('exc', []), p.ndirs, p.nabsks));

for sti = 1:p.nabsks
  excbts = mkstabbasiscx(p.tancomb, p.sts(sti,1), p.ntancs(sti,1), ...
                         p.degrees(1), p.stabs(1));
  
  if sti > 1
    inhbts = mkstabbasiscx(p.tancomb, p.sts(sti,2), p.ntancs(sti,2), ...
                           p.degrees(inhdegi), p.stabs(inhstabi));
  end

  for diri = 1:p.ndirs
    dir = (diri - 1)*p.dirincs;
    
    fam.kin(diri, sti).exc = mkinitopopset(dir, excbns, excbts, p.scls(sti,1));
    
    if sti > 1
      fam.kin(diri, sti).poskinh = ...
        mkinitopopset(dir, poskinhbns, inhbts, p.scls(sti,2));
      fam.kin(diri, sti).negkinh = ...
        mkinitopopset(dir, negkinhbns, inhbts, p.scls(sti,2));
    end
  end
end
