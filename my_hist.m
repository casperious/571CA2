function x = my_hist(img,size)
%MY_HIST Summary of this function goes here
%   Detailed explanation goes here
whos img
for i=1:256
    h(i)=sum(sum(img == i-1));
end
x = h;
end

