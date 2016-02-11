function clr_pct = fcssm(dir_im,Sun_zen,Sun_azi,ptm,Temp,...
    t_templ,t_temph,Water,Snow,plcim,plsim,ijDim,jiUL,resolu,ZC,cldpix,sdpix,snpix)
% Function for Cloud, cloud Shadow, and Snow Masking 3.3.0
%
% History of revisions:
% calculate cloud DEM with recorded height (Zhe 08/19/2015)
% exclude small cloud object < 3 pixels (Zhe 10/27/2013)
% fix bug in calculating r_obj and change num_pix value (Zhe 09/27/2013)
% Output clear pixel percent for the whole Landsat image (Zhe 09/13/2013)
% Change Tbuffer to 0.95 to fix ealier stops in cloud shadow match (Zhe 03/01/2013)
% change the Fmask band name to "*Fmask" (Zhe 09/27/2012)
% dilate snow by default 3 pixels in 8 connect directions (Zhe 05/24/2012)
% exclude small cloud object <= 9 pixels (Zhe 3/07/2012)
% cloud shadow do not have to overlap with potential cloud shadow layer (Zhe 04/24/2011)
% dilate shadow again (3 pixels as default) (Zhe 12/23/2010);
% similarity < 0.95 (Zhe 11/06/2010)
% boosts data by >5/9 (Zhe Zhu 12/08/2009)
% use temperature to narrow iteration height (Zhe 12/09/2009)
% fixed bug for height (Zhe 12/09/2009)
% cloud DEM by thermal in cloud and shadow match (Zhe 1/03/2009)

% fprintf('Read in potential mask ...\n');
% solar elevation angle
Sun_ele=90-Sun_zen;
sun_ele_rad=deg2rad(Sun_ele);
% solar azimuth anngle
Sun_tazi=Sun_azi-90;
sun_tazi_rad=deg2rad(Sun_tazi);
% [plcim,jiDim,jiUL,resolu,ZC]=enviread([dir_im,'plcloud']);
% plsim=enviread([dir_im,'plshadow']);
% assume resolu.x=resolu.y
sub_size=resolu(1);
win_height=ijDim(1);
win_width=ijDim(2);

% potential cloud & shadow layer
cloud_test=zeros(ijDim,'uint8');
shadow_test=zeros(ijDim,'uint8');
% matched cloud & shadow layer
shadow_cal=zeros(ijDim,'uint8');
cloud_cal=zeros(ijDim,'uint8');
% cloud_height=zeros(ijDim);% cloud relative height (m)
% boundary layer
boundary_test=zeros(ijDim,'uint8');
% final cloud, shadow and snow mask
cs_final=zeros(ijDim,'uint8');

% get potential mask values
shadow_test(plsim==1)=1;% plshadow layer
clear plsim; % empty memory

boundary_test(plcim<255)=1; % boundary layer
cloud_test(plcim==1)=1;% plcloud layer
clear plcim; % empty memory

% revised percent of cloud on the scene after plcloud
revised_ptm=sum(cloud_test(:))/sum(boundary_test(:));
% no t test  => more than 99.9 % clouds and partly cloud over land
% => no match => rest are definite shadows

% cloud covers more than 90% of the scene
% => no match => rest are definite shadows
% fprintf('Cloud and cloud shadow matching ...\n');

if ptm <=0.1||revised_ptm>=0.90
    fprintf('Skip cloud & cloud shadow matching because high cloud cover\n');
    cloud_cal(cloud_test==true)=1;
    shadow_cal(cloud_test==false)=1;
    similar_num=-1;
    %   height_num=-1;

