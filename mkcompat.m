function compat = mkcompat(xi, yi, ti, ki, xjs, yjs, p)

drenorm = nthdofg(-1, 1, 1);

possums = zeros(p.nnormcs, 1);
negsums = zeros(p.nnormcs, 1);

normcs = cell([p.nnormcs 1 p.ntotdirs p.nks]);
transds = cell([p.nnormcs 1 p.ntotdirs p.nks]);
gjhist = zeros(p.ksize, 1);

for tji = 1:p.ntotdirs
  tj = (tji - 1)*p.dirincs;

  for kji = 1:p.nks
    kj = (kji - p.nabsks)*p.kincs;
    
    [xydiff tdiff kdiff transdiff] = ...
      projdiffs(xi, yi, ti, ki, xjs, yjs, tj, kj, p.npis);

    expansion = 1 + p.dilation*abs(transdiff);

    xsxy = p.sxy.*expansion;
    xsth = p.sth.*p.dirincs.*expansion;
    xsk = p.sk.*p.kincs.*expansion;

    [gxy gth gk gtrans] = ...
      gj(xydiff, tdiff, kdiff, transdiff, xsxy, xsth, xsk, p.str);
    gjprod = gxy.*gth.*gk.*gtrans;
    selection = transdiff > -floor(p.ksize/2) - 0.5 & ...
                transdiff < floor(p.ksize/2) + 0.5;
    histindxs = round(transdiff(selection)) + ceil(p.ksize/2);
    selectedgjprod = gjprod(selection);
    
    for i = 1:length(gjhist)
      gjhist(i) = gjhist(i) + sum(selectedgjprod(histindxs == i));
    end

    for normi = 1:p.nnormcs
      sgn = mod(normi - 1, 2)*2 - 1;
      offset = sgn*p.sep;
      
      if normi <= 2
        kern = sgn*gth.*gk.*gtrans.* ...
          nthdofg(xydiff./xsxy - offset.*expansion, 1, 1)/drenorm;
      elseif normi <= 4
        kern = sgn.*gxy.*gk.*gtrans.* ...
          nthdofg(tdiff./xsth - offset.*expansion, 1, 1)/drenorm;
      else
        kern = sgn.*gxy.*gth.*gtrans.* ...
          nthdofg(kdiff./xsk - offset.*expansion, 1, 1)/drenorm;
      end

      possums(normi) = possums(normi) + sum(kern(kern > 0));
      negsums(normi) = negsums(normi) - sum(kern(kern < 0));

      normcs{normi,1,tji,kji} = kern;
      transds{normi,1,tji,kji} = transdiff;
    end
  end
end

compat = dividecompat(normcs, transds, gjhist, possums, negsums, p);