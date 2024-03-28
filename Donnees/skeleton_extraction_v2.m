function [contour,vertices,sorted_vertices,skeleton] = skeleton_extraction_v2(img_binaire)
    % function EXTRACTION_SQUELETTE 
    % Renvois une matrice binaire indiquant quels points appartienent a l'axe
    % mediant de l'image originelle.
    %  Arguments : 
    %   img_binaire : Matrice binaire representant l'image segmentee (fond-forme) initiale 
    %  Retour : 
    %    squelette : Matrice binaire representant l'axe median (squelette) de
    %    l'image initiale

        [nb_rows,nb_cols] = size(img_binaire);
        P = get_initial_point(img_binaire);
        
        contour = bwtraceboundary(img_binaire,P,"N",8);
           
        [V,C] = voronoin(unique(contour,'rows'));

        % Supression des sommets en dehors de l'image
        inside_indices = V(:,1) >= 1 & V(:,1) <= nb_rows & V(:,2) >= 1 & V(:,2) <= nb_cols;
        V_inside = V(inside_indices,:);


        % On ne garde que les sommets compris dans le contour
        mask = roipoly(img_binaire,contour(:,2),contour(:,1));
        indices = sub2ind(size(mask),round(V_inside(:,1)),round(V_inside(:,2)));
        inside_dino = mask(indices);
        V_sorted = V_inside(inside_dino,:);
    
      % Creation de la matrice d'adjacence
        adjacence = zeros(size(V,1));
        for i=1:size(C,1)
            cells = C(i);
            cell = cells{1};
            n_cell = size(cell,2);
            for ind=1:n_cell
                next_ind = mod(ind, n_cell) + 1;

                if ismember(V(cell(ind),:),V_sorted,'rows') && ismember(V(cell(next_ind),:),V_sorted,'rows')
                    adjacence(cell(ind),cell(next_ind)) = 1;
                    adjacence(cell(next_ind),cell(ind)) = 1;
                end
            end
            
        end    

        vertices = V;
        sorted_vertices = V_sorted;
        skeleton = adjacence;
    
    end