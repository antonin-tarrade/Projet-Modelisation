close all;
clear all;

img_binaire = rgb2gray(imread("dino_binaire_test.png"));

[nb_row, nb_col] = size(img_binaire);

for i=1:nb_row
    for j=1:nb_col
        value = img_binaire(i,j);
        img_binaire(i,j) = adjust(value);
    end
end

squelette = extraction_squelette(img_binaire);

function val = adjust(gray_scale)
    [~,ind] = min ([gray_scale 255-gray_scale]);
    if ind == 1 
        val = 0;
    else
        val = 255;
    end
end

