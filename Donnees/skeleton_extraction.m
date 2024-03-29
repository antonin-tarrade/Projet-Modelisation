function [contour,voronoi_vertices,skeleton] = skeleton_extraction(img_binaire)
% function EXTRACTION_SQUELETTE 
% Renvois une matrice binaire indiquant quels points appartienent a l'axe
% mediant de l'image originelle.
%  Arguments : 
%   img_binaire : Matrice binaire representant l'image segmentee (fond-forme) initiale 
%  Retour : 
%    squelette : Matrice binaire representant l'axe median (squelette) de
%    l'image initiale

    P = get_initial_point(img_binaire);
    
    contour = bwtraceboundary(img_binaire,P,"N",8);

    dt = delaunayTriangulation(contour(:,2),contour(:,1));
    
    [V, R] = voronoiDiagram(dt);
    V = flip(V,2);

     V_final = sort_position(img_binaire,V,contour);
     voronoi_vertices = V_final;
     
    n_region = size(R,1);
    edges_sorted = [];
    
    for i = 1:n_region
        indices = R{i};  
        edges = sort_position(img_binaire,V(indices,:),contour);
        edges_sorted = [edges_sorted; edges];
    end

    skeleton = edges_sorted;

end

function position_sorted = sort_position(img_binaire,positions,contour)
    n = size(positions,1);
    [nb_row,nb_col] = size(img_binaire);
    mask = repmat(zeros(n,1),1,2);

    for i=1:n
        x = floor(positions(i,1));
        y = floor(positions(i,2));

        if x > nb_row || y > nb_col || x <= 0 || y <= 0
            mask(i,:) = 0;
        else
            mask(i,:) = img_binaire(x,y)~= 0 && ~ismember([x y],contour,'rows');
        end
    end

    position_sorted = reshape(positions(logical(mask)),[],2);
end




