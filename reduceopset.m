function rdctn = reduceopset(opset, ksign)

if isfield(opset, 'ops')
  ops = opset.ops;
  nops = length(ops);

  for i = 1:nops
    if strcmpi(ops(i).type, 'conv')
      scale = 1;
      
      if isfield(ops(i).args, 'scale')
        scale = ops(i).args.scale;
      end
      
      if exist('rdctn', 'var')
        rdctn = rdctn + scale.*ops(i).args.kern;
      else
        rdctn = scale.*ops(i).args.kern;
      end
    end
  end
else
  excrdctn = reduceopset(opset.exc);
  
  if ~isempty(opset.poskinh) && (nargin < 2 || ksign >= 0)
     inhrdctn = halfrect(reduceopset(opset.poskinh));
  elseif ~isempty(opset.negkinh)
     inhrdctn = halfrect(reduceopset(opset.negkinh));
  else
    inhrdctn = 0;
  end
  
  [excrows exccols] = size(excrdctn);
  [inhrows inhcols] = size(inhrdctn);
  
  if excrows < inhrows
    excrdctn = padarray(excrdctn, floor((inhrows - excrows)/2));
  elseif inhrows < excrows
    inhrdctn = padarray(inhrdctn, floor((excrows - inhrows)/2));
  end
  
  if exccols < inhcols
    excrdctn = padarray(excrdctn, [0 floor((inhcols - exccols)/2)]);
  elseif inhrows < excrows
    inhrdctn = padarray(inhrdctn, [0 floor((exccols - inhcols)/2)]);
  end
  
  rdctn = excrdctn - halfrect(inhrdctn);
end