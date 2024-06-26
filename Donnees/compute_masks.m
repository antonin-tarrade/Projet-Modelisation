clear;
close all;
clc;

% chargement des images
nb_images = 36;
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    im(:,:,:,i) = imread(nom);
end

nb_images_plot = 36;                % Nombre d'image à afficher
num_images = 1:nb_images_plot;      % Numéro des images à afficher

%% SEGMENTATION %%

row = size(im, 1);      % Nombre de ligne
col = size(im, 2);      % Nombre de collone
N = row * col;          % Nombre de pixel
racine_K = 10;          % La racine du nombre de points
K = racine_K^2;         % Nombre de superpixel
S = sqrt(N/K);          % Pas entre les superpixels
max_iter = 5;           % Nombre maximum d'iteration
m = 0.3;                % Poid de la position dans le calcul de la distence
n = 5;                  % Taille du carrée de recherche de gradiant pour init les centres

masks = zeros(row, col, nb_images);    % Les masques binaires
figure('Name', 'Segmentations Binaires');
hold on;

% Boucle sur les images a afficher
for current_plot = 1:nb_images_plot

    num_image = num_images(current_plot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculs des superpixels                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initializer les positions des centres
    centers = init_centers(racine_K, K, im, num_image, n);

    iter = 1;
    arret = false;
    
    while ~arret

        % Attribuer les labels et calculer les nouveaux centres
        [labels, new_centers] = plusProcheCentre(S, m, im, num_image, K, centers);
    
        % Condition d'arrêt
        arret = iter > max_iter || isequal(new_centers, centers);
        iter = iter + 1;
        centers = new_centers;
            
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Binarisation de l'image à partir des superpixels        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bin = zeros(row, col);
    for k = 1:K
        r = centers(k, 3);
        b = centers(k, 5);
        if r > b
            bin(labels == k) = 255;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Renforcement de la connectivité du masque               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    new_bin = bin;
    P = get_initial_point(new_bin);
    contour = bwtraceboundary(new_bin,P,"N",8);
    mask = roipoly(bin,contour(:,2),contour(:,1));
    new_bin(mask) = 255;
    new_bin(~mask) = 0;
    % Afficher l'image modifiée
    imshow(new_bin);
    pause(2);
    masks(:,:,current_plot) = new_bin;
    clc;
    fprintf('%d / %d\n', current_plot, nb_images_plot);
    
end

hold off;

save('masks.mat', 'masks');



