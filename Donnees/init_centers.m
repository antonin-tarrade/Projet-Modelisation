function [centers] = init_centers(racine_K, K, im, num_image, n)

    row = size(im, 1);
    col = size(im, 2);
    centers = zeros(K, 5);
    S_x = row / racine_K;
    S_y = col / racine_K;
    
    k = 1;
    for i = 0:racine_K-1
        for j = 0:racine_K-1
            x_center = floor(S_x * (0.5 + i));
            y_center = floor(S_y * (0.5 + j));
            
            % Chercher le pixel de gradiant le plus faible
            [x, y, r, g, b] = find_min_gradient(im, num_image, x_center, y_center, n);
            
            centers(k,:) = [x y r g b];
            k = k + 1;
        end
    end
end


function [x, y, r, g, b] = find_min_gradient(im, num_image, x_center, y_center, n)
    row = size(im, 1);
    col = size(im, 2);
    min_gradient = Inf;
    min_x = 0;
    min_y = 0;
    
    for i = max(1, x_center - floor(n/2)):min(row, x_center + floor(n/2))
        for j = max(1, y_center - floor(n/2)):min(col, y_center + floor(n/2))
            % Calcul du gradiant
            gradient = compute_gradient(im, i, j, num_image);
            if gradient < min_gradient
                min_gradient = gradient;
                min_x = i;
                min_y = j;
            end
        end
    end

    r = double(im(min_x, min_y, 1, num_image));
    g = double(im(min_x, min_y, 2, num_image));
    b = double(im(min_x, min_y, 3, num_image));
    x = min_x;
    y = min_y;
end


function gradient = compute_gradient(im, x, y, num_image)
    % Operateur de Sobel
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
    
    gradient_x = sum(sum(sobel_x .* double(im(x-1:x+1, y-1:y+1, 1, num_image))));
    gradient_y = sum(sum(sobel_y .* double(im(x-1:x+1, y-1:y+1, 1, num_image))));
    
    gradient = sqrt(gradient_x^2 + gradient_y^2);
end

