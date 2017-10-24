function [ warp_im2 ]  = warpA( im, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A

disp(out_size);
disp(out_size(1));
disp(out_size(2));
for j=1:out_size(1)
    for i=1:out_size(2)
        
        N = (A)\[i;j;1]; 
        x = round(N(1));
        y = round(N(2));
        if(x>=1) && (x<out_size(2)) && (y>=1) && (y < out_size(1))
            warp_im2(j,i) = im(y,x);
        end
    end
end
end
