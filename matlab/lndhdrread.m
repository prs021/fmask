function [Lmax,Lmin,Qcalmax,Qcalmin,Refmax,Refmin,ijdim_ref,ijdim_thm,reso_ref,...
    reso_thm,ul,zen,azi,zc,Lnum,doy]=lndhdrread(filename)
% Revisions:
% Read in the metadata for Landsat 8 (Zhe 04/04/2013)
% Read in the old or new metadata for Landsat TM/ETM+ images (Zhe 10/18/2012)
% [Lmax,Lmin,Qcalmax,Qcalmin,Refmax,Refmin,ijdim_ref,ijdim_thm,reso_ref,...
%    reso_thm,ul,zen,azi,zc,Lnum,doy]=lndhdrread(filename)
% Where:
% Inputs:
% filename='L*MTL.txt';
% Outputs:
% 1) Lmax = Max radiances;
% 2) Lmin = Min radiances;
% 3) Qcalmax = Max calibrated DNs;
% 4) Qcalmin = Min calibrated DNs;
% 5) ijdim_ref = [nrows,ncols]; % dimension of optical bands
% 6) ijdim_ref = [nrows,ncols]; % dimension of thermal band
% 7) reo_ref = 28/30; % resolution of optical bands
% 8) reo_thm = 60/120; % resolution of thermal band
% 9) ul = [upperleft_mapx upperleft_mapy];
% 10) zen = solar zenith angle (degrees);
% 11) azi = solar azimuth angle (degrees);
% 12) zc = Zone Number
% 13) Lnum = 4,5,or 7; Landsat sensor number
% 14) doy = day of year (1,2,3,...,356);
%
%%
% open and read hdr file
fid_in=fopen(filename,'r');
geo_char=fscanf(fid_in,'%c',inf);
fclose(fid_in);
geo_char=geo_char';
geo_str=strread(geo_char,'%s');

% initialize Refmax & Refmin
Refmax = -1;
Refmin = -1;

% Identify Landsat Number (Lnum = 4, 5, 7, or 8)
LID=char(geo_str(strmatch('SPACECRAFT_ID',geo_str)+2));
Lnum=str2double(LID(end-1));

