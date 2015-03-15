# Introduction #

This Wiki helps the use of Fmask (1.6.3sav) algorithm for automated clouds, cloud shadows, and snow detection in Landsat TM/ETM+ images.

**What's new in Fmask1.6.3sav compared to Fmask1.6.3v?**

% Re-calibrated the scene-based threshold (cloud probability) for defining clouds (22.5 in 1.6.3sav and 20 in 1.6.3v) (Zhe Zhu 01/09/2012)

% Made it a stand alone version (Zhe Zhu 01/09/2012)

% Impoved accuracy in TOA reflectance computing in two ways: firstly, used more recent ESUN provied by Chander et al., (2009), RSE.; secondly, used more accuate Sun-Earth distance table provided by Chander et al., (2009), RSE. (Zhe Zhu 01/07/2012)

**Revisions of Fmask1.6.3sav since it has been released:**

% Fixed bugs caused by earth-sun distance table (by Zhe Zhu 01/15/2012)

If you have download Fmask1.6.3sav before the revision date, please re-download it again. The version number will not change if there are only minor changes with bugs fixed. If there are significant changes in the algorithm principles, the version number will change.

# Details #

The Fmask software can be installed both in Linux, MS, and Mac. Fmask need computers with large memory (5Gb+).

After downloading an image from glovis, you need to unzip the data and start the Matlab environment.

**How to run Fmask (1.6.3sav)**

For BU student, Fmask1.6.3v is already installed, you only need to do the following steps. For other, you need to download Fmask algorithm and unzip it before the following steps.

Step 1: open matlab from you linux window or from local PC

> matlab

(this will open a new matlab window)

Step 2: cd data\_dir

(the folder where your landsat image is)

Step 3: addpath(‘/Fmask folder/Fmask\_1\_6\_3sav’);

For BU students, the command should be addpath('/net/blacksea/fs/bs11/zhuzhe/Fmask\_1\_6\_3sav');

(Set up each time when you open a new matlab window in step 3)

Setp 4: get in the folder where you saved you Landsat data and type the command “autoFmask\_1\_6sav”

(main commond for Fmask)

As the pixels around cloud and cloud shadow are sometimes influenced, Fmask will dilate eah cloud and cloud shadow objects. The default number of dilation pixels is 3 for both cloud and cloud shadow. If you wanted to set up your own dilation pixel number, you can custom the number of dilated cloud pixels (num\_cloud\_dilate) and the number of dilated cloud shadow pixels (num\_shadow\_dilate) as follows in step 4:
“autoFmask\_1\_6(num\_cloud\_dilate,num\_shadow\_dialte)”. Moreover, the Fmask algorithm used a scene-based threshold for cloud probability computing, it maynot be perfict everytime, and you can modify the default probability (a value of 22.5 for Fmask\_1\_6\_3sav) by examing the results. This variable can be from 0 to 100, the smaller the value, the more clouds captured, but also more commission errors of clouds. User's can customize by themself. The default value is an optimum value tested by a global set of reference images (see the paper for details). You can use the commond "auto\_Fmask\_1\_6(num\_cloud\_dilate,num\_shadow\_dilate,cloud\_probability)" to generate your customized map.

There is an image called XXXFmask\_1\_6\_3sav which can be opened by ENVI. The image values are presenting the following classes:

0=>clear land pixel

1=>clear water pixel

2=>cloud shadow

3=>snow

4=>cloud

255=>no observation