function [output,eigenvalue] = EdgeSelection(matrix_origin, prob,edgethr)
% imagestack = imagestackRead(filename_pre);
edgepick = prob>edgethr;
matrix = matrix_origin(edgepick==1,edgepick==1);
[eigenvector,eigenvalue] = eig(matrix);
eigenvalue(abs(eigenvalue)<1e-14) = 0;
output = eigenvector*sqrt(eigenvalue);
output = output';
output = flipud(output);
temp = diag(eigenvalue);
temp = flipud(temp);
figure;
plot(temp(1:20));
% Switch mode
filename_pre = 'all';
title(strcat(filename_pre,'_eigenvalue'));
% saveas(gcf,strcat('0804/',filename_pre,'_highprob','_eigen'),'fig');
figure;
scatter3(output(1,:),output(2,:),output(3,:),14,output(1,:),'filled');
title(strcat(filename_pre,': First 3 dimensional subspace'));
% saveas(gcf,strcat('0804/',filename_pre,'_highprob','_3D'),'fig');
end
