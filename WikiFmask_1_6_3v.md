# Introduction #

This Wiki helps the use of Fmask (1.6.3v) algorithm for automated clouds, cloud shadows, and snow detection in Landsat TM/ETM+ images.

# Details #

The software for doing atmospheric correction is called LEDAPS and Zhe Zhu’s clouds, cloud shadows, snow masking program is called Fmask. LEDAPS is used to prepare the inputs for Fmask. LEDAPS need to be installed in Linux server and we need to make some modifications to the current version of LEDAPS before using it. The current version of LEDAPS give filled value for saturated pixels which would influence cloud and cloud shadow detection, therefore, we need to keep the saturated pixels. You need to do the follows after installed LEDAPS: 1) open "cal.h" in src/lndcal; 2) replace line static const int SATU\_VAL[
7
]={255,255,255,255,255,255,255} with static const in SATU\_VAL[
7
]
={266,266,266,266,266,266,266}; 3) recompile LEDAPS. That's all. The LEDAPS software can be downloaded from the website below:
http://ledaps.nascom.nasa.gov/tools/tools.html
LEDAPS should be installed in Linux and Fmask can be installed both in Linux, MS, and Mac. Fmask need computers with large memory (5Gb+).

After downloading an image from glovis, you need to unzip the data and put the data into the same folder as the original zip file.

For Boston University student, LEDAPS is already installed locally. You can do the follow to run it.

To run things on a Linux server from PCs, you need to open a window – and this can be done using X-Win32.

**1.	How to run LEDAPS**

The first time you want to run LEDAPS, you need to add the following to your .cshrc file so that you will find the software.
Go to your home directory (active\_users/yourname) and type 'nedit .cshrc' – which will open a window that you can use to edit your .cshrc file.  Add the following to the bottom of your .cshrc file:

## Ledaps atmosphere correction

source /net/blacksea/fs/bs11/zhuzhe/lndref/ledaps.sh

You only have to do this once – and then every time you login to use your account it will know where to look for the LEDAPS commands.  The first time, you need to logout and then login again to execute the new version of the .cshrc file.

Run the LEDAPS programs in the following sequences

> cd data\_dir

(the folder where your landsat image is)

> lndpm L\*MTL.txt

(get the variables)

> lndcal lndcal.XXX.txt

(get TOA reflectance)

> lndcsm lndcsm.XXX.txt

(get cloud and snow mask using ACCA)

> lndsr lndsr.XXX.txt

(get surface reflectance)


Or you can use the new commond to do all step at once
> do\_ledaps.csh L\*MTL.txt

**2.	How to run Fmask (1.6.3 version)**

For BU student, Fmask1.6.3v is already installed, you only need to do the following steps. For other, you need to download Fmask algorithm and unzip it before the following steps.

Step 1: open matlab from you linux window or from local PC

> matlab

(this will open a new matlab window)

Step 2: cd data\_dir

(the folder where your landsat image is)

Step 3: addpath(‘/Fmask folder/Fmask\_1\_6\_3v’);

For BU students, the command should be addpath('/net/blacksea/fs/bs11/zhuzhe/Fmask\_1\_6\_3v');

(Set up each time when you open a new matlab window in step 3)

Setp 4: type the command “autoFmask\_1\_6”

(main commond for Fmask)

Before run Fmask you need to run LEDAPS to derive the TOA refletance data and Brightness Temperature data as the main inputs for Fmask. Do not delete the original DN images (will be used to extract saturated values) and save each Landsat images within one folder separately. As the pixels around cloud and cloud shadow are sometimes influenced, Fmask will dilate eah cloud and cloud shadow objects. The default number of dilation pixels is 3 for both cloud and cloud shadow. If you wanted to set up your own dilation pixel number, you can custom the number of dilated cloud pixels (num\_cloud\_dilate) and the number of dilated cloud shadow pixels (num\_shadow\_dilate) as follows in step 4:
“autoFmask\_1\_6(num\_cloud\_dilate,num\_shadow\_dialte)”. Moreover, the Fmask algorithm used a scene-based threshold for cloud probability computing, it maynot be perfict everytime, and you can modify the default probability (a value of 20) by examing the results. This variable can be from 0 to 100, the smaller the value, the more clouds captured, but also more commission errors of clouds. User's can customize by themself. The default value is an optimum value tested by a global set of reference images (see the paper for details). You can use the commond "auto\_Fmask\_1\_6(num\_cloud\_dilate,num\_shadow\_dilate,cloud\_probability)" to generate your customized map.

There is an image called XXXFmask\_1\_6\_3v which can be opened by ENVI, in the image,

0=>clear land pixel

1=>clear water pixel

2=>cloud shadow

3=>snow

4=>cloud

255=>no observation