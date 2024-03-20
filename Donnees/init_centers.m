function [centers] = init_centers(racine_K, K, im, num_image)

row = size(im, 1);
col = size(im, 2);
centers = zeros(K, 5);
S_x = row/racine_K;
S_y = col/racine_K;

k = 1;
for i = 0:racine_K-1
    for j = 0:racine_K-1
        x = floor(S_x*(0.5 + i));
        y = floor(S_y*(0.5 + j));
        r = double(im(x,y,1,num_image));
        g = double(im(x,y,2,num_image));
        b = double(im(x,y,3,num_image));
        centers(k,:) = [x y r g b];
        k = k + 1;
    end
end

end