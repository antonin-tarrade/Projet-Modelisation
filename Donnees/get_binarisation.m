function [bin] = get_binarisation(labels, centers, K)

row = size(labels, 1);
col = size(labels, 2);
bin = zeros(row, col);

for k = 1:K
    r = centers(k, 3);
    g = centers(k, 4);
    b = centers(k, 5);
    [l, ~, ~] = rgb2lab([r g b]);

    if r > b && r > 30     % Seuil
        bin(labels == k) = 255;
    end
end



end