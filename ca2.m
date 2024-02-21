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
figure(1);imshow(x1/255,[]);
figure(1);imshow(x2/255,[]);
figure(1);imshow(x3/255,[]);
%The third one looked kind of worse

% 2. rotate an image all the way round (1.5 points)
% read in an image (clock.raw) in RAW format
% Note: RAW means no header (imread does not work)
% and therefore you need to specify the spatial and bit-depth resolution in
% the input - e.g., 'uchar' means 8bps image 
%[write a matlab function names read_raw.m to handle the read-in
% of raw data into MATLAB]
% syntax: function x=read_raw(name,fmt,height,width)
% Hint: you need to know how to use MATLAB function 'fread' 
im=read_raw('clock.raw','uchar',512,512);
% use the half-size image so it can run faster
x=double(imresize(im,.5));
whos x;
y=x;
whos y;
% continously rotate image by 30-deg for 12 times (so image will return to
% its original position)
for i=1:12
    imrotate(y,30);
end
whos y;
figure(2);imshow([x y]/255,[]);
% Question: what do you observe from the comparison between the original
% and rotated clock image? What do you think contribute to the quality
% degradation after consecutive rotation? 
% Hint: this example shows the difference between continuous and discrete
% spaces (information loss is inevitable when you interpolate missing
% pixels).
%The second image looks grayer

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
% pinch-effect fun mirror 
rr=r-100;cc=c-100;
a=1.2; % a controls the distortion effect
r2=100+sign(rr).*abs(rr).^a;
c2=100+sign(cc).*abs(cc).^a;
z=griddata(r2,c2,x,r,c,'cubic');
imshow([x y z],[]);
%<use your imagination to create a cool distorted image!>
% Why does he look like ET


% Part 2: Image enhancement experiments (5 points)

% 1. calculate the histogram of a given image (2 points)
x=double(imread('cube.tif'));
%[write a matlab function names my_hist.m to calculate the histogram
%for a given image]
h_x=my_hist(x,256);
whos h_x;
% now call the hist function provided by matlab
h_ref=hist(x(:),1:256);
whos h_ref;
figure(11); histogram(h_ref); figure(12); histogram(h_x);
% compare the two results
%<display the two histograms side by side> 
%{do they look similar?}
%The histograms are a match

% 2. enhancement of a microarray image (1 point)
x=double(imread('microarray.png'));
% >help histeq 
x_enh1=histeq(uint8(x));
imshow(x_enh1,[]);
% >help adapthisteq 
x_enh2=adapthisteq(uint8(x));
imshow(x_enh2/255,[]);
 %{what is the difference between two enhanced images?}
 %The first one is a lot brighter, the adapthisteq is dark
 
% 3. histogram matching (1 point)
% Learn how to use histeq function to process an input image A such that
% the histogram of the output matches that of a target image B
A=(imread('cube.tif'));
B=(imread('cameraman.tif'));
% create a new image (A_modified) such its histogram is similar to that
% of image B (they won't be identical due to low dynamic range)
A_mod=imhistmatch(A/255,B/255)*255;
A_modified=histeq(A,imhist(B));
imshow(A_modified/255,[]);
%imshow(A_mod/255,[]);
hA=hist(A_modified(:),1:256);hB=hist(B(:),1:256);
i=1:256;plot(i,hA,i,hB);

% 4. where is the teapot? (1 point)
% try to apply what you have learned to enhance a poor-quality
% image due to low-resolution and low-illumination (teapot.png). 
% Hint: you might want to combine image enhancement with image interpolation.
A=imread('teapot.png');
%
%A_hist = histeq(A);
%imshow(A_hist);%
%whos A_hist;
%for k = size(A,3):-1:1
%    A2(:,:,k) = interp2(A(:,:,k),'nearest'); %interpolation
%end
%whos A2;
%<your codes go here and name the enhanced image B>
%A_interp = interp2(A2,'nearest');
%B=A_hist;
%B = interp2(double(A_hist),'nearest')
% side-by-side comparison
% Load the low-quality image
lowResImage = imread('teapot.png');

% Convert the image to double for processing
lowResImage = double(lowResImage);

% Increase image resolution using interpolation (bicubic interpolation)
highResImage = imresize(lowResImage, 2, 'bicubic');

% Enhance image contrast using histogram equalization
highResImage = histeq(highResImage);

% Increase image brightness and adjust contrast
highResImage = imadjust(highResImage, [0.2 0.8], [0 1]);

% Display the results
figure;
subplot(1, 2, 1);
imshow(lowResImage);
title('Low-Resolution Image');
B = highResImage;
subplot(1, 2, 2);
imshow(highResImage);
title('Enhanced Image');

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

