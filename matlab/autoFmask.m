function clr_pct = autoFmask(cldpix,sdpix,snpix,cldprob)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Welcome to use the 3.3.0 version of Fmask!
% It is capable of detecting cloud, cloud shadow, snow for Landsat 4, 5, 7, and 8
% If you have any question please do not hesitate
% to contact Zhe Zhu and Prof. Curtis Woodcock at Center for Remote Sensing,
% Boston University
% email: zhuzhe@bu.edu
%
% This function will calculate the mask for each scence automatically
% Output is the final fmask
% clear land = 0
% clear water = 1
% cloud shadow = 2
% snow = 3
% cloud = 4
% outside = 255
%
% How to install it?
% 1. Copy the "Fmask" folder to your local disk
% 2. Start matlab and addpath for this folder - addpath('local_disk');
%
%
% How to use it?
% 1. Get to the directory where you save the Landsat scene
% 2. Type in - 'autoFmask' or 'autoFmask(cldpix,sdpix,snpix,cldprb) in Matlab command window
% 'cldpix', 'sdpix', 'snpix' are dilated number of pixels for cloud/shadow/snow with
% default values of 3. 'cldprob' is the cloud probability threshold with default
% values of 22.5 for Landsat 4~7 and 50 for Landsat 8 (range from 0~100).
% 3. You can get clear pixel percent by using 'clr_pct = autoFmask';
% 
% Requirements:
% 1. Use the original Landat TIF images as inputs and each folder only put one image. 
% 2. It needs approximately 4G memory to run this algorithm.
% 3. It takes 0.5 to 5 miniutes for processing one Landsat image with one CPU.
%
%% History of revisions:
%
% New features of 2.1.0 version compared to 1.6.3 version:
% Exclude small cloud object <= 9 pixels (Zhe 03/07/2012)
% Dilate snow by default 3 pixels in 8 connect directions (Zhe 05/24/2012)
% Change the Fmask band name to "*Fmask" (Zhe 09/27/2012)
% Process TM and ETM+ images with the new "MTL.txt" metadata (Zhu 09/28/2012)
% Process both the new and old "MTL.txt" metadata (Zhu 10/18/2012)
% Fixed a bug in writing zone number for ENVI header (Zhu 02/26/2013)
%
% New features of 2.2.0 version:
% Change Tbuffer to 0.95 to fix ealier stops in cloud shadow match (Zhu 03/01/2013)
%
% New features of 3.3.0 version:
% Detecting clouds for Landsat 8 without using new bands (Zhe 09/04/2013)
% Remove high probability clouds to reduce commission error (Zhe 09/11/2013)
% Fix bugs in probs < 0 (Brightness_prob & wTemp_prob) (Zhe 09/11/2013)
% Add customized snow dilation pixel number (Zhe 09/12/2013)
% Fix problem in snow detection because of temperature screen (Zhe 09/12/2013)
% Output clear pixel percent for the whole Landsat image (Zhe 09/13/2013)
% Remove default 3 pixels snow dilation (Zhe 09/20/2013)
% Fix bug in calculating r_obj and change num_pix value (Zhe 09/27/2013)
% Remove majority filter (Zhe 10/27/2013)
% Add dynamic water threshold (Zhe 10/27/2013)
% Exclude small cloud object < 3 pixels (Zhe 10/27/2013)
% Remove the split window method in cirrus cloud detection (Zhe 10/29/2013)
% Temperature < 283K for all snow (Zhe 11/01/2013)
% Calculate cloud DEM with recorded height (Zhe 08/19/2015)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Fmask 3.3.0 version start ...\n');

norMTL=dir('L*MTL.txt');
existMTL=size(norMTL);

if existMTL(1)==0
    fprintf('No L*MTL.txt header in the current folder!\n');
    return;
end

% determine sensor type
% open and read hdr file
fid_in=fopen(norMTL.name,'r');
geo_char=fscanf(fid_in,'%c',inf);
fclose(fid_in);
geo_char=geo_char';
geo_str=strread(geo_char,'%s');

% Identify Landsat Number (Lnum = 4, 5, 7, or 8)
LID=char(geo_str(strmatch('SPACECRAFT_ID',geo_str)+2));
num_Lst=str2double(LID(end-1));
fprintf('Cloud, cloud shadow, and snow detection for Landsat %d images\n',num_Lst); 

if exist('cldpix','var')==1&&exist('sdpix','var')==1&&exist('snpix','var')==1
    % cldpix = str2double(cldpix); % to make stand alone work for inputs
    % sdpix = str2double(sdpix);
    % snpix = str2double(snpix);
    fprintf('Cloud/cloud shadow/snow dilated by %d/%d/%d pixels\n',cldpix,sdpix,snpix);

else
    % default buffering pixels for cloud, cloud shadow, and snow
    cldpix = 3;
    sdpix = 3;
    snpix = 0;
    fprintf('Cloud/cloud shadow/snow dilated by %d/%d/%d pixels (default)\n',cldpix,sdpix,snpix);
end

if exist('cldprob','var')==1
    % cldprob = str2double(cldprob); % to make stand alone work for inputs
    fprintf('Cloud probability threshold of %.2f%%\n',cldprob);
else
    % default cloud probability threshold for cloud detection
    if num_Lst < 8
        cldprob = 22.5;
        fprintf('Cloud probability threshold of %.2f%% (default)\n',cldprob);
    elseif num_Lst == 8
        cldprob = 22.5; % the default probability threshold may change for Landsat 8
        fprintf('Cloud probability threshold of %.2f%% (default)\n',cldprob);
    else
        fprintf('Images are not from Landsat 4~8\n');
        return;
    end
end
 
clr_pct = Fmask(norMTL.name,cldpix,sdpix,snpix,cldprob,num_Lst); % newest version 3.2.1
end