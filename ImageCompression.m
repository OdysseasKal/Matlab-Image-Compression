% Created by Odysseas Kalatzis on 05/04/2019

clear all;
Image = imread("House.png");
YCbCr = rgb2ycbcr(Image); % Converting from RGB to YCbCR.

Y = YCbCr (:,:,1); % Luminosity.
Cb = YCbCr (:,:,2); % Blue-difference chroma component.
Cr = YCbCr (:,:,3); % Red-difference chroma component.

% 2d Discrete cosine transform and its inverse.
transform = @(block_struct) dct2(block_struct.data); 
inv_transform = @(block_struct) idct2(block_struct.data);

% Converting to 8 by 8 blocks and applying the transform
Y_block = blockproc(Y, [8 8], transform);
Cb_block = blockproc(Cb, [8 8], transform);
Cr_block = blockproc(Cr, [8 8], transform);

% Finding and changing anything less than |x| to 0.
Y_depth = find(abs(Y_block) < 20);
Cb_depth = find(abs(Cb_block) < 150);
Cr_depth = find(abs(Cr_block) < 150);

Y_block(Y_depth) = zeros(size(Y_depth));
Cb_block(Cb_depth) = zeros(size(Cb_depth));
Cr_block(Cr_depth) = zeros(size(Cr_depth));

% Applying the inverse transformation.
Y_compressed = uint8(blockproc(Y_block, [8 8], inv_transform));
Cb_compressed = blockproc(Cb_block, [8 8], inv_transform);
Cr_compressed = blockproc(Cr_block, [8 8], inv_transform);

% Combining Y with the compressed Cb and Cr, and then converting to RGB.
compressed_RGB = ycbcr2rgb(cat(3,Y_compressed,Cb_compressed,Cr_compressed));

imwrite(compressed_RGB, "Compressed-House.png");
