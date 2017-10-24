im = imread('../data/d.jpg');
im = im2double(im);
im = rgb2gray(im);

    sigma       = 2;             
    k           = 1.35; 
    sigmalimit  = 16;             
    threshold   = .005;
    
    n=sigmalimit-3;
    h = size(im,1);
    w = size(im,2);

    scale_space = zeros(h, w, n);
    hsize = 2*ceil(3*sigma)+1;
   
    
% %     Downsampling the image
  log =  sigma^2 * fspecial('log', hsize, sigma);
      
      imnew = im;
   tic
      for i = 1:n
       imFiltered = imfilter(imnew, log, 'same', 'replicate');
       imFiltered = imFiltered .^ 2;
       scale_space(:,:,i) = imresize(imFiltered, size(im));    
       imnew = imresize(im, 1/(k^i), 'bicubic');
   end
   toc; 

maxsupressedSpace = zeros(h, w, n);
for i = 1:n
    maxsupressedSpace(:,:,i) = ordfilt2(scale_space(:,:,i), 9, ones(3));
end

for i = 1:n
   maxsupressedSpace(:,:,i) = max(maxsupressedSpace,[],3);
end

 
 maxsupressedSpace = maxsupressedSpace .* (maxsupressedSpace == scale_space);

 
r1 = [];   
c1 = [];   
rad = [];
for i=1:n
    [r, c] = find(maxsupressedSpace(:,:,i) >= threshold);
    numofBlobs = length(r);
    radii =  sigma * k^(i-1) * sqrt(2); 
    radii = repmat(radii, numofBlobs, 1);
    r1 = [r1; r];
    c1 = [c1; c];
    rad = [rad; radii];
end
    show_all_circles(im, c1, r1, rad, 'r', 1.5);