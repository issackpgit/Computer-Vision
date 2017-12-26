clear
camera1 = load('library1_camera.txt');
camera2 = load('library2_camera.txt');
matches = load('library_matches.txt');

for j = 1:size(matches)
    A(1,:) = matches(j,1)*camera1(3,:) - camera1(1,:);
    A(2,:) = matches(j,2)*camera1(3,:) - camera1(2,:);
    A(3,:) = matches(j,3)*camera2(3,:) - camera2(1,:);
    A(4,:) = matches(j,4)*camera2(3,:) - camera2(2,:);
    
    [U,D,V] = svd(A); 
    x(:,j)= V(:,4);  
    x(:,j) = x(:,j)/x(4,j);
end

[~, ~, V] = svd(camera1);
    cameracenter1 = V(:,end);
    cameracenter1 = cameracenter1 / cameracenter1(4)
    
    [~, ~, V] = svd(camera2);
    cameracenter2 = V(:,end);
    cameracenter2 = cameracenter2 / cameracenter2(4)

 plot3d(x',cameracenter1,cameracenter2); 

for i = 1:size(matches)
points1(:,i) = camera1*x(:,i);
points1(:,i)=points1(:,i)/points1(3,i);
end


for i = 1:size(matches)
points2(:,i) = camera2*x(:,i);
points2(:,i)=points2(:,i)/points2(3,i);
end

dist1 = pdist2(matches(:,1:2),points1(1:2,:)','euclidean');
dist2 = pdist2(matches(:,3:4),points2(1:2,:)','euclidean');

dis1 = trace(dist1.^2);
dis2 = trace(dist2.^2);

mean1 = dis1./size(matches,1);

mean2 = dis2./size(matches,1);