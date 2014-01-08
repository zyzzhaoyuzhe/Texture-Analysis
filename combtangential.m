function ops = combtangential(type, n)

if mod(n, 2) ~= 0
  error('There must be an even number of tangential components.');
end

switch type
  case 'simple'
    if n > 2
      extlen = round(n/2 - 1);
      ops = [
        struct('type', 'lland', 'args', struct('n', extlen, 'scale', 1/extlen));
        struct('type', 'rotstack', 'args', struct('n', 1));
        struct('type', 'lland', 'args', struct('n', 2, 'scale', 1/2));
        struct('type', 'rotstack', 'args', struct('n', 1));
        struct('type', 'lland', 'args', struct('n', extlen, 'scale', 1/extlen));
      	struct('type', 'llor', 'args', struct('n', 2, 'scale', 1/2));
        struct('type', 'lland', 'args', struct('n', 2, 'scale', 1/2));
      ];
    else
      ops = struct('type', 'lland', 'args', struct('n', 2, 'scale', 1/2));
    end
    
  case 'majority'
    ops = struct( ...
      'type', 'nofm', 'args', struct('n', n/2 + 1, 'm', n, 'scale', 1/n) ...
    );
    
  otherwise
    error(['Invalid tangential combination type: ' type '.']);
end