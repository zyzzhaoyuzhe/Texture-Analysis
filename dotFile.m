function dotFile(a, fn)
% function dotFile(a, fn)
%
% takes an undirected graph a and produces a dot file fn for it
%
% use like this:
% 
% in matlab: 
% dotFile(a,'tmp.dot'); 
% unix('sfdp -otmp.plain tmp.dot -Tplain');
% x = readPlain('tmp.plain');
% gplot(a,x)
%
% Daniel Spielman, Aug 28, 2013

% clean it up
a = (a + a') > 0;
a = a - diag(diag(a));

[ai,aj] = find(triu(a));

fh = fopen(fn,'w');

fprintf(fh, 'graph G {\n');
for i = 1:length(ai),
    fprintf(fh, '  %d -- %d;\n',ai(i),aj(i));
end

fprintf(fh, '}\n');

fclose(fh);