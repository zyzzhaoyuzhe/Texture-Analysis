function compat = ...
  dividecompat(normcs, transds, gjhist, possums, negsums, p)

compat = cell([p.nnormcs p.ntancs p.ntotdirs p.nks]);
partpnts = computecompatpartpnts(gjhist, p.ntancs);

normcs = balancecompat(normcs, 1, possums, negsums);

possums = zeros(p.nnormcs, p.ntancs);
negsums = zeros(p.nnormcs, p.ntancs);

for normi = 1:p.nnormcs
  for tji = 1:p.ntotdirs
    for kji = 1:p.nks
      kern = normcs{normi,1,tji,kji};
      transd = transds{normi,1,tji,kji};
      
      compatparts = cell(p.ntancs, 1);
      compatpartsum = 0;
      gtransd = gaussian(transd, p.str, true);
      kern = kern./gtransd;
      for tani = 1:p.ntancs
        part = stabpart(transd, p.ntancs, partpnts, tani, p.stab, p.degree, p.str);
        compatpartsum = compatpartsum + part./gtransd;
        compatparts{tani} = part;
      end

      ispos = compatpartsum > 0;
      for tani = 1:p.ntancs
        partnonzeros = compatparts{tani} ~= 0;
        sel = ispos & partnonzeros;
        temp = zeros(size(kern));
        temp(sel) = kern(sel).*compatparts{tani}(sel)./compatpartsum(sel);
        possums(normi,tani) = possums(normi,tani) + sum(temp(temp > 0));
        negsums(normi,tani) = negsums(normi,tani) - sum(temp(temp < 0));
        compat{normi,tani,tji,kji} = temp;
      end
    end
  end
end

compat = balancecompat(compat, 1/p.ntancs, possums, negsums);