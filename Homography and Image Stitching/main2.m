clear
im1c = imread('../data/part1/uttower/left.jpg');
im2c = imread('../data/part1/uttower/right.jpg');
im1 = im2double(im1c);
im1 = rgb2gray(im1);
im2 = im2double(im2c);
im2 = rgb2gray(im2);

% imshow(im1);

[cim, r, c]=harris(im1, 2,0.1,1.5,0);
[cim2, r2, c2]=harris(im2, 2,0.1,1.5,0);
num =200;
neighborsize=3;

%-------------------
    num1 = length(r);
    neighbors1 = zeros(num1, (2 * neighborsize + 1)^2);
    
    padding1 = zeros(2 * neighborsize + 1); 
    padding1(neighborsize + 1, neighborsize + 1) = 1;
    paddedImg1 = imfilter(im1, padding1, 'replicate', 'full');

        for i = 1 : num1
        rr = r(i) : r(i) + 2 * neighborsize;
        cc = c(i) : c(i) + 2 * neighborsize;
        neighborhood = paddedImg1(rr, cc);
        vector1 = neighborhood(:);
        neighbors1(i,:) = vector1;
        end
    
    num2 = length(r2);
    neighbors2 = zeros(num2, (2 * neighborsize + 1)^2);
   
    padding2 = zeros(2 * neighborsize + 1); 
    padding2(neighborsize + 1, neighborsize + 1) = 1;
    paddedImg2 = imfilter(im2, padding2, 'replicate', 'full');

        for i = 1 : num2
        rr2 = r2(i): r2(i) + 2* neighborsize;
        cc2 = c2(i): c2(i) + 2* neighborsize;
        neighborhood2 = paddedImg2(rr2, cc2);
        vector2 = neighborhood2(:);
        neighbors2(i,:) = vector2;
        end
        
 %----------------------
         neighbors1 = zscore(neighbors1')';
         neighbors2 = zscore(neighbors2')';

distance = dist2(neighbors1, neighbors2);

[~,I] = sort(distance(:));

[nrr1, ncc1] = ind2sub(size(distance),I(1:num));
   
points1(:,:)=[r(nrr1),c(nrr1)];
points2(:,:)=[r2(ncc1),c2(ncc1)];

[H, inliers,residual] = ransac3(points1,points2);

 figure; imshow([im1 im2]); hold on; title('Inlier Matches');
 hold on; 
 plot(points1(inliers,2), points1(inliers,1),'yo'); 
 plot(points2(inliers,2)+ 1024, points2(inliers,1), 'yo'); 
 hold off;
stitch(im1c,H,im2c);
