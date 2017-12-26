  function F = fit_fundamental(matches)
% matches = load('house_matches.txt'); 
n = size(matches, 1);        
A = zeros(n, 9);

x1 = [matches(:,1), matches(:,2), ones(n,1)];
x2 = [matches(:,3), matches(:,4), ones(n,1)];


[x1, T1] = normalise2dpts(x1');
[x2, T2] = normalise2dpts(x2');

for i = 1:n
%           p1 = matches(i,1:2);
%            p2 = matches(i,3:4);

         p1 = x1(1:2,i);
          p2 = x2(1:2,i);
        A(i, :) = [p1(1)*p2(1) p1(1)*p2(2) p1(1) p1(2)*p2(1) p1(2)*p2(2) p1(2) p2(1) p2(2) 1];
end

[U,D,V] = svd(A); 
    f = V(:,9);    
    F = reshape(f, 3, 3);  
    
    [U,D,V] = svd(F,0);
     F = U*diag([D(1,1) D(2,2) 0])*V';
    
      F = T2'*F*T1;
  end
