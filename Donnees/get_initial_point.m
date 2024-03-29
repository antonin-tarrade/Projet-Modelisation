function P = get_initial_point(img_binaire)
% function GET_INITIAL_POINT
% Fonction permettant de trouver un point initial pour pouvoir calculer le contour. 
% Dans cette version on prend le premier point se trouvant sur la ligne du milieu
[nb_row, nb_col] = size(img_binaire);
i = nb_row/2;
j = 1;
init_p_found = false;
while ~init_p_found && i < nb_row
    j = j+1;
    if j > nb_col 
        j = 1;
        i = i+1;
    end
    init_p_found = ( img_binaire(i,j) ~= 0);
end
P = [i,j];
end

