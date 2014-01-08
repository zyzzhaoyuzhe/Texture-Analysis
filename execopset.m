function [prim dual] = execopset(src, opset, degree, adapt)

convfunc = @conv2;

[nrows ncols ndirs nks] = size(src); %#ok<NASGU>

nops = length(opset.ops);

dodual = nargout > 1;

stack = zeros(nrows, (1 + dodual)*ncols, 5);
primixs = 1:ncols;

if dodual
  dualixs = primixs + ncols;
  ndirs = ndirs/2;
end

topi = 0;
newtopi = 0;

for i = 1:nops
  type = opset.ops(i).type;
  args = opset.ops(i).args;
  scale = 1;
  
  if isfield(args, 'scale')
    scale = args.scale;
  end
  
  if isfield(args, 'degscl') && ~adapt
    scaleddeg = degree*args.degscl;
  else
    scaleddeg = degree;
  end
  
  switch lower(type)
    % This is the only case that adds elements to the stack
    
    case 'conv' % args.kern is kernel to convolve with
      newtopi = topi + 1;
      kern = rot90(args.kern, 2);
      
      if isfield(args, 'target')
        tji = args.target.tji;
        kji = args.target.kji;
        stack(:,primixs,newtopi) = convfunc(src(:,:,tji,kji), kern, 'same');
        if dodual
          stack(:,dualixs,newtopi) = ...
            convfunc(src(:,:,tji + ndirs,kji), kern, 'same');
        end
      else
        stack(:,primixs,newtopi) = convfunc(src, kern, 'same');
        if dodual
          stack(:,dualixs,newtopi) = -stack(:,primixs,newtopi);
        end
      end        
      
    % These cases leave the stack size unchanged
      
    case 'scale' % args.scale is scaling factor
      % Handled after switch
      
    case 'halfrect' % args.n is number of stack elements to half-rectify
      fatslc = stack(:,:,topi - args.n + 1:topi);
      stack(:,:,topi - args + 1:topi) = (fatslc > 0).*fatslc;
      
    case 'rotstack' % args.n is how much to rotate stack (+ brings bottom up)
      stack(:,:,1:topi) = circshift(stack(:,:,1:topi), [0 0 args.n]);
      
    case 'reverse' % args.n is number of elements to reverse
      stack(:,:,topi - args.n + 1:topi) = stack(:,:,topi:-1:topi - args.n + 1);
      
    case 'stabilize' % stabilize top args.n elements by amount args.stab
      fatslc = stack(:,:,topi - args.n + 1:topi);
      slcsum = sum(abs(fatslc), 3);
      add = abs(fatslc) - repmat(slcsum./args.n, [1 1 args.n]);
      stack(:,:,topi - args.n + 1:topi) = fatslc + args.stab.*add;
    
    % The following cases change how many elements are on the stack
    
    case 'sum' % args.n is number of elements to sum together
      newtopi = topi - args.n + 1;
      stack(:,:,newtopi) = sum(stack(:,:,newtopi:topi), 3);
      
    case 'lland' % args.n is number of elements to lland together
      newtopi = topi - args.n + 1;
      if args.n > 2
        stack(:,:,newtopi) = ...
          llandn(stack(:,:,newtopi:topi), 3, scaleddeg, adapt);
      elseif args.n == 2
        stack(:,:,newtopi) = ...
          lland2(stack(:,:,newtopi), stack(:,:,topi), scaleddeg, adapt);
      end
      
    case 'llor' % args.n is number of elements to llor together
      newtopi = topi - args.n + 1;
      if args.n > 2
        stack(:,:,newtopi) = ...
          llorn(stack(:,:,newtopi:topi), 3, scaleddeg, adapt);
      elseif args.n == 2
        stack(:,:,newtopi) = ...
          llor2(stack(:,:,newtopi), stack(:,:,topi), scaleddeg, adapt);
      end
      
    case 'nofm' % Are there args.n positive responses in the top args.m elems?
      newtopi = topi - args.m + 1;
      perms = nchoosek(1:args.m, args.n);
      nperms = size(perms, 1);
      llands = zeros(nrows, 2*ncols, nperms);
      fatslc = stack(:,:,newtopi:topi); % Delicious pizza
      for perm = 1:nperms
        llands(:,:,i) = llandn(fatslc(:,:,perms(perm,:)), 3, scaleddeg, adapt);
      end
      stack(:,:,newtopi) = llorn(llands, 3, scaleddeg, adapt);
      
    case 'surround' % Is the top element "surrounded" in the args.n beneath it?
      newtopi = topi - args.n + 1;
      part = 0;
      pos = 1; neg = 1; ambig = 1; pow = 1;
      total = 0;
      maxs = max(abs(stack(:,:,newtopi:topi)), [], 3);
      maxs(maxs == 0) = 1;
      for j = topi:-1:newtopi
        ambig = ambig.*part.*(1 - part);
        part = smoothpart(stack(:,:,j), degree./maxs);
        pos = pos.*part;
        neg = neg.*(1 - part);
        total = total + stack(:,:,j).*(pos + neg + pow.*(pow - 1).*ambig);
        pow = pow*2;
      end
      stack(:,:,newtopi) = total;
      
    otherwise
      error(['Invalid operation type: ' type '.']);
  end
  
  topi = newtopi;
  
  if scale ~= 1
    stack(:,:,topi) = stack(:,:,topi)*scale;
  end
end

prim = stack(:,primixs,1:topi);

if dodual
  dual = stack(:,dualixs,1:topi);
end