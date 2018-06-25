function [im_th,TOAref,ijdim_ref,ul,zen,azi,zc,B1Satu,B2Satu,B3Satu,resolu]=nd2toarbt(filename)
% convert DNs to TOA ref and BT
% Revisions:
% Use REF vs. DN instead of RAD vs. DN (Zhe 06/20/2013)
% Combined the Earth-Sun distance table into the function (Zhe 04/09/2013)
% Process Landsat 8 DN values (Zhe 04/04/2013)
% Proces the new metadata for Landsat TM/ETM+ images (Zhe 09/28/2012)
% Fixed bugs caused by earth-sun distance table (Zhe 01/15/2012)
%
% [im_th,TOAref,ijdim_ref,ul,zen,azi,zc,B1Satu,B2Satu,B3Satu,resolu]=nd2toarbt(filename)
% Where:
% Inputs:
% filename='L*MTL.txt';
% Outputs:
% 1) im_th = Brightness Temperature (BT)
% 2) TOAref = Top Of Atmoshpere (TOA) reflectance
% 3) ijdim = [nrows,ncols]; % dimension of optical bands
% 4) ul = [upperleft_mapx upperleft_mapy];
% 5) zen = solar zenith angle (degrees);
% 6) azi = solar azimuth angle (degrees);
% 7) zc = Zone Number
% 8,9,10) Saturation (true) in the Visible bands
% 11) resolution of Fmask results

fprintf('Read in header information & TIF images\n');
[Lmax,Lmin,Qcalmax,Qcalmin,Refmax,Refmin,ijdim_ref,ijdim_thm,reso_ref,...
    reso_thm,ul,zen,azi,zc,Lnum,doy]=lndhdrread(filename);

