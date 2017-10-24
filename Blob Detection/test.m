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
    nmsupressedSpace = zeros(h, w, n);
    
 tic
      for i = 1:n
           sigmanew = sigma * k^(i-1);
           hsize = 2*ceil(3*sigmanew)+1; 
            log       =  sigmanew^2 * fspecial('log', hsize, sigmanew);
            filterResp = imfilter(im, log, 'same', 'replicate');
            filterResp = filterResp .^ 2; 
            scale_space(:,:,i) = filterResp;
                nmsupressedSpace(:,:,i) = ordfilt2(scale_space(:,:,i), 9, ones(3));
                                  
      end
  toc; 
  
  for i =1:n
    nmsupressedSpace(:,:,i) = max(nmsupressedSpace,[],3);     
  end
  

nmsupressedSpace = nmsupressedSpace .* (nmsupressedSpace == scale_space);

r1 = [];   
c1 = [];   
rad = [];
for i=1:n
    [r, c] = find(nmsupressedSpace(:,:,i) >= threshold);
    numofBlobs = length(r);
    radii =  sigma * k^(i-1) * sqrt(2); 
    radii = repmat(radii, numofBlobs, 1);
    r1 = [r1; r];
    c1 = [c1; c];
    rad = [rad; radii];
end
    show_all_circles(im, c1, r1, rad, 'r', 1.5);