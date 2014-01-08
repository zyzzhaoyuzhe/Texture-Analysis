function [output, eigenvector, eigenvalue] = computeThirdOrderEmbed(matrix)
[eigenvector,eigenvalue] = eig(matrix);
eigenvalue(abs(eigenvalue)<1e-14) = 0;
output = eigenvector*sqrt(eigenvalue);
output = fliplr(output);
temp = diag(eigenvalue);
temp = flipud(temp);
% figure;
% plot(temp);
% % Switch mode
% filename_pre = '';
% title(strcat(filename_pre,': eigenvalue'));
% % saveas(gcf,strcat('0804/',filename_pre,'_highprob','_eigen'),'fig');
% figure;
% scatter3(output(:,1),output(:,2),output(:,3),14,output(:,1),'filled');
% title(strcat(filename_pre,': First 3 dimensional subspace'));
% % saveas(gcf,strcat('0804/',filename_pre,'_highprob','_3D'),'fig');
end