else
    fprintf('Cloud & cloud shadow matching ...\n');

    % define constants
    Tsimilar=0.30;
    Tbuffer=0.95; % threshold for matching buffering
    max_similar = 0.95; % max similarity threshold
    num_cldoj=3; % minimum matched cloud object (pixels)
    num_pix=3; % number of inward pixes (90m) for cloud base temperature
    % enviromental lapse rate 6.5 degrees/km
    % dry adiabatic lapse rate 9.8 degrees/km
    rate_elapse=6.5;% degrees/km
    rate_dlapse=9.8;% degrees/km

    %     fprintf('Set cloud similarity = %.3f\n',Tsimilar);
    %     fprintf('Set matching buffer = %.3f\n',Tbuffer);
    %     fprintf('Shadow match for cloud object >= %d pixels\n',num_cldoj);

    i_step=2*sub_size*tan(sun_ele_rad); % move 2 pixel at a time

    % get moving direction
    [rows,cols]=find(boundary_test==1);
    [y_ul,num]=min(rows);
    x_ul=cols(num);

    [y_lr,num]=max(rows);
    x_lr=cols(num);

    [x_ll,num]=min(cols);
    y_ll=rows(num);

    [x_ur,num]=max(cols);
    y_ur=rows(num);

    % get view angle geometry
    [A,B,C,omiga_par,omiga_per]=viewgeo(x_ul,y_ul,x_ur,y_ur,x_ll,y_ll,x_lr,y_lr);

    % Segmentate each cloud
    %     fprintf('Cloud segmentation & matching\n');
    segm_cloud_init=bwlabeln(cloud_test,8);
    
    L = segm_cloud_init;
    s = regionprops(L,'area');
    area = [s.Area];

    % filter out cloud object < than num_cldoj pixels
    idx = find(area >= num_cldoj);
    segm_cloud_tmp = ismember(L,idx);
    [segm_cloud,num]=bwlabeln(segm_cloud_tmp,8);

    s = regionprops(segm_cloud,'area');
    area_final = [s.Area];
    obj_num=area_final;

    % Get the x,y of each cloud
    % Matrix used in recording the x,y
    xys = regionprops(segm_cloud,'PixelList');

    % Use iteration to get the optimal move distance
    % Calulate the moving cloud shadow

    % height_num=zeros(1,num); % cloud relative height (m)
    similar_num=zeros(1,num); % cloud shadow match similarity (m)

    for cloud_type=1:num
        %fprintf('Shadow Match of the %d/%d_th cloud with %d
        %pixels\n',cloud_type,num,obj_num(cloud_type));
        % moving cloud xys
        XY_type=zeros(obj_num(cloud_type),2);
        % record the max threshold moving cloud xys
        tmp_XY_type=zeros(obj_num(cloud_type),2);
        % corrected for view angle xys
        tmp_xys=zeros(obj_num(cloud_type),2);
        % record the original xys
        orin_xys=zeros(obj_num(cloud_type),2);
        % record the original xys
        orin_xys(:,:)=xys(cloud_type,1).PixelList(:,:);
        % record this orinal ids
        orin_cid=sub2ind(ijDim,orin_xys(:,2),orin_xys(:,1));

        % Temperature of the cloud object
        temp_obj=Temp(orin_cid);
        % the base temperature for cloud
        % assume object is round r_obj is radium of object
        r_obj=sqrt(obj_num(cloud_type)/2*pi);
        % number of inward pixes for correct temperature
        %        num_pix=8;
        pct_obj=(r_obj-num_pix)^2/r_obj^2;
        pct_obj=min(pct_obj,1); % pct of edge pixel should be less than 1
        t_obj=quantile(temp_obj(:),pct_obj);
        % put the edge of the cloud the same value as t_obj
        temp_obj(temp_obj>t_obj)=t_obj;
        % wet adiabatic lapse rate 6.5 degrees/km
        % dry adiabatic lapse rate 9.8 degrees/km
        %        rate_wlapse=6.5;% degrees/km
        %        rate_dlapse=9.8;% degrees/km
        Max_cl_height=12000;% Max cloud base height (m)
        Min_cl_height=200; % Min cloud base height (m)
        % refine cloud height range (m)
        Min_cl_height=max(Min_cl_height,10*(t_templ-400-t_obj)/rate_dlapse);
        Max_cl_height=min(Max_cl_height,10*(t_temph+400-t_obj));
        % initialize height and similarity info
        record_h=0;
        record_thresh=0;

        for base_h=Min_cl_height:i_step:Max_cl_height % iterate in height (m)
            % Get the true postion of the cloud
            % calculate cloud DEM with initial base height
            h=(10*(t_obj-temp_obj)/rate_elapse+base_h);
            [tmp_xys(:,1),tmp_xys(:,2)]=mat_truecloud(orin_xys(:,1),...
                orin_xys(:,2),h,A,B,C,omiga_par,omiga_per);
            % shadow moved distance (pixel)
            % i_xy=h*cos(sun_tazi_rad)/(sub_size*tan(sun_ele_rad));
            i_xy=h/(sub_size*tan(sun_ele_rad));
            if Sun_azi < 180
                XY_type(:,2)=round(tmp_xys(:,1)-i_xy*cos(sun_tazi_rad)); % X is for j,2
                XY_type(:,1)=round(tmp_xys(:,2)-i_xy*sin(sun_tazi_rad)); % Y is for i,1
            else
                XY_type(:,2)=round(tmp_xys(:,1)+i_xy*cos(sun_tazi_rad)); % X is for j,2
                XY_type(:,1)=round(tmp_xys(:,2)+i_xy*sin(sun_tazi_rad)); % Y is for i,1
            end

            tmp_j=XY_type(:,2);% col
            tmp_i=XY_type(:,1);% row
            % the id that is out of the image
            out_id=tmp_i<1|tmp_i>win_height|tmp_j<1|tmp_j>win_width;
            out_all=sum(out_id(:));

            tmp_ii=tmp_i(out_id==0);
            tmp_jj=tmp_j(out_id==0);

            tmp_id=sub2ind(ijDim,tmp_ii,tmp_jj);
            % the id that is matched (exclude original cloud)
            match_id=(boundary_test(tmp_id)==0)|...
                (segm_cloud(tmp_id)~=cloud_type&(cloud_test(tmp_id)>0|shadow_test(tmp_id)==1));
            matched_all=sum(match_id(:))+out_all;

            % the id that is the total pixel (exclude original cloud)
            total_id=(segm_cloud(tmp_id)~=cloud_type);
            total_all=sum(total_id(:))+out_all;

            thresh_match=matched_all/total_all;
            if (thresh_match >= Tbuffer*record_thresh)&&...
               (base_h < Max_cl_height-i_step)&&...
               (record_thresh < max_similar)
                if (thresh_match > record_thresh)
                    record_thresh=thresh_match;
                    record_h=h;                 
                end
            elseif (record_thresh > Tsimilar)
                similar_num(cloud_type)=record_thresh;
                i_vir=record_h/(sub_size*tan(sun_ele_rad));
                % height_num=record_h;
                
                % calculate cloud DEM with recorded height (Zhe 08/19/2015)
                [tmp_xys(:,1),tmp_xys(:,2)]=mat_truecloud(orin_xys(:,1),...
                    orin_xys(:,2),record_h,A,B,C,omiga_par,omiga_per);
            
                if Sun_azi < 180
                    tmp_XY_type(:,2)=round(tmp_xys(:,1)-i_vir*cos(sun_tazi_rad)); % X is for col j,2
                    tmp_XY_type(:,1)=round(tmp_xys(:,2)-i_vir*sin(sun_tazi_rad)); % Y is for row i,1
                else
                    tmp_XY_type(:,2)=round(tmp_xys(:,1)+i_vir*cos(sun_tazi_rad)); % X is for col j,2
                    tmp_XY_type(:,1)=round(tmp_xys(:,2)+i_vir*sin(sun_tazi_rad)); % Y is for row i,1
                end

                tmp_scol=tmp_XY_type(:,2);
                tmp_srow=tmp_XY_type(:,1);
                % put data within range
                tmp_srow(tmp_srow<1)=1;
                tmp_srow(tmp_srow>win_height)=win_height;
                tmp_scol(tmp_scol<1)=1;
                tmp_scol(tmp_scol>win_width)=win_width;
                
                tmp_sid=sub2ind(ijDim,tmp_srow,tmp_scol);
                % give shadow_cal=1
                shadow_cal(tmp_sid)=1;
                % record matched cloud
                % cloud_cal(orin_cid)=1;
                % cloud_height(orin_cid)=record_h;
                % fprintf('cloud_type = %d & base_h = %d & rt_obj =%d\n',cloud_type,base_h,t_obj);
                break;
            else
                record_thresh=0;
                continue;
            end
        end
    end

    % % dilate each cloud and shadow object by 3 and 3 pixel outward in 8 connect directions
    %    cldpix=3; % number of pixels to be dilated for cloud
    %    sdpix=3; % number of pixels to be dilated for shadow
%    fprintf('Dilate %d pixels for cloud & %d pixels for shadow objects\n',cldpix,sdpix);
    SEc=strel('square',2*cldpix+1);
    SEs=strel('square',2*sdpix+1);

    % dialte shadow first
    shadow_cal=imdilate(shadow_cal,SEs);
    %     % find shadow within plshadow
    %     shadow_cal(shadow_test~=1)=0;
    %     % dilate shadow again with the more accurate cloud shadow
    %     shadow_cal=imdilate(shadow_cal,SEs);

    cloud_cal=segm_cloud_tmp;
    cloud_cal=imdilate(cloud_cal,SEc);

    % dilate snow by snpix pixels in 8 connect directions (Zhe 09/12/2012)
    Snow=imdilate(Snow,strel('square',2*snpix+1));
end

cs_final(Water==1)=1;
% mask from plcloud
% step 1 snow or unknow
cs_final(Snow==1)=3; % snow
% step 2 shadow above snow and everyting
cs_final(shadow_cal==1)=2; %shadow
% step 3 cloud above all
cs_final(cloud_cal==1)=4; % cloud
cs_final(boundary_test==0)=255;
% reedit dir_im
norln=strread(dir_im,'%s','delimiter','.'); 
n_name=char(norln(1));
enviwrite([n_name,'Fmask'],cs_final,'uint8',resolu,jiUL,'bsq',ZC);
% record clear pixel percent;
tmpcs = cs_final <= 1;
clr_pct = 100*sum(tmpcs(:))/sum(boundary_test(:));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(functions)%%%%%%%%%%%%%%%

% viewgeo function
function [A,B,C,omiga_par,omiga_per]=viewgeo(x_ul,y_ul,x_ur,y_ur,x_ll,y_ll,x_lr,y_lr)
% imput "x",j
% imput "y",i
% imput cloud height "h"

x_u=(x_ul+x_ur)/2;
x_l=(x_ll+x_lr)/2;
y_u=(y_ul+y_ur)/2;
y_l=(y_ll+y_lr)/2;

K_ulr=(y_ul-y_ur)/(x_ul-x_ur); % get k of the upper left and right points
K_llr=(y_ll-y_lr)/(x_ll-x_lr); % get k of the lower left and right points
K_aver=(K_ulr+K_llr)/2;
omiga_par=atan(K_aver); % get the angle of parallel lines k (in pi)

% AX(j)+BY(i)+C=0
A=y_u-y_l;
B=x_l-x_u;
C=y_l*x_u-x_l*y_u;

omiga_per=atan(B/A); % get the angle which is perpendicular to the trace line

end

% mat_truecloud function
function [x_new,y_new]=mat_truecloud(x,y,h,A,B,C,omiga_par,omiga_per)
% imput "x",j col
% imput "y",i row
% imput cloud height "h"
H=705000; % average Landsat 4,5,&7 height (m)
dist=(A*x+B*y+C)/((A^2+B^2)^(0.5));% from the cetral perpendicular (unit: pixel)
dist_par=dist/cos(omiga_per-omiga_par);
dist_move=dist_par.*h/H; % cloud move distance (m);
delt_x=dist_move*cos(omiga_par);
delt_y=dist_move*sin(omiga_par);

x_new=x+delt_x; % new x, j
y_new=y+delt_y; % new y, i
end