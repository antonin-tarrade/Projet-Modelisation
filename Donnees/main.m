clear;
close all;
clc;

% PARAMÈTRE %
num_img = 1;
plot_row = 1;
plot_col = 2;


% Charger l'image %
nom_img = sprintf('images/viff.00%d.ppm',num_img-1);
I(:,:,:) = imread(nom_img);

% Afficher l'image
figure;
subplot(plot_row,plot_col,1); imshow(I(:,:,:)); title('Image origine');
