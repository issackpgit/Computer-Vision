function [rgbResult] = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a
%       color image, compute the best aligned result with minimum
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%       corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired

%% Write code here

Y = red - green;
ssd = sum(Y(:).^2);

Y1 = red - blue;
ssd1 = sum(Y1(:).^2);

SSD =0;

for i = -30 : 1 : 30
   
    x= circshift(green,i,1);
    X=red-x;
    SSD =sum(X(:).^2);
    if SSD<ssd
        ssd = SSD;
        temp = i;
    end
end

for i = -30 : 1 : 30
   
    x1= circshift(blue,i,1);
    X1=red-x1;
    SSD1 =sum(X1(:).^2);
    if SSD1<ssd1
        ssd1 = SSD1;
        temp1 = i;
    end
end

newgreen= circshift(green,temp,1);
newblue = circshift(blue,temp1,1);

rgbResult = cat (3,red,newgreen,newblue);

end
