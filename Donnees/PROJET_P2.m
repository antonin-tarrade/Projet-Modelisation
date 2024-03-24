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


%% P2 - Estimation surface %%

% Chargement des points 2D suivis 
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
X = [];                 % Contient les coordonnees des points en 3D
color = [];             % Contient la couleur associee

% Pour chaque couple de points apparies
for i = 1:size(pts,1)

    % Recuperation des ensembles de points apparies
    l = find(pts(i,1:2:end)~=-1);

    % Verification qu'il existe bien des points apparies dans cette image
    if size(l,2) > 1 && max(l)-min(l) > 1 && max(l)-min(l) < 36
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


%% affichage du nuage de points 3D
figure;
hold on;
for i = 1:size(X,2)
    plot3(X(1,i),X(2,i),X(3,i),'.','col',color(:,i)/255);
end
hold off;
axis equal;

% Affichage de la tetraedrisation de Delaunay
T = DelaunayTri(X(1:3,:)');
fprintf('Tetraedrisation terminee : %d tetraedres trouves. \n',size(T,1));
figure;
tetramesh(T);


%% Calcul des barycentres de chacun des tetraedres
load('masks.mat')

poid_1 = [0.25, 0.25, 0.25, 0.25];
poid_2 = [0.85, 0.05, 0.05, 0.05];
poid_3 = [0.05, 0.85, 0.05, 0.05];
poid_4 = [0.05, 0.05, 0.85, 0.05];
poid_5 = [0.05, 0.05, 0.05, 0.85];
poids = [poid_1; poid_2; poid_3; poid_4; poid_5];

nb_barycentres = size(poids, 1);

for num_poid = 1:nb_barycentres
    for i = 1:size(T,1)
        % Calcul des barycentres differents en fonction des poids differents
        % En commencant par le barycentre avec poids uniformes
        points = T.X(T.Triangulation(i,:),:)
        points_pond = points .* poids(num_poid,:)'
        C_g(:,i,num_poid) = sum(points_pond, 1);
        pause
    end
end

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
% end

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