% earth-sun distance see G. Chander et al. RSE 113 (2009) 893-903
Tab_ES_Dist = [
    1 0.98331
    2 0.98330
    3 0.98330
    4 0.98330
    5 0.98330
    6 0.98332
    7 0.98333
    8 0.98335
    9 0.98338
    10 0.98341
    11 0.98345
    12 0.98349
    13 0.98354
    14 0.98359
    15 0.98365
    16 0.98371
    17 0.98378
    18 0.98385
    19 0.98393
    20 0.98401
    21 0.98410
    22 0.98419
    23 0.98428
    24 0.98439
    25 0.98449
    26 0.98460
    27 0.98472
    28 0.98484
    29 0.98496
    30 0.98509
    31 0.98523
    32 0.98536
    33 0.98551
    34 0.98565
    35 0.98580
    36 0.98596
    37 0.98612
    38 0.98628
    39 0.98645
    40 0.98662
    41 0.98680
    42 0.98698
    43 0.98717
    44 0.98735
    45 0.98755
    46 0.98774
    47 0.98794
    48 0.98814
    49 0.98835
    50 0.98856
    51 0.98877
    52 0.98899
    53 0.98921
    54 0.98944
    55 0.98966
    56 0.98989
    57 0.99012
    58 0.99036
    59 0.99060
    60 0.99084
    61 0.99108
    62 0.99133
    63 0.99158
    64 0.99183
    65 0.99208
    66 0.99234
    67 0.99260
    68 0.99286
    69 0.99312
    70 0.99339
    71 0.99365
    72 0.99392
    73 0.99419
    74 0.99446
    75 0.99474
    76 0.99501
    77 0.99529
    78 0.99556
    79 0.99584
    80 0.99612
    81 0.99640
    82 0.99669
    83 0.99697
    84 0.99725
    85 0.99754
    86 0.99782
    87 0.99811
    88 0.99840
    89 0.99868
    90 0.99897
    91 0.99926
    92 0.99954
    93 0.99983
    94 1.00012
    95 1.00041
    96 1.00069
    97 1.00098
    98 1.00127
    99 1.00155
    100 1.00184
    101 1.00212
    102 1.00240
    103 1.00269
    104 1.00297
    105 1.00325
    106 1.00353
    107 1.00381
    108 1.00409
    109 1.00437
    110 1.00464
    111 1.00492
    112 1.00519
    113 1.00546
    114 1.00573
    115 1.00600
    116 1.00626
    117 1.00653
    118 1.00679
    119 1.00705
    120 1.00731
    121 1.00756
    122 1.00781
    123 1.00806
    124 1.00831
    125 1.00856
    126 1.00880
    127 1.00904
    128 1.00928
    129 1.00952
    130 1.00975
    131 1.00998
    132 1.01020
    133 1.01043
    134 1.01065
    135 1.01087
    136 1.01108
    137 1.01129
    138 1.01150
    139 1.01170
    140 1.01191
    141 1.01210
    142 1.01230
    143 1.01249
    144 1.01267
    145 1.01286
    146 1.01304
    147 1.01321
    148 1.01338
    149 1.01355
    150 1.01371
    151 1.01387
    152 1.01403
    153 1.01418
    154 1.01433
    155 1.01447
    156 1.01461
    157 1.01475
    158 1.01488
    159 1.01500
    160 1.01513
    161 1.01524
    162 1.01536
    163 1.01547
    164 1.01557
    165 1.01567
    166 1.01577
    167 1.01586
    168 1.01595
    169 1.01603
    170 1.01610
    171 1.01618
    172 1.01625
    173 1.01631
    174 1.01637
    175 1.01642
    176 1.01647
    177 1.01652
    178 1.01656
    179 1.01659
    180 1.01662
    181 1.01665
    182 1.01667
    183 1.01668
    184 1.01670
    185 1.01670
    186 1.01670
    187 1.01670
    188 1.01669
    189 1.01668
    190 1.01666
    191 1.01664
    192 1.01661
    193 1.01658
    194 1.01655
    195 1.01650
    196 1.01646
    197 1.01641
    198 1.01635
    199 1.01629
    200 1.01623
    201 1.01616
    202 1.01609
    203 1.01601
    204 1.01592
    205 1.01584
    206 1.01575
    207 1.01565
    208 1.01555
    209 1.01544
    210 1.01533
    211 1.01522
    212 1.01510
    213 1.01497
    214 1.01485
    215 1.01471
    216 1.01458
    217 1.01444
    218 1.01429
    219 1.01414
    220 1.01399
    221 1.01383
    222 1.01367
    223 1.01351
    224 1.01334
    225 1.01317
    226 1.01299
    227 1.01281
    228 1.01263
    229 1.01244
    230 1.01225
    231 1.01205
    232 1.01186
    233 1.01165
    234 1.01145
    235 1.01124
    236 1.01103
    237 1.01081
    238 1.01060
    239 1.01037
    240 1.01015
    241 1.00992
    242 1.00969
    243 1.00946
    244 1.00922
    245 1.00898
    246 1.00874
    247 1.00850
    248 1.00825
    249 1.00800
    250 1.00775
    251 1.00750
    252 1.00724
    253 1.00698
    254 1.00672
    255 1.00646
    256 1.00620
    257 1.00593
    258 1.00566
    259 1.00539
    260 1.00512
    261 1.00485
    262 1.00457
    263 1.00430
    264 1.00402
    265 1.00374
    266 1.00346
    267 1.00318
    268 1.00290
    269 1.00262
    270 1.00234
    271 1.00205
    272 1.00177
    273 1.00148
    274 1.00119
    275 1.00091
    276 1.00062
    277 1.00033
    278 1.00005
    279 0.99976
    280 0.99947
    281 0.99918
    282 0.99890
    283 0.99861
    284 0.99832
    285 0.99804
    286 0.99775
    287 0.99747
    288 0.99718
    289 0.99690
    290 0.99662
    291 0.99634
    292 0.99605
    293 0.99577
    294 0.99550
    295 0.99522
    296 0.99494
    297 0.99467
    298 0.99440
    299 0.99412
    300 0.99385
    301 0.99359
    302 0.99332
    303 0.99306
    304 0.99279
    305 0.99253
    306 0.99228
    307 0.99202
    308 0.99177
    309 0.99152
    310 0.99127
    311 0.99102
    312 0.99078
    313 0.99054
    314 0.99030
    315 0.99007
    316 0.98983
    317 0.98961
    318 0.98938
    319 0.98916
    320 0.98894
    321 0.98872
    322 0.98851
    323 0.98830
    324 0.98809
    325 0.98789
    326 0.98769
    327 0.98750
    328 0.98731
    329 0.98712
    330 0.98694
    331 0.98676
    332 0.98658
    333 0.98641
    334 0.98624
    335 0.98608
    336 0.98592
    337 0.98577
    338 0.98562
    339 0.98547
    340 0.98533
    341 0.98519
    342 0.98506
    343 0.98493
    344 0.98481
    345 0.98469
    346 0.98457
    347 0.98446
    348 0.98436
    349 0.98426
    350 0.98416
    351 0.98407
    352 0.98399
    353 0.98391
    354 0.98383
    355 0.98376
    356 0.98370
    357 0.98363
    358 0.98358
    359 0.98353
    360 0.98348
    361 0.98344
    362 0.98340
    363 0.98337
    364 0.98335
    365 0.98333
    366 0.98331];

