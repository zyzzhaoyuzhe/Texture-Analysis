function opset = mkcompatopset(compats, p)

nops = p.ntotdirs*p.nks*p.nnormcs*p.ntancs + ...
       (p.nnormcs + 1)*p.ntancs + (p.ntancs > 2)*4 + ...
       strcmpi(p.stabtype, 'combination') + 1;
ops = repmat(struct('type', [], 'args', [], 'info', []), [nops 1]);
opi = 1;

for tani = 1:p.ntancs
  for normi = 1:p.nnormcs
    info = struct('tani', tani, 'normi', normi);
    
    for tji = 1:p.ntotdirs
      for kji = 1:p.nks
        ops(opi).type = 'conv';
        ops(opi).args = ...
          struct('kern', compats{normi,tani,tji,kji}, ...
                 'target', struct('tji', tji, 'kji', kji));
        ops(opi).info = info;
        opi = opi + 1;
      end
    end

    ops(opi).type = 'sum';
    ops(opi).args = struct('n', p.ntotdirs*p.nks);
    ops(opi).info = info;
    opi = opi + 1;
  end
  
  info = struct('tani', tani, 'normi', []);
  
  ops(opi).type = 'lland';
  ops(opi).args = struct('n', p.nnormcs, 'scale', 1);
  ops(opi).info = info;
  opi = opi + 1;
end

halftancs = floor(p.ntancs/2);

if strcmpi(p.stabtype, 'combination') && p.stab ~= 0
  ops(opi) = struct('type', 'stabilize', ...
                    'args', struct('n', p.ntancs, 'stab', p.stab), ...
                    'info', []);
  opi = opi + 1;
end

if (p.ntancs > 2)
  ops(opi:opi + 3) = [
    struct('type', 'reverse', 'args', struct('n', halftancs), 'info', []);
    struct('type', 'surround', 'args', struct('n', halftancs), 'info', []);
    struct('type', 'rotstack', 'args', struct('n', 1), 'info', []);
    struct('type', 'surround', 'args', struct('n', halftancs), 'info', []);
  ];
  opi = opi + 4;
end

ops(opi).type = 'lland';
ops(opi).args = struct('n', 2 + p.ntancs - halftancs*2);
ops(opi).info = [];

opset = struct('ops', ops);