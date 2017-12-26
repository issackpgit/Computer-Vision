clc;
clear;
img = imread ('data/np5.jpg'); 
figure(1); imshow(img);

if size(img,3)==3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% Dilate and Erode Image in order to remove noise

[r c] = size(grayImg);

for i=2:r-1
    for j=2:c-1
     if grayImg(i,j)<40
        grayImg(i,j)=0;
     end
    end
end

for i=1:r
    for j=1:c
      if grayImg(i,j)>200
       grayImg(i,j)=255;
      end
    end
end

dilatedImg = grayImg;

for i = 1:r
    for j = 2:c-1
        temp = max(grayImg(i,j-1), grayImg(i,j));
        dilatedImg(i,j) = max(temp, grayImg(i,j+1));
    end
end

img = dilatedImg;
figure(4); imshow(img);


% PROCESS EDGES IN HORIZONTAL DIRECTION
hdiff = 0;
hdiff = uint32(hdiff);

total_sum = 0;
max_horiz = 0;
maximum = 0;
for i = 2:c
    sum = 0;
    for j = 2:r
        if(img(j, i) > img(j-1, i))
            hdiff = uint32(img(j, i) - img(j-1, i));
        else
            hdiff = uint32(img(j-1, i) - img(j, i));
        end
        if(hdiff > 30)
           sum = sum + hdiff;
        end
    end
    hhist(i) = sum;
    if(sum > maximum)
        max_horiz = i;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end

 average = total_sum/c;
 
 figure(5);
 subplot(3,1,1);
 plot (hhist);
 title('Horizontal Edge Processing Histogram');
 xlabel('Column Number ->');
 ylabel('Difference ->');

 % Smoothen the Horizontal Histogram by applying Low Pass Filter

shhist = hhist;
for i = 21:(c-21)
    sum = 0;
    for j = (i-20):(i+20)
        sum = sum + hhist(j);
    end
    shhist(i) = sum / 41;
end

 subplot(3,1,2);
 plot (shhist);
 title('Histogram after passing through Low Pass Filter');
 xlabel('Column Number ->');
 ylabel('Difference ->');

% Filter out Horizontal Histogram Values by applying Dynamic Threshold

for i = 1:c
    if(shhist(i) < 1.35 * average)
        shhist(i) = 0;
        for j = 1:r
            img(j, i) = 0;
        end
    end
end
 subplot(3,1,3);
 plot (shhist);
 title('Histogram after Filtering');
 xlabel('Column Number ->');
 ylabel('Difference ->');
 
 figure(9),imshow(img);

% PROCESS EDGES IN VERTICAL DIRECTION

vdiff = 0;
vdiff = uint32(vdiff);

total_sum = 0;
max_vert = 0;
maximum = 0;

for i = 2:r
    sum = 0;
    for j = 2:c 
        if(img(i, j) > img(i, j-1))
            vdiff = uint32(img(i, j) - img(i, j-1));
        end
        if(img(i, j) <= img(i, j-1))
            vdiff = uint32(img(i, j-1) - img(i, j));
        end
        if(vdiff > 20)
            sum = sum + vdiff;
        end
    end
    vhist(i) = sum;
    if(sum > maximum)
        max_vert = i;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end

average = total_sum / r;

 figure(6)
 subplot(3,1,1);
 plot (vhist);
 title('Vertical Edge Processing Histogram');
 xlabel('Row Number ->');
 ylabel('Difference ->');

% Smoothen the Vertical Histogram by applying Low Pass Filter

sum = 0;
svhist = vhist;
for i = 21:(r-21)
    sum = 0;
    for j = (i-20):(i+20)
        sum = sum + vhist(j);
    end
    svhist(i) = sum / 41;
end

 subplot(3,1,2);
 plot (svhist);
 title('Histogram after passing through Low Pass Filter');
 xlabel('Row Number ->');
 ylabel('Difference ->');

 % Filter out Vertical Histogram Values by applying Dynamic Threshold

for i = 1:r
    if(svhist(i) <1.5 *average)
        svhist(i) = 0;
        for j = 1:c
            img(i, j) = 0;
        end
    end
end

 subplot(3,1,3);
 plot (svhist);
 title('Histogram after Filtering');
 xlabel('Row Number ->');
 ylabel('Difference ->');
 figure(7), imshow(img);

 % Find Probable candidates for Number Plate

j = 1;
for i = 2:c-2
    if((shhist(i-1) == 0) || (shhist(i+1) == 0))
        column(j) = i;
        j = j+1;
    end
end
j = 1;
for i = 2:r-2
    if((svhist(i-1) == 0) || (svhist(i+1) == 0))
        row(j) = i;
        j = j+1;
    end
end

 column_size = size(column,2);
 if(mod(column_size, 2))
     column(column_size+1) = c;
 end
 row_size = size(row,2);
 if(mod(row_size, 2))
     row(row_size+1) = r;
 end

% Region of Interest Extraction

for i = 1:2:row_size
    for j = 1:2:column_size
      if(((max_horiz >= column(j) && max_horiz <= column(j+1)) && (max_vert >=row(i) && max_vert <= row(i+1)))==0)
        for maximum = row(i):row(i+1)
         for n = column(j):column(j+1)
          img(maximum, n) = 0;
         end
        end
      end
    end
end

figure(8), imshow(img);
imshow(img);
flagm = 0;

% Cropping the image to a numberplate

threshold = graythresh(img);
imbw =imbinarize(img,threshold);
[L num]=bwlabel(imbw);

[row col]=size(imbw);
maximum=0;
pos=0;

for i=1:num
    counter=0;
    for j=1:row
        for k=1:col
            if L(j,k)==i
                counter=counter+1;
            end
        end
    end
    if counter>=maximum
      maximum=counter;
      pos=i;
    end
end

[rr cc]=find(L==pos);
finalimg=img(min(rr):max(rr),min(cc):max(cc));

figure(9), imshow(finalimg);
imwrite(finalimg,'plate.jpg');

usingOCR(finalimg);
[loc, num, testImg] = segm(finalimg);

final_output = recog(loc, num, testImg);


file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);                     
     winopen('number_Plate.txt')