if Lnum >= 4 && Lnum <= 7
    % LPGS Upper lef corner alignment (see Landsat handbook for detail)
    ul(1)=ul(1)-15;
    ul(2)=ul(2)+15;
    resolu=[reso_ref,reso_ref];
    % Read in all bands
    % Band1
    n_B1=dir('*B1*');
    im_B1=single(imread(n_B1.name));
    % Band2
    n_B2=dir('*B2*');
    im_B2=single(imread(n_B2.name));
    % Band3
    n_B3=dir('*B3*');
    im_B3=single(imread(n_B3.name));
    % Band4
    n_B4=dir('*B4*');
    im_B4=single(imread(n_B4.name));
    % Band5
    n_B5=dir('*B5*');
    im_B5=single(imread(n_B5.name));
    % Band6
    if Lnum==7
        n_B6=dir('*B6*1*');
    else
        n_B6=dir('*B6*');
    end
    im_th=single(imread(n_B6.name));
    % check to see whether need to resample thermal band
    if reso_ref~=reso_thm
        % resmaple thermal band
        im_th=pixel2pixv([ul(2),ul(1)],[ul(2),ul(1)],...
            resolu,[reso_thm,reso_thm],...
            im_th,[ijdim_ref(2),ijdim_ref(1)],[ijdim_thm(2),ijdim_thm(1)]);
    end
    % Band7
    n_B7=dir('*B7*');
    im_B7=single(imread(n_B7.name));
    % only processing pixesl where all bands have values (id_mssing)
    id_missing=im_B1==0|im_B2==0|im_B3==0|im_B4==0|im_B5==0|im_th==0|im_B7==0;
    % find pixels that are saturated in the visible bands
    B1Satu=im_B1==255;
    B2Satu=im_B2==255;
    B3Satu=im_B3==255;
    
    % ND to radiance first
    fprintf('From DNs to TOA ref & BT\n');
    im_B1=((Lmax(1)-Lmin(1))/(Qcalmax(1)-Qcalmin(1)))*(im_B1-Qcalmin(1))+Lmin(1);
    im_B2=((Lmax(2)-Lmin(2))/(Qcalmax(2)-Qcalmin(2)))*(im_B2-Qcalmin(2))+Lmin(2);
    im_B3=((Lmax(3)-Lmin(3))/(Qcalmax(3)-Qcalmin(3)))*(im_B3-Qcalmin(3))+Lmin(3);
    im_B4=((Lmax(4)-Lmin(4))/(Qcalmax(4)-Qcalmin(4)))*(im_B4-Qcalmin(4))+Lmin(4);
    im_B5=((Lmax(5)-Lmin(5))/(Qcalmax(5)-Qcalmin(5)))*(im_B5-Qcalmin(5))+Lmin(5);
    im_th=((Lmax(6)-Lmin(6))/(Qcalmax(6)-Qcalmin(6)))*(im_th-Qcalmin(6))+Lmin(6);
    im_B7=((Lmax(7)-Lmin(7))/(Qcalmax(7)-Qcalmin(7)))*(im_B7-Qcalmin(7))+Lmin(7);
    
    % Landsat 4, 5, and 7 solar spectral irradiance
    % see G. Chander et al. RSE 113 (2009) 893-903
    esun_L7=[1997.000, 1812.000, 1533.000, 1039.000, 230.800, -1.0, 84.90];
    esun_L5=[1983.0, 1796.0, 1536.0, 1031.0, 220.0, -1.0, 83.44];
    esun_L4=[1983.0, 1795.0, 1539.0, 1028.0, 219.8, -1.0, 83.49];
    
    if Lnum==7
        ESUN=esun_L7;
    elseif Lnum==5
        ESUN=esun_L5;
    elseif Lnum==4
        ESUN=esun_L4;
    end
    
    % earth-sun distance see G. Chander et al. RSE 113 (2009) 893-903    
    dsun_doy = Tab_ES_Dist(doy,2);
    
    % compute TOA reflectances
    % converted from degrees to radiance
    s_zen=deg2rad(zen);
    im_B1=10^4*pi*im_B1*dsun_doy^2/(ESUN(1)*cos(s_zen));
    im_B2=10^4*pi*im_B2*dsun_doy^2/(ESUN(2)*cos(s_zen));
    im_B3=10^4*pi*im_B3*dsun_doy^2/(ESUN(3)*cos(s_zen));
    im_B4=10^4*pi*im_B4*dsun_doy^2/(ESUN(4)*cos(s_zen));
    im_B5=10^4*pi*im_B5*dsun_doy^2/(ESUN(5)*cos(s_zen));
    im_B7=10^4*pi*im_B7*dsun_doy^2/(ESUN(7)*cos(s_zen));
    
    % convert Band6 from radiance to BT
    % fprintf('From Band 6 Radiance to Brightness Temperature\n');
    % see G. Chander et al. RSE 113 (2009) 893-903
    K1_L4=  671.62;
    K2_L4= 1284.30;
    K1_L5=  607.76;
    K2_L5= 1260.56;
    K1_L7 =  666.09;
    K2_L7 = 1282.71;
    
    if Lnum==7
        K1=K1_L7;
        K2=K2_L7;
    elseif Lnum==5
        K1=K1_L5;
        K2=K2_L5;
    elseif Lnum==4
        K1=K1_L4;
        K2=K2_L4;
    end
    
    im_th=K2./log((K1./im_th)+1);
    % convert from Kelvin to Celcius with 0.01 scale_facor
    im_th=100*(im_th-273.15);
    % get data ready for Fmask
    TOAref=zeros(ijdim_ref(1),ijdim_ref(2),6,'single');% Band1,2,3,4,5,&7
    im_B1(id_missing)=-9999;
    im_B2(id_missing)=-9999;
    im_B3(id_missing)=-9999;
    im_B4(id_missing)=-9999;
    im_B5(id_missing)=-9999;
    im_th(id_missing)=-9999;
    im_B7(id_missing)=-9999;
    
    TOAref(:,:,1)=im_B1;
    TOAref(:,:,2)=im_B2;
    TOAref(:,:,3)=im_B3;
    TOAref(:,:,4)=im_B4;
    TOAref(:,:,5)=im_B5;
    TOAref(:,:,6)=im_B7;
    