if Lnum >= 4 && Lnum <=7
  % determine the metadata type "old" or "new"
  if isempty(strmatch('LANDSAT_SCENE_ID',geo_str)) == false % "new" MTL.txt     
    % read in LMAX
    Lmax_B1 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_1',geo_str)+2));
    Lmax_B2 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_2',geo_str)+2));
    Lmax_B3 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_3',geo_str)+2));
    Lmax_B4 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_4',geo_str)+2));
    Lmax_B5 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_5',geo_str)+2));
    if Lnum==7
        Lmax_B6 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_6_VCID_1',geo_str)+2));
    else
        Lmax_B6 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_6',geo_str)+2));
    end
    Lmax_B7 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_7',geo_str)+2));
    Lmax=[Lmax_B1,Lmax_B2,Lmax_B3,Lmax_B4,Lmax_B5,Lmax_B6,Lmax_B7];
    
    % Read in LMIN
    Lmin_B1 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_1',geo_str)+2));
    Lmin_B2 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_2',geo_str)+2));
    Lmin_B3 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_3',geo_str)+2));
    Lmin_B4 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_4',geo_str)+2));
    Lmin_B5 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_5',geo_str)+2));
    if Lnum==7
        Lmin_B6 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_6_VCID_1',geo_str)+2));
    else
        Lmin_B6 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_6',geo_str)+2));
    end
    Lmin_B7 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_7',geo_str)+2));
    Lmin=[Lmin_B1,Lmin_B2,Lmin_B3,Lmin_B4,Lmin_B5,Lmin_B6,Lmin_B7];
    
    % Read in QCALMAX
    Qcalmax_B1 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_1',geo_str)+2));
    Qcalmax_B2 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_2',geo_str)+2));
    Qcalmax_B3 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_3',geo_str)+2));
    Qcalmax_B4 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_4',geo_str)+2));
    Qcalmax_B5 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_5',geo_str)+2));
    if Lnum==7
        Qcalmax_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_6_VCID_1',geo_str)+2));
    else
        Qcalmax_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_6',geo_str)+2));
    end
    Qcalmax_B7 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_7',geo_str)+2));
    Qcalmax=[Qcalmax_B1,Qcalmax_B2,Qcalmax_B3,Qcalmax_B4,Qcalmax_B5,Qcalmax_B6,Qcalmax_B7];
    
    % Read in QCALMIN
    Qcalmin_B1 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_1',geo_str)+2));
    Qcalmin_B2 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_2',geo_str)+2));
    Qcalmin_B3 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_3',geo_str)+2));
    Qcalmin_B4 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_4',geo_str)+2));
    Qcalmin_B5 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_5',geo_str)+2));
    if Lnum==7
        Qcalmin_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_6_VCID_1',geo_str)+2));
    else
        Qcalmin_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_6',geo_str)+2));
    end
    Qcalmin_B7 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_7',geo_str)+2));
    Qcalmin=[Qcalmin_B1,Qcalmin_B2,Qcalmin_B3,Qcalmin_B4,Qcalmin_B5,Qcalmin_B6,Qcalmin_B7];
    
    % Read in nrows & ncols of optical bands
    Sample_ref = str2double(geo_str(strmatch('REFLECTIVE_SAMPLES',geo_str)+2));
    Line_ref = str2double(geo_str(strmatch('REFLECTIVE_LINES',geo_str)+2));
    % record ijdimension of optical bands
    ijdim_ref=[Line_ref,Sample_ref];
    
    Sample_thm = str2double(geo_str(strmatch('THERMAL_SAMPLES',geo_str)+2));
    Line_thm = str2double(geo_str(strmatch('THERMAL_LINES',geo_str)+2));
    % record thermal band dimensions (i,j)
    ijdim_thm=[Line_thm,Sample_thm];
    
    % Read in resolution of optical and thermal bands
    reso_ref = str2double(geo_str(strmatch('GRID_CELL_SIZE_REFLECTIVE',geo_str)+2));
    reso_thm = str2double(geo_str(strmatch('GRID_CELL_SIZE_THERMAL',geo_str)+2));
    
    % Read in UTM Zone Number
    zc=str2double(geo_str(strmatch('UTM_ZONE',geo_str)+2));
    % Read in Solar Azimuth & Elevation angle (degrees)
    azi=str2double(geo_str(strmatch('SUN_AZIMUTH',geo_str)+2));
    zen=90-str2double(geo_str(strmatch('SUN_ELEVATION',geo_str)+2));
    % Read in upperleft mapx,y
    ulx=str2double(geo_str(strmatch('CORNER_UL_PROJECTION_X_PRODUCT',geo_str)+2));
    uly=str2double(geo_str(strmatch('CORNER_UL_PROJECTION_Y_PRODUCT',geo_str)+2));
    ul=[ulx,uly];
    % Read in date of year
    char_doy=char(geo_str(strmatch('LANDSAT_SCENE_ID',geo_str)+2));
    doy=str2double(char_doy(15:17));
    
  else % "old" MTL.txt    
    % read in LMAX
    Lmax_B1 = str2double(geo_str(strmatch('LMAX_BAND1',geo_str)+2));
    Lmax_B2 = str2double(geo_str(strmatch('LMAX_BAND2',geo_str)+2));
    Lmax_B3 = str2double(geo_str(strmatch('LMAX_BAND3',geo_str)+2));
    Lmax_B4 = str2double(geo_str(strmatch('LMAX_BAND4',geo_str)+2));
    Lmax_B5 = str2double(geo_str(strmatch('LMAX_BAND5',geo_str)+2));
    if Lnum==7
        Lmax_B6 = str2double(geo_str(strmatch('LMAX_BAND61',geo_str)+2));
    else
        Lmax_B6 = str2double(geo_str(strmatch('LMAX_BAND6',geo_str)+2));
    end
    Lmax_B7 = str2double(geo_str(strmatch('LMAX_BAND7',geo_str)+2));
    Lmax=[Lmax_B1,Lmax_B2,Lmax_B3,Lmax_B4,Lmax_B5,Lmax_B6,Lmax_B7];
    
    % Read in LMIN
    Lmin_B1 = str2double(geo_str(strmatch('LMIN_BAND1',geo_str)+2));
    Lmin_B2 = str2double(geo_str(strmatch('LMIN_BAND2',geo_str)+2));
    Lmin_B3 = str2double(geo_str(strmatch('LMIN_BAND3',geo_str)+2));
    Lmin_B4 = str2double(geo_str(strmatch('LMIN_BAND4',geo_str)+2));
    Lmin_B5 = str2double(geo_str(strmatch('LMIN_BAND5',geo_str)+2));
    if Lnum==7
        Lmin_B6 = str2double(geo_str(strmatch('LMIN_BAND61',geo_str)+2));
    else
        Lmin_B6 = str2double(geo_str(strmatch('LMIN_BAND6',geo_str)+2));
    end
    Lmin_B7 = str2double(geo_str(strmatch('LMIN_BAND7',geo_str)+2));
    Lmin=[Lmin_B1,Lmin_B2,Lmin_B3,Lmin_B4,Lmin_B5,Lmin_B6,Lmin_B7];
    
    % Read in QCALMAX
    Qcalmax_B1 = str2double(geo_str(strmatch('QCALMAX_BAND1',geo_str)+2));
    Qcalmax_B2 = str2double(geo_str(strmatch('QCALMAX_BAND2',geo_str)+2));
    Qcalmax_B3 = str2double(geo_str(strmatch('QCALMAX_BAND3',geo_str)+2));
    Qcalmax_B4 = str2double(geo_str(strmatch('QCALMAX_BAND4',geo_str)+2));
    Qcalmax_B5 = str2double(geo_str(strmatch('QCALMAX_BAND5',geo_str)+2));
    if Lnum==7
        Qcalmax_B6 = str2double(geo_str(strmatch('QCALMAX_BAND61',geo_str)+2));
    else
        Qcalmax_B6 = str2double(geo_str(strmatch('QCALMAX_BAND6',geo_str)+2));
    end
    Qcalmax_B7 = str2double(geo_str(strmatch('QCALMAX_BAND7',geo_str)+2));
    Qcalmax=[Qcalmax_B1,Qcalmax_B2,Qcalmax_B3,Qcalmax_B4,Qcalmax_B5,Qcalmax_B6,Qcalmax_B7];
    
    % Read in QCALMIN
    Qcalmin_B1 = str2double(geo_str(strmatch('QCALMIN_BAND1',geo_str)+2));
    Qcalmin_B2 = str2double(geo_str(strmatch('QCALMIN_BAND2',geo_str)+2));
    Qcalmin_B3 = str2double(geo_str(strmatch('QCALMIN_BAND3',geo_str)+2));
    Qcalmin_B4 = str2double(geo_str(strmatch('QCALMIN_BAND4',geo_str)+2));
    Qcalmin_B5 = str2double(geo_str(strmatch('QCALMIN_BAND5',geo_str)+2));
    if Lnum==7
        Qcalmin_B6 = str2double(geo_str(strmatch('QCALMIN_BAND61',geo_str)+2));
    else
        Qcalmin_B6 = str2double(geo_str(strmatch('QCALMIN_BAND6',geo_str)+2));
    end
    Qcalmin_B7 = str2double(geo_str(strmatch('QCALMIN_BAND7',geo_str)+2));
    Qcalmin=[Qcalmin_B1,Qcalmin_B2,Qcalmin_B3,Qcalmin_B4,Qcalmin_B5,Qcalmin_B6,Qcalmin_B7];
    
    % Read in nrows & ncols of optical bands
    Sample_ref = str2double(geo_str(strmatch('PRODUCT_SAMPLES_REF',geo_str)+2));
    Line_ref = str2double(geo_str(strmatch('PRODUCT_LINES_REF',geo_str)+2));
    % record ijdimension of optical bands
    ijdim_ref=[Line_ref,Sample_ref];
    
    Sample_thm = str2double(geo_str(strmatch('PRODUCT_SAMPLES_THM',geo_str)+2));
    Line_thm = str2double(geo_str(strmatch('PRODUCT_LINES_THM',geo_str)+2));
    % record thermal band dimensions (i,j)
    ijdim_thm=[Line_thm,Sample_thm];
    
    % Read in resolution of optical and thermal bands
    reso_ref = str2double(geo_str(strmatch('GRID_CELL_SIZE_REF',geo_str)+2));
    reso_thm = str2double(geo_str(strmatch('GRID_CELL_SIZE_THM',geo_str)+2));
    
    % Read in UTM Zone Number
    zc=str2double(geo_str(strmatch('ZONE_NUMBER',geo_str)+2));
    % Read in Solar Azimuth & Elevation angle (degrees)
    azi=str2double(geo_str(strmatch('SUN_AZIMUTH',geo_str)+2));
    zen=90-str2double(geo_str(strmatch('SUN_ELEVATION',geo_str)+2));
    % Read in upperleft mapx,y
    ulx=str2double(geo_str(strmatch('PRODUCT_UL_CORNER_MAPX',geo_str)+2));
    uly=str2double(geo_str(strmatch('PRODUCT_UL_CORNER_MAPY',geo_str)+2));
    ul=[ulx,uly];
    % Read in date of year
    char_doy=char(geo_str(strmatch('DATEHOUR_CONTACT_PERIOD',geo_str)+2));
    doy=str2double(char_doy(4:6));
  end
