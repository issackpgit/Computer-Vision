function [bestH, bestinliers, residual] = ransac3(p1, p2)

    [n, ~] = size(p1);
    numofInliers = zeros(1000,1);
    
    bestH = [];
    bestnuminliers = 0;
    
    img1 = [p1(:,2), p1(:,1), ones(200,1)];
    img2 = [p2(:,2), p2(:,1), ones(200,1)];
    
    for i = 1 : 1000;
    
        randindex = randsample(n, 4);
        x = img1(randindex, :);
        y = img2(randindex, :);
            
        Hi = computeH(x, y);
        
        tmp = img1 * Hi;
        distX = tmp(:,1) ./ tmp(:,3) - img2(:,1);
        distY = tmp(:,2) ./ tmp(:,3) - img2(:,2);
        diff = distX .^2 + distY .^2;
        
  
        inliers = find(diff < 10);      

        numofInliers(i) = length(inliers);
  
        if bestnuminliers < numofInliers(i)
            bestH = Hi;
            bestinliers = inliers;
            bestnuminliers = numofInliers(i);
            residual = mean(diff(inliers));
         end
        
    end

    
end