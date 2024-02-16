%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ICSI471/571 Introduction to Computer Vision Spring 2024
% Copyright: Xin Li@2024
% Computer Assignment 2: Image Interpolation and Enhancement
% Due Date: Feb. 22, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General instructions: 
% 1. Wherever you see a pair of <...>, you need to replace <>
% by the MATLAB code you come up with
% 2. Wherever you see a pair of [...], you need to write a new MATLAB
% function with the specified syntax
% 3. Wherever you see a pair of {...}, you need to write your answers as
% MATLAB annotations, i.e., starting with %

% The objective of this assignment is to play with various image
% interpolation and enhancement related MATLAB functions (easy and fun)
% MATLAB functions: imresize, imrotate, griddata  

% Part I: Image interpolation experiments (5 points)
% 1. Compare different digital zooming techniques (1.5 point)
x=double(imread('oil_painting.bmp'));
% check the spatial resolution (width and height) of the image
whos x
% 1. increase the image resolution by a factor of two 
% and compare three different techniques: bilinear, bicubic and NEDI (1.5 points)
% Note: you might have used imresize before but here you need to
% know how to use advanced option of imresize which allows you to choose
% which interpolation method to use
x1=  imresize(x,2,'bilinear'); %bilinear
x2=imresize(x,2,'bicubic'); %bicubic
% You are given sri_color.m which implements NEDI 
% learn how to use this function (e.g., what is the input parameter
% level about?)
% Note: This method runs slower than the previous two
tic;x3=sri_color(x,1);toc;
% 2. Compare the visual quality (note that side-by-side is not always
% the best solution; sometimes frame-by-frame works better)
figure(1);imshow(x1/255,[]);pause;
figure(1);imshow(x2/255,[]);pause;
figure(1);imshow(x3/255,[]);

% 2. rotate an image all the way round (1.5 points)
% read in an image (clock.raw) in RAW format
% Note: RAW means no header (imread does not work)
% and therefore you need to specify the spatial and bit-depth resolution in
% the input - e.g., 'uchar' means 8bps image 
%[write a matlab function names read_raw.m to handle the read-in
% of raw data into MATLAB]
% syntax: function x=read_raw(name,fmt,height,width)
% Hint: you need to know how to use MATLAB function 'fread' 
im=read_raw('clock.raw','uchar',512,512)';
% use the half-size image so it can run faster
x=double(imresize(im,.5));
y=x;
% continously rotate image by 30-deg for 12 times (so image will return to
% its original position)
for i=1:12
    y=imrotate(y,30);
end
figure(2);imshow([x y]/255,[]);
% Question: what do you observe from the comparison between the original
% and rotated clock image? What do you think contribute to the quality
% degradation after consecutive rotation? 
% Hint: this example shows the difference between continuous and discrete
% spaces (information loss is inevitable when you interpolate missing
% pixels).
%{your answer goes here}

% 3. digital fun mirror and really cool to try it out (2 points)
% work with the image of Bill Gates or Steve Jobs or anyone else
x=double(imresize(rgb2gray(imread('bill_gates.jpg')),.5));
[M,N]=size(x);
[r,c]=meshgrid(1:N,1:M);
% randomly disturb the row coordinates
w=randn(1,M);
r1=r+repmat(w,N,1)';
y=griddata(r1,c,x,r,c,'cubic');
imshow(y,[]);
%<use your imagination to create a cool distorted image!>

% Part 2: Image enhancement experiments (5 points)

% 1. calculate the histogram of a given image (2 points)
x=double(imread('cube.tif'));
%[write a matlab function names my_hist.m to calculate the histogram
%for a given image]
h_x=my_hist(x,256);
% now call the hist function provided by matlab
h_ref=hist(x(:),1:256);
% compare the two results
%<display the two histograms side by side> 
%{do they look similar?}

% 2. enhancement of a microarray image (1 point)
x=double(imread('microarray.png'));
% >help histeq 
%x_enh1=<enhance this image by histogram equalization>;
imshow(x_enh1/255,[]);
% >help adapthisteq 
%x_enh2=<enhance this image by adaptive histogram equalization>;
imshow(x_enh2/255,[]);
 %{what is the difference between two enhanced images?}
 
% 3. histogram matching (1 point)
% Learn how to use histeq function to process an input image A such that
% the histogram of the output matches that of a target image B
A=double(imread('cube.tif'));
B=double(imread('cameraman.tif'));
% create a new image (A_modified) such its histogram is similar to that
% of image B (they won't be identical due to low dynamic range)
%A_modified=<your code enters here>;
imshow(A_modified/255,[]);
hA=hist(A_modified(:),1:256);hB=hist(B(:),1:256);
i=1:256;plot(i,hA,i,hB);

% 4. where is the teapot? (1 point)
% try to apply what you have learned to enhance a poor-quality
% image due to low-resolution and low-illumination (teapot.png). 
% Hint: you might want to combine image enhancement with image interpolation.
A=double(imread('teapot.png'));
%<your codes go here and name the enhanced image B>
% side-by-side comparison
subplot(1,2,1);imshow(A/255,[]);
subplot(1,2,2);imshow(B/255,[]);

% Bonus Part: Valentine's Challenge (1 point)
x=imread('castle_orig.pbm');
y=imread('castle_damaged.pbm');
figure(3);imshow([x y]);
% You are given a clean reference image 'castle_orig.pbm' and a damaged
% version 'castle_damaged.pbm'. Please use >help bwmorph to teach yourself
% a set of morphlogical filtering tools for binary images. You need to come
% up with a matlab function castle_repair.m with the following syntax:
xx=castle_repair(y);
% You can use the supplied judging tool castle_test.m to see how good
% is your repaired image xx
castle_test(x,xx)

