function [labels, new_centers] = plusProcheCentre(S, m, im, num_image, K, centers)

    row = size(im, 1);                      % Nombre de ligne
    col = size(im, 2);                      % Nombre de collone
    labels = zeros(row, col);               % Les nouveaux labels des pixcel
    new_centers = zeros(size(centers));     % Les nouveaux centres

    for x = 1:row
        for y = 1:col

            r = double(im(x,y,1,num_image));
            g = double(im(x,y,2,num_image));
            b = double(im(x,y,3,num_image));
            prop = [x y r g b];  % Les propriétées du pixcel
            
            min_dist = +inf;
            label = 1;

            for k = 1:K
                % Calcul de la distance au centre
                dist_xy = sqrt((x-centers(k,1))^2 + (y-centers(k,2))^2);
                if dist_xy < 3 * S      % Cherhcer dans un rayon de 2*S
                    dist_rgb = 0;
                    for c = 1:3
                        color = im(floor(centers(k,1)), floor(centers(k,2)), c, num_image);
                        dist_rgb = dist_rgb + (prop(c+2)-double(color))^2;
                    end
                    dist_rgb = sqrt(dist_rgb);
                    dist = dist_rgb + m/S * dist_xy;
                    % Garder le centre le plus proche
                    if dist < min_dist
                        min_dist = dist;
                        label = k;
                    end
                end
            end

            labels(x, y) = label;
            new_centers(label, :) = new_centers(label, :) + prop;

        end
    end
    
    % Faire la moyenne pour calculer les nouveaux centres
    for k = 1:K
        cluster_indices = find(labels == k);
        num_elements = numel(cluster_indices);
        if num_elements > 0
            new_centers(k, :) = new_centers(k, :) / num_elements;
        end
    end
    
    

end


