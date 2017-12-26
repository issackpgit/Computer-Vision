%Reference http://www.leet.it/home/giusti/teaching/matlab_sessions/stitching/stitch.html
function stitch(im1c, H, im2c)
   
    T = maketform('projective', H);
    [im1t,xdataim1t,ydataim1t]=imtransform(im1c,T);
%      imshow(im1t);
    xdataout=[min(1,xdataim1t(1)) max(size(im2c,2),xdataim1t(2))];
    ydataout=[min(1,ydataim1t(1)) max(size(im2c,1),ydataim1t(2))];
    im1t=imtransform(im1c,T,'XData',xdataout,'YData',ydataout);
    im2t=imtransform(im2c,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
%     [newh, neww, tmp] = size(im1t);
%     resultimg = im1t;

ims=max(im1t,im2t);
imshow(ims);

end