function d = distpointline(pt, v1, v2)
n = size(pt,1);
x1 = [pt(:,1), pt(:,2), ones(n,1)];
x2 = [v1(:,1), v1(:,2), ones(n,1)];
x3 = [v2(:,1), v2(:,2), ones(n,1)];
        
for i = 1:n
      a = x2(i,:) - x3(i,:);
      b = x1(i,:) - x3(i,:);
      d(i,:) = norm(cross(a,b)) / norm(a);
end

d =mean(d(:,:).^2);
