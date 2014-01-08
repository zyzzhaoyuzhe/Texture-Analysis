function opset = mkinitopopset(dir, bns, bts, scale)

ksize = max(bns.size, bts.size);

nbns = numel(bns.bases);
nbts = numel(bts.bases);

opset.ops = repmat(struct('type', '', 'args', []), nbns*nbts, 1);
  
combnops = bns.combf(bns.combtype, nbns);
ncombnops = length(combnops);

combtops = bts.combf(bts.combtype, nbts);
ncombtops = length(combtops);

ind = 1;
for ti = 1:nbts
  bt = bts.bases(ti);
  
  for ni = 1:nbns
    bn = bns.bases(ni);
    
    kern = mkinitopkern(dir, bn, bt, ksize);
    
    if bn.balanced || bt.balanced
      kern = balancekern(kern);
    end
    
    opset.ops(ind).type = 'conv';
    opset.ops(ind).args = struct('kern', kern, 'scale', scale);
    
    ind = ind + 1;
  end
  
  if ncombnops > 0
    opset.ops(ind:ind + ncombnops - 1) = combnops;
    ind = ind + ncombnops;
  end
end

if ncombtops > 0
  opset.ops(ind:ind + ncombtops - 1) = combtops;
end

nops = length(opset.ops);
for i = 1:nops
  type = opset.ops(i).type;
  if strcmpi(type, 'lland') || strcmpi(type, 'llor') || strcmpi(type, 'nofm')
    opset.ops(i).args.degscl = 1/scale;
  end
end