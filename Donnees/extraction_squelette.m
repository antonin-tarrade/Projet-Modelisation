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

    [nb_row, nb_col] = size(img_binaire);
    
    contour = bwtraceboundary(img_binaire,P,"NW");
    
    if(~isempty(contour))
        figure;
        imshow(img_binaire);
        hold on;
        plot(contour(:,2), contour(:,1), 'g', 'LineWidth', 2);
    end

    dt = delaunayTriangulation(contour(:,2),contour(:,1));
    
    [V, R] = voronoiDiagram(dt);

%     V_sorted = zeros(size(V,1),1);
% 
%      for i=1:(size(V,1)) 
%          v1 = floor(floor(V(i,1)));
%          v2 = floor(V(i,2));
%         if v1 > nb_row || v2 > nb_col || v1 <= 0 || v2 <= 0
%             V_sorted(i) = 0;
%         else
%             V_sorted(i) = img_binaire(v1,v2)~= 0;
%         end
%     end 

    scatter(V(:, 1), V(:, 2), 'm', '+');
    hold off;
end

