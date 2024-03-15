function [label, prop] = plusProcheCentre(x, y, coef, im, num_image, K, centers)

r = double(im(x,y,1,num_image));
g = double(im(x,y,2,num_image));
b = double(im(x,y,3,num_image));
prop = [x y r g b];

min_dist = +inf;
label = 1;
for k = 1:K

    dist_xy = sqrt((x-centers(k,1))^2 + (y-centers(k,2))^2);

    dist_rgb = 0;
    for c = 1:3
        color = im(floor(centers(k,1)),floor(centers(k,2)),c,num_image);
        dist_rgb = dist_rgb + (prop(c+2)-double(color))^2;
    end
    dist_rgb = sqrt(dist_rgb);

    dist = dist_rgb + coef * dist_xy;

    if dist < min_dist
        min_dist = dist;
        label = k;
    end
end


