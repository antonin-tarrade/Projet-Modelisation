clear;
close all;
clc;
load("donnee_pour_P3.mat")

% Calcul des faces uniques à partir des tétraèdres
Faces = [tri(:, [1, 2, 3]); tri(:, [1, 2, 4]); tri(:, [1, 3, 4]); tri(:, [2, 3, 4])];


% Trier les faces par ordre croissant de ses sommets
Sorted_Faces = sortrows(Faces, [1 2 3]);


% Supression des faces en doubles : 
i = 1;
while i < size(Sorted_Faces,1)
    if Sorted_Faces(i,:) == Sorted_Faces(i+1,:)
        Sorted_Faces(i+1,:) = [];
    else
        i = i+1;
    end
    
end


fprintf('Calcul du maillage final terminé : %d faces. \n',size(Sorted_Faces,1));

% Affichage du maillage final
figure;
hold on
for i = 1:size(Sorted_Faces,1)
   plot3([X(1,Sorted_Faces(i,1)) X(1,Sorted_Faces(i,2))],[X(2,Sorted_Faces(i,1)) X(2,Sorted_Faces(i,2))],[X(3,Sorted_Faces(i,1)) X(3,Sorted_Faces(i,2))],'r');
   plot3([X(1,Sorted_Faces(i,1)) X(1,Sorted_Faces(i,3))],[X(2,Sorted_Faces(i,1)) X(2,Sorted_Faces(i,3))],[X(3,Sorted_Faces(i,1)) X(3,Sorted_Faces(i,3))],'r');
   plot3([X(1,Sorted_Faces(i,3)) X(1,Sorted_Faces(i,2))],[X(2,Sorted_Faces(i,3)) X(2,Sorted_Faces(i,2))],[X(3,Sorted_Faces(i,3)) X(3,Sorted_Faces(i,2))],'r');
end

