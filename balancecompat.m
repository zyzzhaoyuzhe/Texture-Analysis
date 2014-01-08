function compat = balancecompat(compat, norm, possums, negsums)

[nnormcs ntancs ntotdirs nks] = size(compat);

for normi = 1:nnormcs
  for tani = 1:ntancs
    for tji = 1:ntotdirs
      for kji = 1:nks
        kern = compat{normi,tani,tji,kji};
        kern(kern > 0) = norm*kern(kern > 0)/possums(normi,tani);
        kern(kern < 0) = norm*kern(kern < 0)/negsums(normi,tani);
        compat{normi,tani,tji,kji} = kern;
      end
    end
  end
end