elseif Lnum == 8
    % LPGS Upper lef corner alignment (see Landsat handbook for detail)
    ul(1)=ul(1)-15;
    ul(2)=ul(2)+15;
    resolu=[reso_ref,reso_ref];
    % Read in all bands
    % Band2
    n_B2=dir('*B2*');
    im_B2=single(imread(n_B2.name));
    % Band3
    n_B3=dir('*B3*');
    im_B3=single(imread(n_B3.name));
    % Band4
    n_B4=dir('*B4*');
    im_B4=single(imread(n_B4.name));
    % Band5
    n_B5=dir('*B5*');
    im_B5=single(imread(n_B5.name));
    % Band6
    n_B6=dir('*B6*');
    im_B6=single(imread(n_B6.name));
    % Band7
    n_B7=dir('*B7*');
    im_B7=single(imread(n_B7.name));
    % Band9
    n_B9=dir('*B9*');
    im_B9=single(imread(n_B9.name));
    % Band10
    n_B10=dir('*B10*');
    im_B10=single(imread(n_B10.name));

    % check to see whether need to resample thermal band
    if reso_ref~=reso_thm
        % resmaple thermal band
        im_B10=pixel2pixv([ul(2),ul(1)],[ul(2),ul(1)],...
            resolu,[reso_thm,reso_thm],...
            im_B10,[ijdim_ref(2),ijdim_ref(1)],[ijdim_thm(2),ijdim_thm(1)]);
    end
    
    % only processing pixesl where all bands have values (id_mssing)
    id_missing=im_B2==0|im_B3==0|im_B4==0|im_B5==0|im_B6==0|im_B7==0|im_B9==0|im_B10==0;
    % find pixels that are saturated in the visible bands
    B1Satu=im_B2==65535;
    B2Satu=im_B3==65535;
    B3Satu=im_B4==65535;
    
    % ND to TOA reflectance with 0.0001 scale_facor
    fprintf('From DNs to TOA ref & BT\n');
    im_B2=((Refmax(1)-Refmin(1))/(Qcalmax(1)-Qcalmin(1)))*(im_B2-Qcalmin(1))+Refmin(1);
    im_B3=((Refmax(2)-Refmin(2))/(Qcalmax(2)-Qcalmin(2)))*(im_B3-Qcalmin(2))+Refmin(2);
    im_B4=((Refmax(3)-Refmin(3))/(Qcalmax(3)-Qcalmin(3)))*(im_B4-Qcalmin(3))+Refmin(3);
    im_B5=((Refmax(4)-Refmin(4))/(Qcalmax(4)-Qcalmin(4)))*(im_B5-Qcalmin(4))+Refmin(4);
    im_B6=((Refmax(5)-Refmin(5))/(Qcalmax(5)-Qcalmin(5)))*(im_B6-Qcalmin(5))+Refmin(5);
    im_B7=((Refmax(6)-Refmin(6))/(Qcalmax(6)-Qcalmin(6)))*(im_B7-Qcalmin(6))+Refmin(6);
    im_B9=((Refmax(7)-Refmin(7))/(Qcalmax(7)-Qcalmin(7)))*(im_B9-Qcalmin(7))+Refmin(7);
    im_B10=((Lmax(8)-Lmin(8))/(Qcalmax(8)-Qcalmin(8)))*(im_B10-Qcalmin(8))+Lmin(8);
          
    % compute TOA reflectances
    % with a correction for the sun angle
    s_zen=deg2rad(zen);
    im_B2=10^4*im_B2/cos(s_zen);
    im_B3=10^4*im_B3/cos(s_zen);
    im_B4=10^4*im_B4/cos(s_zen);
    im_B5=10^4*im_B5/cos(s_zen);
    im_B6=10^4*im_B6/cos(s_zen);
    im_B7=10^4*im_B7/cos(s_zen);
    im_B9=10^4*im_B9/cos(s_zen);
    
    % convert Band6 from radiance to BT
    % fprintf('From Band 6 Radiance to Brightness Temperature\n');
    K1_B10 =  774.89;
    K2_B10 = 1321.08;
    
    im_B10=K2_B10./log((K1_B10./im_B10)+1);

    % convert from Kelvin to Celcius with 0.01 scale_facor
    im_B10=100*(im_B10-273.15);

    % get data ready for Fmask
    TOAref=zeros(ijdim_ref(1),ijdim_ref(2),7,'single');% Band 2,3,4,5,6,7,& 9
    im_B2(id_missing)=-9999;
    im_B3(id_missing)=-9999;
    im_B4(id_missing)=-9999;
    im_B5(id_missing)=-9999;
    im_B6(id_missing)=-9999;
    im_B7(id_missing)=-9999;
    im_B9(id_missing)=-9999;
    
    TOAref(:,:,1)=im_B2;
    TOAref(:,:,2)=im_B3;
    TOAref(:,:,3)=im_B4;
    TOAref(:,:,4)=im_B5;
    TOAref(:,:,5)=im_B6;
    TOAref(:,:,6)=im_B7;
    TOAref(:,:,7)=im_B9;
    
    im_th=zeros(ijdim_ref(1),ijdim_ref(2),'single');% Band 10 
    im_B10(id_missing) = -9999;
    im_th(:,:) = im_B10;    
else
    fprintf('This sensor is not Landsat 4, 5, 7, or 8!\n');
    return;
end

end

