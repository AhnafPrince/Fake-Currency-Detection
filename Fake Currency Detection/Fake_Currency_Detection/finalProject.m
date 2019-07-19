%% //Read in images
clear all;
close all;

fid = fopen('imageLoc.txt','r')
imageLoc = fgetl(fid);

%imageLoc = '500_new.jpg';
Ireal2 = imread(imageLoc); % Real #2
%{
Ireal = imread('100_real_.jpg'); % Real
Ireal2 = imread('500_new.jpg'); % Real #2
Ifake = imread('500_fake.jpg'); % Fake
Ifake2 = imread('fake2.jpg'); % Fake #2
%}

% //Resize so that we have the same dimensions as the other images
%Ifake2 = imresize(Ifake2, [160 320], 'bilinear');

%% //Extract the black strips for each image

blackStripReal2 = Ireal2(:,35:45,:);
%{
blackStripReal = Ireal(:,39:48,:);
blackStripReal2 = Ireal2(:,35:45,:);
blackStripFake = Ifake(:,35:45,:);
blackStripFake2 = Ifake2(:,195:215,:);
%}
%{

figure(1);
subplot(1,4,2);
imshow(blackStripReal2);
title('Strip Image');

%}
%{
subplot(1,4,1);
imshow(blackStripReal);
title('Real');


subplot(1,4,2);
imshow(blackStripReal2);
title('Real #2');

subplot(1,4,3);
imshow(blackStripFake);
title('Fake');

subplot(1,4,4);
imshow(blackStripFake2);
title('Fake #2');

%}

%% //Convert into grayscale then threshold

blackStripReal2 = rgb2gray(blackStripReal2);
%{
blackStripReal = rgb2gray(blackStripReal);
blackStripReal2 = rgb2gray(blackStripReal2);
blackStripFake = rgb2gray(blackStripFake);
blackStripFake2 = rgb2gray(blackStripFake2);
%}
%{
figure(2);
subplot(1,4,2);
imshow(blackStripReal2);
title('Grayscale of the Strip');
%}
%{
subplot(1,4,1);
imshow(blackStripReal);
title('Real');

subplot(1,4,2);
imshow(blackStripReal2);
title('Real #2');

subplot(1,4,3);
imshow(blackStripFake);
title('Fake');

subplot(1,4,4);
imshow(blackStripFake2);
title('Fake #2');
%}

%% //Threshold using about intensity 30

blackStripReal2BW = ~im2bw(blackStripReal2, 30/255);
%{
blackStripRealBW = ~im2bw(blackStripReal, 30/255);
blackStripReal2BW = ~im2bw(blackStripReal2, 30/255);
blackStripFakeBW = ~im2bw(blackStripFake, 30/255);
blackStripFake2BW = ~im2bw(blackStripFake2, 30/255);
%}
%{
figure(3);
subplot(1,4,2);
imshow(blackStripReal2BW);
title('Threshold');
%}
%{
subplot(1,4,1);
imshow(blackStripRealBW);
title('Real');

subplot(1,4,2);
imshow(blackStripReal2BW);
title('Real #2');

subplot(1,4,3);
imshow(blackStripFakeBW);
title('Fake');

subplot(1,4,4);
imshow(blackStripFake2BW);
title('Fake #2');
%}

%% //Area open the image


%figure(4);

areaopenReal2 = bwareaopen(blackStripReal2BW, 100);
%{
subplot(1,4,2);
imshow(areaopenReal2);
title('Open the image');
%}
%{
areaopenReal = bwareaopen(blackStripRealBW, 100);
subplot(1,4,1);
imshow(areaopenReal);
title('Real');

areaopenReal2 = bwareaopen(blackStripReal2BW, 100);
subplot(1,4,2);
imshow(areaopenReal2);
title('Real #2');

subplot(1,4,3);
areaopenFake = bwareaopen(blackStripFakeBW, 100);
imshow(areaopenFake);
title('Fake');
subplot(1,4,4);

areaopenFake2 = bwareaopen(blackStripFake2BW, 100);
imshow(areaopenFake2);
title('Fake #2');
%}

%% //Post-process

se = strel('square', 5);
BWImageCloseReal2 = imclose(areaopenReal2, se);
%{
BWImageCloseReal = imclose(areaopenReal, se);
BWImageCloseReal2 = imclose(areaopenReal2, se);
BWImageCloseFake = imclose(areaopenFake, se);
BWImageCloseFake2 = imclose(areaopenFake2, se);
%}
%{
figure(5);
subplot(1,4,2);
imshow(BWImageCloseReal2);
title('BWImageCloseReal');
%}
%{
subplot(1,4,1);
imshow(BWImageCloseReal);
title('Real');

subplot(1,4,2);
imshow(BWImageCloseReal2);
title('Real #2');

subplot(1,4,3);
imshow(BWImageCloseFake);
title('Fake');

subplot(1,4,4);
imshow(BWImageCloseFake2);
title('Fake #2');
%}

%% //Count the total number of objects in this strip

[~,countReal2] = bwlabel(BWImageCloseReal2);
%{
[~,countReal] = bwlabel(BWImageCloseReal);
[~,countReal2] = bwlabel(BWImageCloseReal2);

[~,countFake] = bwlabel(BWImageCloseFake);
[~,countFake2] = bwlabel(BWImageCloseFake2);
%}

disp(['The total number of black lines for the note is: ' num2str(countReal2)]);
%{
disp(['The total number of black lines for the real note is: ' num2str(countReal)]);
disp(['The total number of black lines for the real note is: ' num2str(countReal2)]);
disp(['The total number of black lines for the fake note is: ' num2str(countFake)]);
disp(['The total number of black lines for the second fake note is: ' num2str(countFake2)]);
%}

fid = fopen('verdict.txt','wt');
if (countReal2) == 1
    fprintf(fid, 'Real');
else
    fprintf(fid, 'Fake');
end
