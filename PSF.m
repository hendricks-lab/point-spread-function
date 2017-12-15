%% Point Spread Function

clc, clear all, close all;
tiff_file='*.tif';  % Identify files with .tif extension
tiff_file_1='NDSequence004-2.tif';
dtiff_intensity=dir(tiff_file); % A directory for tiff_file
pixelsize=106;

for m=1%:numel(dtiff_intensiy)
    image_info=imfinfo(tiff_file_1);    % Image info
    width_image=image_info(1).Width;    % Width of image
    height_image=image_info(1).Height;  % Height of image
    length_image=length(image_info);    % Length of image
    image_array=zeros(height_image,width_image,length_image,'double');  % Convert to 16-bit unsigned integer
    
    %for j=1
        for i=1:length_image
        image_array(:,:,i)=imread(tiff_file_1,'Index',i,'info',image_info); % 3D matrix containing gray values of the tif file
        imshow(image_array(:,:,i),[]);  % Show the image
        end
        
% Line profile of gray value along the distance   
[x_c,y_c]=ginput(2);    % Select two points of interest
x_c_line=[x_c(1),x_c(2)];   % Draws a line on x-axis
y_c_line=[y_c(1),y_c(2)];   % Draws a line on y-axis
c=improfile(image_array(:,:,i),x_c_line,y_c_line);  % Pixel value plot with lines drawn 
c=c(:,1)-min(c);
c=c(:,1)-c(1);

% Gaussian fit of Intensity distribution
ft=fittype('gauss1');   % Fit type=Gaussian
x=1:numel(c);   % x-data
y_int_dist=c;   % y-data
[fitresult, gof1]=fit(x(:),y_int_dist(:),ft);   % Fit x and y data into a gaussian
figure(2)
title('Gaussian fit of the Intensity distribution');
int_dist=plot(fitresult,x,y_int_dist);  % plot gaussian fit
hold on,
plot(c,'-');
xlabel('Distance along the line (pixels)');ylabel('Intensity(abu)');
grid on
set(gca,'FontSize',18);

% Gaussian fit of Probability distribution
sum_c=sum(c);   % Sum of all the intensity values
prob_dist_c=c./sum_c;   % Probability density of the intensity
y_prob_dist=prob_dist_c;    % Defining the y-data
[fitresult2, gof2]=fit(x(:),y_prob_dist(:),ft); % Gaussian fit of the prob. density func
figure(3)
title('Probability Distribution');
prob_dist=plot(fitresult2,x(:),y_prob_dist(:)); % Plot gaussian fit
hold on,
plot(prob_dist_c,'-');
xlabel('Distance along the line (pixels)');ylabel('Probability');
grid on

% Standard Deviation and Mean
standard_dev=fitresult.c1/sqrt(2);  % Standard deviation calculation
mean=fitresult.b1;  % Mean calculations
FWHM_c_pixels=2.3548*standard_dev;  % FWHM in pixels
FWHM_c_nm=FWHM_c_pixels.*pixelsize; % FWHM in nm

% Histogram of the Gray scale
figure(4)
histogram(image_array); % Gray value histogram
title('Gray value histogram');
    %end
end
