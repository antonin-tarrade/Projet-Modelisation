clear;
close all;
clc;
load("donnee_pour_P3.mat")


% Calcul des faces uniques à partir des tétraèdres
faces = [tri(:, [1, 2, 3]); tri(:, [1, 2, 4]); tri(:, [1, 3, 4]); tri(:, [2, 3, 4])];

% tri des faces par ordre croissant pour les 3 sommets 
faces = sortrows(sort(faces,2));

to_del = [];
for face = 1:size(faces,1)-1
    if sum(faces(face,:) == faces(face+1,:)) == 3
        to_del = [to_del face face+1];
    end
end

% Supprimer les surfaces marquées pour suppression
faces(unique(to_del),:) = [];


fprintf('Calcul du maillage final terminé : %d faces. \n',size(faces,1));

% Affichage du maillage final
figure;
hold on
for i = 1:size(faces,1)
   plot3([X(1,faces(i,1)) X(1,faces(i,2))],[X(2,faces(i,1)) X(2,faces(i,2))],[X(3,faces(i,1)) X(3,faces(i,2))],'r');
   plot3([X(1,faces(i,1)) X(1,faces(i,3))],[X(2,faces(i,1)) X(2,faces(i,3))],[X(3,faces(i,1)) X(3,faces(i,3))],'r');
   plot3([X(1,faces(i,3)) X(1,faces(i,2))],[X(2,faces(i,3)) X(2,faces(i,2))],[X(3,faces(i,3)) X(3,faces(i,2))],'r');
end

