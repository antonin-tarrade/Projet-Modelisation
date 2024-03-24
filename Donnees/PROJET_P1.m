clear;
close all;
clc;

% Affichage des figures
screen_size = get(0, 'ScreenSize');
screen_width = screen_size(3);
screen_height = screen_size(4);
window_width = 0.7 * screen_width;
window_height = 0.7 * screen_height;
window_x = (screen_width - window_width) / 2;
window_y = (screen_height - window_height) / 2;
window_set = [window_x, window_y, window_width, window_height];
pause_time = 0.1;

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


%% Affichage des images %%
num_images = [1, 9, 17, 25];                % Numéro des images à afficher
nb_row_plot = 2;                            % Nombre de lignes pour l'affichage
nb_col_plot = 2;                            % Nombre de colones pour l'affichage
nb_images_plot = nb_row_plot*nb_col_plot;   % Nombre d'image à afficher



% Affichage des images
figure('Name', 'Parti 1 - Segmentation', 'Position', window_set);
for i = 1:nb_images_plot
    subplot(nb_row_plot,nb_col_plot,i);
    imshow(im(:,:,:,num_images(i)));
    title(sprintf('Image %d',num_images(i)));
end
pause(pause_time);


%% P1 - SEGMENTATION %%

row = size(im, 1);      % Nombre de ligne
col = size(im, 2);      % Nombre de collone
N = row * col;          % Nombre de pixel
racine_K = 7;           % La racine du nombre de points
K = racine_K^2;         % Nombre de superpixel
S = sqrt(N/K);          % Pas entre les superpixels
max_iter = 5;           % Nombre maximum d'iteration
m = 50;                 % Poid de la position dans le calcul de la distence

% Boucle sur les images a afficher
for current_plot = 1:nb_images_plot

    num_image = num_images(current_plot);
    subplot(nb_row_plot,nb_col_plot,current_plot);
    imshow(im(:,:,:,num_image));
    title(sprintf('Image %d',num_image));
    hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculs des superpixels                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initializer les positions des centres
    centers = init_centers(racine_K, K, im, num_image);

    iter = 1;
    
    arret = false;
    
    while ~arret

        % Attribuer les labels et calculer les nouveaux centres
        [labels, new_centers] = plusProcheCentre(S, m, im, num_image, K, centers);
    
        % Condition d'arrêt
        arret = iter > max_iter || isequal(new_centers, centers);
        iter = iter + 1;
        centers = new_centers;
    
        % Afficher les centres et les superpixels
        imshow(im(:,:,:,num_image));
        scatter(centers(:, 2), centers(:, 1), 'g', 'filled');
        contour(labels, 1:K, 'LineColor', 'g', 'LineWidth', 0.5);
        pause(pause_time);
            
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
    imshow(bin)
    pause(pause_time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraction du squelette                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [boundary,vertices,skeleton] = skeleton_extraction(bin);
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 1);
    scatter(vertices(:,2), vertices(:,1), 'm', '.');
    plot(skeleton(:,2), skeleton(:,1), 'b', 'LineWidth', 1);

    hold off;
end



