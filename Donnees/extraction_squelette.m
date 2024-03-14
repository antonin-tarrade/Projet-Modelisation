function squelette = extraction_squelette(img_binaire)
% function EXTRACTION_SQUELETTE 
% Renvois une matrice binaire indiquant quels points appartienent a l'axe
% mediant de l'image originelle.
%  Arguments : 
%   img_binaire : Matrice binaire representant l'image segmentee (fond-forme) initiale 
%  Retour : 
%    squelette : Matrice binaire representant l'axe median (squelette) de
%    l'image initiale

    P = get_initial_point(img_binaire);
    
    contour = flip(bwtraceboundary(img_binaire,P,"NW"),2);
    
    if(~isempty(contour))
        figure;
        imshow(img_binaire);
        hold on;
        plot(contour(:,1), contour(:,2), 'g', 'LineWidth', 2);
    end

   
    dt = delaunayTriangulation(contour(:,2),contour(:,1));
    
    [V, R] = voronoiDiagram(dt);

     V_final = sort_edges(img_binaire,V);
     scatter(V_final(:,1), V_final(:,2), 'm', 'filled');

    for i = 1:size(R,1)
        indices = R{i};  
        vertices = flip(V(indices,:),2);

        vertices_sorted = sort_vertex(img_binaire,vertices);
        plot(vertices_sorted(:,1), vertices_sorted(:,2), 'b', 'LineWidth', 1);


%         valid_vertices = all(vertices >= 1 & vertices <= [nb_col, nb_row], 2);
%         valid_region_vertices = vertices(valid_vertices, :);
% 
%         
%         if size(valid_region_vertices, 1) > 1
%             plot(valid_region_vertices(:,1), valid_region_vertices(:,2), 'b', 'LineWidth', 1);
%         end
    end

    hold off;

end

function position_sorted = sort_edges(img_binaire,positions)
    n = size(positions,1);
    [nb_row,nb_col] = size(img_binaire);
    mask = repmat(zeros(n,1),1,2);

    for i=1:n
        x = floor(positions(i,1));
        y = floor(positions(i,2));

        if x > nb_row || y > nb_col || x <= 0 || y <= 0
            mask(i,:) = 0;
        else
            mask(i,:) = img_binaire(x,y)~= 0;
        end
    end

    position_sorted = flip(reshape(positions(logical(mask)),[],2),2);
end



function position_sorted = sort_vertex(img_binaire,positions)
    positions = flip(positions,2);
    n = size(positions,1);
    [nb_row,nb_col] = size(img_binaire);
    mask = repmat(zeros(n,1),1,2);

    for i=1:n
        x = floor(positions(i,1));
        y = floor(positions(i,2));

        if x > nb_row || y > nb_col || x <= 0 || y <= 0
            mask(i,:) = 0;
        else
            mask(i,:) = img_binaire(x,y)~= 0;
        end
    end

    position_sorted = flip(reshape(positions(logical(mask)),[],2),2);
end
