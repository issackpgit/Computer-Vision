function [ char_found ] = recog( loc, num, testImg )
%RECOG Recognize the characters based on the provided templates

%uploading template files
imgs = dir('data/Characters');
imgs(strncmp({imgs.name}, '.', 1)) = [];
fileNum = length(imgs);
imgfile=cell(fileNum,1);
for i = 1 : fileNum
    imgfile{i} = imread(fullfile('data/Characters/',imgs(i).name));
end

%uploading template names
fileNames = cell(fileNum,1);
for i = 1 : fileNum
    [path,name,ext] = fileparts(imgs(i).name);
    fileNames{i} = name;
end

char_found=[];

%reshaping the charcter images to template image size
for n=1:num
  [r,c] = find(loc==n);
  charSeg=testImg(min(r):max(r),min(c):max(c));
  charSeg=imresize(charSeg,[42,24]);
  imshow(charSeg)
  corrVal=[ ];

totalLetters=size(imgfile,1);

%comparing the correlation value between charcter in the image and
%available templates
 for k=1:totalLetters
    
    compVal=corr2(imgfile{k},charSeg);
    corrVal=[corrVal compVal];
    
 end
 if max(corrVal)>.40
 lbId=find(corrVal==max(corrVal));
 charLabel = fileNames{lbId};
char_found=[char_found charLabel];
end
end







