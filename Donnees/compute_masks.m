nb_images = 36;                     % Nombre d'images total
num_images = 1:36;                  % Numéro des images à afficher
nb_images_plot = nb_images;         % Nombre d'image à afficher
compute_skeleton = false;           % Calculer ou non les squelette

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    im(:,:,:,i) = imread(nom);
end

% SEGMENTATION %

row = size(im, 1);      % Nombre de ligne
col = size(im, 2);      % Nombre de collone
N = row * col;          % Nombre de pixel
racine_K = 5;           % La racine du nombre de points
K = racine_K^2;         % Nombre de superpixel
S = sqrt(N/K);          % Pas entre les superpixels
max_iter = 5;           % Nombre maximum d'iteration
m = 1;                  % Poid de la position dans le calcul de la distence
coef = m/S;             % Coef pour distance

masks = zeros(row, col, nb_images);    % Les masques binaires

% Boucle sur les images
for current_plot = 1:nb_images_plot

    num_image = num_images(current_plot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculs des superpixels                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initializer les positions des centres
    centers = init_centers(racine_K, K, im, num_image);

    labels = zeros(row, col);
    iter = 1;
    new_centers = zeros(size(centers));
    arret = false;
    
    while ~arret

        % Attribuer les labels
        for i = 1:row
            for j = 1:col
                [label, prop] = plusProcheCentre(i, j, coef, im, num_image, K, centers);
                labels(i, j) = label;
                new_centers(label, :) = new_centers(label, :) + prop;
            end
        end
    
        % Faire la moyenne pour les nouveaux centres
        for k = 1:K
            cluster_indices = find(labels == k);
            num_elements = numel(cluster_indices);
            if num_elements > 0
                new_centers(k, :) = new_centers(k, :) / num_elements;
            end
        end
    
        % Mise a jour des centres et condition d'arrêt
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

    masks(:,:,current_plot) = bin;
    fprintf('%d', current_plot);

end

save('masks.mat', 'masks');

