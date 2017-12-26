clear
im1c = imread('house1.jpg');
im2c = imread('house2.jpg');
im1 = im2double(im1c);
im1 = rgb2gray(im1);
im2 = im2double(im2c);
im2 = rgb2gray(im2);

[cim, r, c]=harris(im1, 2,0.01,1.5,0);
[cim2, r2, c2]=harris(im2, 2,0.01,1.5,0);
num =100;
neighborsize=3;

%-------Reference:Stackoverflow------------
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

 neighbors1 = zscore(neighbors1')';
 neighbors2 = zscore(neighbors2')';

distance = dist2(neighbors1, neighbors2);

[~,I] = sort(distance(:));

[nrr1, ncc1] = ind2sub(size(distance),I(1:num));
   
points1(:,:)=[r(nrr1),c(nrr1)];
points2(:,:)=[r2(ncc1),c2(ncc1)];

[F,Fi, matches,residual] = ransacpart2(points1,points2);

% matches(:,:,:,:) = [points1(:,1),points1(:,2),points2(:,1),points2(:,2)];
 N = size(matches,1);
imshow([im1 im2]); hold on;
plot(points1(:,1), points1(:,2), '+r');
plot(points2(:,1)+size(im1,2), points2(:,2), '+r');
line([points1(:,1) points2(:,1) + size(im1,2)]', [points1(:,2) points2(:,2)]', 'Color', 'r');
%  pause;


% first, fit fundamental matrix to the matches
% F = fit_fundamental(matches); % this is a function that you should write
L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,1:2) ones(N,1)],2);
closest_pt = matches(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
clf;
imshow(im1); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) closest_pt(:,1)]', [matches(:,2) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');

distance = distpointline(matches(:,1:2), pt1, pt2);