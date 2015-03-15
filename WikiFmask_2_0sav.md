# Introduction #

This Wiki helps the use of Fmask (2.0sav) algorithm for automated clouds, cloud shadows, and snow detection in Landsat TM/ETM+ images.

**What's new in Fmask2.0sav compared to Fmask1.6.3sav?**

% Process TM and ETM+ images with the new "MTL.txt" metadata (Zhe Zhu 09/28/2012)

% Change the Fmask band name to "XXXXFmask" (Zhe 09/27/2012)

% Dilate snow by default 3 pixels in 8 connect directions (by Zhe 05/24/2012)

% Exclude small cloud object <= 9 pixels (by Zhe 03/07/2012)

# Details #

The Fmask software can be installed both in Linux, MS, and Mac. Fmask need computers with large memory (5Gb+).

After downloading an image from glovis, you need to unzip the data and start the Matlab environment.

**How to run Fmask (2.0sav)**

For BU student, Fmask2.0v is already installed, you only need to do the following steps. For other, you need to download Fmask algorithm and unzip it before the following steps.

Step 1: open matlab from you linux window or from local PC

> matlab

(this will open a new matlab window)

Step 2: cd data\_dir

(the folder where your landsat image is)

Step 3: addpath(‘/Fmask folder/Fmask\_2\_0sav’);

For BU students, the command should be addpath('/net/blacksea/fs/bs11/zhuzhe/Fmask\_2\_0sav');

(Set up each time when you open a new matlab window in step 3)

Setp 4: get in the folder where you saved you Landsat data and type the command “autoFmask\_2\_0sav”

(main commond for Fmask)

As the pixels around cloud and cloud shadow are sometimes influenced, Fmask will dilate eah cloud and cloud shadow objects. The default number of dilation pixels is 3 for both cloud and cloud shadow. If you wanted to set up your own dilation pixel number, you can custom the number of dilated cloud pixels (num\_cloud\_dilate) and the number of dilated cloud shadow pixels (num\_shadow\_dilate) as follows in step 4:
“autoFmask\_2\_0sav(num\_cloud\_dilate,num\_shadow\_dialte)”. Moreover, the Fmask algorithm used a scene-based threshold for cloud probability computing, it maynot be perfict everytime, and you can modify the default probability (a value of 22.5 for Fmask\_2\_0sav) by examing the results. This variable can be from 0 to 100, the smaller the value, the more clouds captured, but also more commission errors of clouds. User's can customize by themself. The default value is an optimum value tested by a global set of reference images (see the paper for details). You can use the commond "auto\_Fmask\_2\_0sav(num\_cloud\_dilate,num\_shadow\_dilate,cloud\_probability)" to generate your customized map.

There is an image called XXXFmask which can be opened by ENVI. The image values are presenting the following classes:

0=>clear land pixel

1=>clear water pixel

2=>cloud shadow

3=>snow

4=>cloud

255=>no observation