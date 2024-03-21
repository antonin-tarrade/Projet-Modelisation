function barycentre = barycentre(T, i, poids)

points = T.X(T.Triangulation(i,:),:);

points_pond = points .* poids';

barycentre = sum(points_pond, 1) / 4;

keyboard

end