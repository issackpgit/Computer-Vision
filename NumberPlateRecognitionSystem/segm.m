function [ L,num, testImg ] = segm( img )
%SEGM Summary of this function goes here
%   Detailed explanation goes here

%removing components below 150 px
testImg = bwareaopen(img,150);

%making changes to match the template we will be using
testImg = ones(size(testImg,1),size(testImg,2)) - testImg;
[L,num]=bwlabel(testImg);

%using bounding boxes to separate out individual charcters.
boxes=regionprops(L,'BoundingBox');
hold on
for n=1:size(boxes,1)
  rectangle('Position',boxes(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

figure



