function P = get_initial_point(img_binaire)
%function GET_INITIAL_POINT
%Detailed explanation goes here
[nb_row, nb_col] = size(img_binaire);
i = nb_row/2;
j = 1;
init_p_found = false;
% figure;
% imshow(img_binaire);
% hold on;
while ~init_p_found && i < nb_row
    scatter(j,i,'red');
    init_p_found = ( img_binaire(i,j) ~= 0);
    j = j+1;
    if j > nb_col 
        j = 1;
        i = i+1;
    end
end
P = [i,j];
end

