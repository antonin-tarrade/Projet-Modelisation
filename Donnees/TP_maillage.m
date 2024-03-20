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


%% P0 - Affichage des images %%

nb_images = 36;                             % Nombre d'images total
num_images = [1, 9, 17, 29];                % Numéro des images à afficher
nb_row_plot = 2;                            % Nombre de lignes pour l'affichage
nb_col_plot = 2;                            % Nombre de colones pour l'affichage
nb_images_plot = nb_row_plot*nb_col_plot;   % Nombre d'image à afficher

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    im(:,:,:,i) = imread(nom);
end

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
racine_K = 6;           % La racine du nombre de points
K = racine_K^2;         % Nombre de superpixel
S = sqrt(N/K);          % Pas entre les superpixels
max_iter = 5;           % Nombre maximum d'iteration
m = 5;                  % Poid de la position dans le calcul de la distence
coef = m/S;             % Coef pour distance                            

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
    
        % Afficher les centres et les superpixels
        imshow(im(:,:,:,num_image));
        scatter(centers(:, 2), centers(:, 1), 'g', 'filled');
%         contour(labels, 1:K, 'LineColor', 'g', 'LineWidth', 0.5);
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
    [boundary,vertices,skeleton] = skeleton_extraction(bin);
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2);
    scatter(vertices(:,2), vertices(:,1), 'm', 'filled');
    plot(skeleton(:,2), skeleton(:,1), 'b', 'LineWidth', 1);
    hold off;

end

keyboard;



%% P2 - Estimation surface %%

% chargement des points 2D suivis 
% pts de taille nb_points x (2 x nb_images)
% sur chaque ligne de pts 
% tous les appariements possibles pour un point 3D donne
% on affiche les coordonnees (xi,yi) de Pi dans les colonnes 2i-1 et 2i
% tout le reste vaut -1
pts = load('viff.xy');
% Chargement des matrices de projection
% Chaque P{i} contient la matrice de projection associee a l'image i 
% RAPPEL : P{i} est de taille 3 x 4
load dino_Ps;

% Reconstruction des points 3D
X = []; % Contient les coordonnees des points en 3D
color = []; % Contient la couleur associee
% Pour chaque couple de points apparies
for i = 1:size(pts,1)
    % Recuperation des ensembles de points apparies
    l = find(pts(i,1:2:end)~=-1);
    % Verification qu'il existe bien des points apparies dans cette image
    if size(l,2) > 1 & max(l)-min(l) > 1 & max(l)-min(l) < 36
        A = [];
        R = 0;
        G = 0;
        B = 0;
        % Pour chaque point recupere, calcul des coordonnees en 3D
        for j = l
            A = [A;P{j}(1,:)-pts(i,(j-1)*2+1)*P{j}(3,:);
            P{j}(2,:)-pts(i,(j-1)*2+2)*P{j}(3,:)];
            R = R + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),1,j));
            G = G + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),2,j));
            B = B + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),3,j));
        end
        [U,S,V] = svd(A);
        X = [X V(:,end)/V(end,end)];
        color = [color [R/size(l,2);G/size(l,2);B/size(l,2)]];
    end
end
fprintf('Calcul des points 3D termine : %d points trouves. \n',size(X,2));

%affichage du nuage de points 3D
figure;
hold on;
for i = 1:size(X,2)
    plot3(X(1,i),X(2,i),X(3,i),'.','col',color(:,i)/255);
end
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                  %
% Tetraedrisation de Delaunay  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = ...                      

% A DECOMMENTER POUR AFFICHER LE MAILLAGE
% fprintf('Tetraedrisation terminee : %d tetraedres trouves. \n',size(T,1));
% Affichage de la tetraedrisation de Delaunay
% figure;
% tetramesh(T);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul des barycentres de chacun des tetraedres
% poids = ... 
% nb_barycentres = ... 
% for i = 1:size(T,1)
    % Calcul des barycentres differents en fonction des poids differents
    % En commencant par le barycentre avec poids uniformes
%     C_g(:,i,1)=[ ...

% A DECOMMENTER POUR VERIFICATION 
% A RE-COMMENTER UNE FOIS LA VERIFICATION FAITE
% Visualisation pour vérifier le bon calcul des barycentres
% for i = 1:nb_images
%    for k = 1:nb_barycentres
%        o = P{i}*C_g(:,:,k);
%        o = o./repmat(o(3,:),3,1);
%        imshow(im_mask(:,:,i));
%        hold on;
%        plot(o(2,:),o(1,:),'rx');
%        pause;
%        close;
%    end
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copie de la triangulation pour pouvoir supprimer des tetraedres
% tri=T.Triangulation;
% Retrait des tetraedres dont au moins un des barycentres 
% ne se trouvent pas dans au moins un des masques des images de travail
% Pour chaque barycentre
% for k=1:nb_barycentres
% ...

% A DECOMMENTER POUR AFFICHER LE MAILLAGE RESULTAT
% Affichage des tetraedres restants
% fprintf('Retrait des tetraedres exterieurs a la forme 3D termine : %d tetraedres restants. \n',size(Tbis,1));
% figure;
% trisurf(tri,X(1,:),X(2,:),X(3,:));

% Sauvegarde des donnees
% save donnees;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSEIL : A METTRE DANS UN AUTRE SCRIPT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load donnees;
% Calcul des faces du maillage à garder
% FACES = ...;
% ...

% fprintf('Calcul du maillage final termine : %d faces. \n',size(FACES,1));

% Affichage du maillage final
% figure;
% hold on
% for i = 1:size(FACES,1)
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
%    plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
% end;
