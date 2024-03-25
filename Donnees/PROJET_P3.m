clear;
close all;
clc;
load("donnee_pour_P3.mat")

% Calcul des faces du maillage à garder
faces = zeros(size(tri,1)*size(tri,2), 3);

% Récupération des faces de chaque tétraèdre
for tetra = 1:size(tri,1)
    faces((tetra - 1)*4 + 1, :) = tri(tetra, 1:3);
    faces((tetra - 1)*4 + 2, :) = [tri(tetra, 1:2), tri(tetra, 4)];
    faces((tetra - 1)*4 + 3, :) = [tri(tetra, 1), tri(tetra, 3:4)];
    faces((tetra - 1)*4 + 4, :) = tri(tetra, 2:4);
end

% Tri des faces par ordre croissant pour les 3 sommets 
faces = sort(faces, 2);
sorted_faces = sortrows(faces);

% Supprimer les doublons
[~, indice_unique, ~] = unique(sorted_faces, 'rows');
sorted_faces = sorted_faces(sort(indice_unique), :);

FACES = sorted_faces;

fprintf('Calcul du maillage final terminé : %d faces. \n',size(FACES,1));

% Affichage du maillage final
figure;
hold on
for i = 1:size(FACES,1)
   plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
   plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
   plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
end