elseif Lnum == 8
    % read in LMAX
    Lmax_B2 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_2',geo_str)+2));
    Lmax_B3 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_3',geo_str)+2));
    Lmax_B4 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_4',geo_str)+2));
    Lmax_B5 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_5',geo_str)+2));
    Lmax_B6 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_6',geo_str)+2));
    Lmax_B7 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_7',geo_str)+2));
    Lmax_B9 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_9',geo_str)+2));
    Lmax_B10 = str2double(geo_str(strmatch('RADIANCE_MAXIMUM_BAND_10',geo_str)+2));
    
    Lmax=[Lmax_B2,Lmax_B3,Lmax_B4,Lmax_B5,Lmax_B6,Lmax_B7,Lmax_B9,Lmax_B10];
        
    % read in LMIN
    Lmin_B2 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_2',geo_str)+2));
    Lmin_B3 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_3',geo_str)+2));
    Lmin_B4 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_4',geo_str)+2));
    Lmin_B5 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_5',geo_str)+2));
    Lmin_B6 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_6',geo_str)+2));
    Lmin_B7 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_7',geo_str)+2));
    Lmin_B9 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_9',geo_str)+2));
    Lmin_B10 = str2double(geo_str(strmatch('RADIANCE_MINIMUM_BAND_10',geo_str)+2));
    
    Lmin=[Lmin_B2,Lmin_B3,Lmin_B4,Lmin_B5,Lmin_B6,Lmin_B7,Lmin_B9,Lmin_B10];
    
    % Read in QCALMAX
    Qcalmax_B2 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_2',geo_str)+2));
    Qcalmax_B3 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_3',geo_str)+2));
    Qcalmax_B4 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_4',geo_str)+2));
    Qcalmax_B5 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_5',geo_str)+2));
    Qcalmax_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_6',geo_str)+2));
    Qcalmax_B7 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_7',geo_str)+2));
    Qcalmax_B9 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_9',geo_str)+2));
    Qcalmax_B10 = str2double(geo_str(strmatch('QUANTIZE_CAL_MAX_BAND_10',geo_str)+2));
    Qcalmax=[Qcalmax_B2,Qcalmax_B3,Qcalmax_B4,Qcalmax_B5,Qcalmax_B6,Qcalmax_B7,Qcalmax_B9,Qcalmax_B10];
    
    % Read in QCALMIN
    Qcalmin_B2 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_2',geo_str)+2));
    Qcalmin_B3 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_3',geo_str)+2));
    Qcalmin_B4 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_4',geo_str)+2));
    Qcalmin_B5 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_5',geo_str)+2));
    Qcalmin_B6 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_6',geo_str)+2));
    Qcalmin_B7 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_7',geo_str)+2));
    Qcalmin_B9 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_9',geo_str)+2));
    Qcalmin_B10 = str2double(geo_str(strmatch('QUANTIZE_CAL_MIN_BAND_10',geo_str)+2));
    Qcalmin=[Qcalmin_B2,Qcalmin_B3,Qcalmin_B4,Qcalmin_B5,Qcalmin_B6,Qcalmin_B7,Qcalmin_B9,Qcalmin_B10];
    
    % read in Refmax
    Refmax_B2 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_2',geo_str)+2));
    Refmax_B3 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_3',geo_str)+2));
    Refmax_B4 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_4',geo_str)+2));
    Refmax_B5 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_5',geo_str)+2));
    Refmax_B6 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_6',geo_str)+2));
    Refmax_B7 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_7',geo_str)+2));
    Refmax_B9 = str2double(geo_str(strmatch('REFLECTANCE_MAXIMUM_BAND_9',geo_str)+2));
    
    Refmax=[Refmax_B2,Refmax_B3,Refmax_B4,Refmax_B5,Refmax_B6,Refmax_B7,Refmax_B9];

    % read in Refmin
    Refmin_B2 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_2',geo_str)+2));
    Refmin_B3 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_3',geo_str)+2));
    Refmin_B4 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_4',geo_str)+2));
    Refmin_B5 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_5',geo_str)+2));
    Refmin_B6 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_6',geo_str)+2));
    Refmin_B7 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_7',geo_str)+2));
    Refmin_B9 = str2double(geo_str(strmatch('REFLECTANCE_MINIMUM_BAND_9',geo_str)+2));
    
    Refmin=[Refmin_B2,Refmin_B3,Refmin_B4,Refmin_B5,Refmin_B6,Refmin_B7,Refmin_B9];

    % Read in nrows & ncols of optical bands
    Sample_ref = str2double(geo_str(strmatch('REFLECTIVE_SAMPLES',geo_str)+2));
    Line_ref = str2double(geo_str(strmatch('REFLECTIVE_LINES',geo_str)+2));
    % record ijdimension of optical bands
    ijdim_ref=[Line_ref,Sample_ref];
    
    Sample_thm = str2double(geo_str(strmatch('THERMAL_SAMPLES',geo_str)+2));
    Line_thm = str2double(geo_str(strmatch('THERMAL_LINES',geo_str)+2));
    % record thermal band dimensions (i,j)
    ijdim_thm=[Line_thm,Sample_thm];
    
    % Read in resolution of optical and thermal bands
    reso_ref = str2double(geo_str(strmatch('GRID_CELL_SIZE_REFLECTIVE',geo_str)+2));
    reso_thm = str2double(geo_str(strmatch('GRID_CELL_SIZE_THERMAL',geo_str)+2));
    
    % Read in UTM Zone Number
    zc=str2double(geo_str(strmatch('UTM_ZONE',geo_str)+2));
    % Read in Solar Azimuth & Elevation angle (degrees)
    azi=str2double(geo_str(strmatch('SUN_AZIMUTH',geo_str)+2));
    zen=90-str2double(geo_str(strmatch('SUN_ELEVATION',geo_str)+2));
    % Read in upperleft mapx,y
    ulx=str2double(geo_str(strmatch('CORNER_UL_PROJECTION_X_PRODUCT',geo_str)+2));
    uly=str2double(geo_str(strmatch('CORNER_UL_PROJECTION_Y_PRODUCT',geo_str)+2));
    ul=[ulx,uly];
    % Read in date of year
    char_doy=char(geo_str(strmatch('LANDSAT_SCENE_ID',geo_str)+2));
    doy=str2double(char_doy(15:17));
else
    fprintf('This sensor is not Landsat 4, 5, 7, or 8!\n');
    return;
end

end

