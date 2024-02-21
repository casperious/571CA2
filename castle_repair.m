function x = castle_repair(img)
%CASTLE_REPAIR Summary of this function goes here
%   Detailed explanation goes here
x1 = bwmorph(img,'fill');
x2 = bwmorph(x1,'majority');
x3 = bwmorph(x2,'clean');
x = bwmorph(x3,'close');
x = bwmorph(x,'fill');
figure();imshow(x);
end

