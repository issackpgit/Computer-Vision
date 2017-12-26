function [best_H,F, matches, residual] = ransacpart2(p1, p2)

    [n, ~] = size(p1);
    numofInliers = zeros(1000,1);
    
    best_H = [];
    best_num_inliers = 0;
    
    img1 = [p1(:,1), p1(:,2), ones(100,1)];
    img2 = [p2(:,1), p2(:,2), ones(100,1)];
    
    for i = 1 : 1000;
    
        randindex = randsample(n, 8);
        x = img1(randindex, :);
        y = img2(randindex, :);
            
        F = computeF(x, y);
      
for j =1 : 8
L(j,:) = (F * [x(j,:)'])'; 
end


for k = 1:8
numer = y(k,1)*L(k,1)+y(k,2)*L(k,2)+L(k,3);
den = sqrt(L(k,1).^2 + L(k,2).^2);
d(k,:) = abs(numer/den);
end




% L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3);
% for i =1 :4
% pt_line_dist(i,:) = sum(L(i,:) .* y(i,:),2);
% end
% closest_pt = y(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
% 
% pt1 = closest_pt - [L(:,2) -L(:,1)] * 10;
% pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;
% 
%          d1 = distpointline(y(:,1:2),pt1,pt2);
%          
%          for i =1 : 4
% L(i,:) = (F' * [y(i,:)'])'; 
% end
% 
% L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3);
% for i =1 :4
% pt_line_dist(i,:) = sum(L(i,:) .* x(i,:),2);
% end
% closest_pt = x(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
% 
% pt3 = closest_pt - [L(:,2) -L(:,1)] * 10;
% pt4 = closest_pt + [L(:,2) -L(:,1)] * 10;
%          
%          
%          
%           d2 = distpointline(x(:,1:2),pt3,pt4);
%           
%           d= d1+d2;

%         tmp = img1 * F;
%         distX = tmp(:,1) ./ tmp(:,3) - img2(:,1);
%         distY = tmp(:,2) ./ tmp(:,3) - img2(:,2);
%         diff = distX .^2 + distY .^2;
        
  
        inliers = find(d < 5);      

        numofInliers(i) = length(inliers);
  
        if best_num_inliers < numofInliers(i)
            best_H = F;
            best_num_inliers = numofInliers(i);
            residual = mean(diff(inliers));
             for w =1:numofInliers(i)
            matches(w,:,:,:) = [x(inliers(w),1),x(inliers(w),2),y(inliers(w),1),y(inliers(w),2)];
            end
         end
        
    end
    
end