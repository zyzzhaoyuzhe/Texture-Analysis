function x = readPlain(fn)
% function x = readPlain(fn)
%
% reads the output of graphviz files with plain output format
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

fh = fopen(fn,'r');
l = ' ';
while(ischar(l)),
  l = fgetl(fh);
  c = textscan(l,'%s %f %f %fx');
  if (strcmp(c{1},'node'))
    x(c{2},:) = [c{3},c{4}];
  end
  if (strcmp(c{1},'edge')), break; end
end

fclose(fh);
