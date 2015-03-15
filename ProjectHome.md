# Fmask software #

**The 3.2 version of Fmask is ready to use now! Able to process Landsat 4, 5, 7, and 8 images on Windows and Linux machines.**

**Due to the failure of the Thermal Infrared Sensor (TIRS) after December 18, 2014 (DOY 352), the original Fmask algorithm developed for Landsat 8 would not work. Please use the Fmask 3.2 version designed for Sentinel 2 instead (Landsat 8 images without TIR bands). The Matlab code can be downloaded at this [link](https://www.dropbox.com/s/x8tidhlsjfhy5wi/FmaskSentinel.zip?dl=0) and the Windows stand alone software can be downloaded at this [link](https://www.dropbox.com/s/ar458c4miunaywy/Fmask_3_2.exe?dl=0).**

**Please cite the following papers:**

**[paper 1](http://www.sciencedirect.com/science/article/pii/S0034425711003853):
Zhu, Z. and Woodcock, C. E., Object-based cloud and cloud shadow detection in Landsat imagery, Remote Sensing of Environment (2012), doi:10.1016/j.rse.2011.10.028 (paper for Fmask version 1.6.).**

**[paper 2](https://www.dropbox.com/s/o72ydt9fn9egii3/New_Fmask.pdf?dl=0):
Zhu, Z. and Woodcock, C. E., Improvement and Expansion of the Fmask Algorithm:  Cloud, Cloud Shadow, and Snow Detection for Landsats 4-7, 8, and Sentinel 2 Images, Remote Sensing of Environment (in press) (paper for Fmask version 3.2.).**

This Matlab code called Fmask (Function of mask) is used for automated clouds, cloud shadows, and snow masking for Landsat TM/ETM+ images developed by [Zhe Zhu](https://sites.google.com/a/bu.edu/zhuzhe/home) (zhezhu@usgs.gov) at EROS, USGS and [Curtis E. Woodcock](http://www.bu.edu/geography/people/faculty/woodcock/) (curtis@bu.edu) at Center for Remote Sensing, Department of Earth and Environment, Boston University.

After running Fmask, there will be an image called XXXFmask that can be opened by ENVI. The image values are presenting the following classes:

0 => clear land pixel

1 => clear water pixel

2 => cloud shadow

3 => snow

4 => cloud

255 => no observation

## 3.2 Version ##

Updates (since 2.2):

1)  Detecting clouds for Landsat 8 using new bands (Zhe 09/04/2013)

2)  Remove high probability clouds to reduce commission error (Zhe 09/11/2013)

3)  Fix bugs in probs < 0 (Brightness\_prob & wTemp\_prob) (Zhe 09/11/2013)

4)  Add customized snow dilation pixel number (Zhe 09/12/2013)

5)  Fix problem in snow detection because of temperature screen (Zhe 09/12/2013)

6)  Remove default 3 pixels snow dilation (Zhe 09/20/2013)

7)  Fix bug in calculating r\_obj and change num\_pix value (Zhe 09/27/2013)

8)  Remove majority filter (Zhe 10/27/2013)

9) Add dynamic water threshold (Zhe 10/27/2013)

10) Exclude small cloud object < 3 pixels (Zhe 10/27/2013)

### Matlab ###

Need to install Matlab and have image process and statistics toolboxes and runs on Linux 64 bits machine with 4G+ memory. It can be download and used by the following steps:

1. Download the Matlab code for Fmask 3.2 version by this [link](https://www.dropbox.com/s/59b4o7tijsyag6e/Fmask.zip?dl=0) and unzip the Fmask folder.

2. Use "addpath" in Matlab environment for the Fmask folder.

3. Type "autoFmask" in the command window.

### Linux Executable ###

Stand alone Linux executable Fmask software which do not need to install Matlab or R and runs on Linux 64 bits machine with 4G+ memory. It is based on the same Fmask 3.2sav Matlab code and it can be download and used by the following steps:

1.  Download Fmask 3.2 version Linux package "Fmask\_pkg.zip"
Use any Brosweer and go to the following ftp sites:
http://ftp-earth.bu.edu/public/zhuzhe/Fmask_Linux_3.2v/

2.  Unzip the software using "unzip Fmask\_pkg.zip"

3.  There will be a new file called MCRInstaller.zip at the same folder and unzip this file.

4.  Install MCRInstaller by typing "./install" in the same folder

5.  There will be wizard that help you install and there will be two environment variables called "LD\_LIBRARY\_PATH" and "XAPPLRESDIR" showed up in the wizard. Copy the two variables.

For example, This is what I got:

"On the target computer, append the following to your LD\_LIBRARY\_PATH environment variable:

/home/amd64

Next, set the XAPPLRESDIR environment variable to the following value:

/home/app-defaults"

6.  Edit your .cshrc (.tcsh is the same, for .bash replace it with export LD\_LIBRARY\_PATH="...") file and add this

"setenv LD\_LIBRARY\_PATH /home/amd64"

"setenv XAPPLRESDIR /home/app-defaults"

7.  Save the shell or bash script and source it;

8.  Copy the "Fmask" software to any location you want (for example "/Tools/Fmask");

9.  cd into the folder where Landsat bands and .MTL files downloaded and run Fmask by entering "/Tools/Fmask" in the terminals.

There are four important tuning variables that you can play with:

1) "cldpix" is dilated number of pixels for cloud with default values of 3.

2) "sdpix" is dilated number of pixels for cloud shadow with default values of 3.

3) "snpix" is dilated number of pixels for snow with default values of 0.

4) "cldprob" is the cloud probability threshold with default values of 22.5 (range from 0~100). If you want to use default values "/Tools/Fmask" is enough, if you want to customize your own parameters, you can use "/Tools/Fmask cldpix sdpix snpix cldprob", for example "/Tools/Fmask 3 3 0 22.5" in the terminals

### Windows Executable ###

Stand alone Linux executable Fmask software which do not need to install Matlab or R and runs on Linux 64 bits machine with 4G+ memory. It is based on the same Fmask 3.2sav Matlab code and it can be download and used by the following steps:

1.  Download Fmask 3.2 version Windows package "Fmask\_pkg.exe"
Use any Brosweer and go to the following ftp sites:
http://ftp-earth.bu.edu/public/zhuzhe/Fmask_Windows_3.2v/

2.  Double click "Fmask\_pkg.exe" and install it with wizard.

3.  There will be a new file called "Fmask.exe" at the same folder and this is your Fmask software

4.  Copy the "Fmask.exe" software to any location you want (for example "c:\Tools");

5.  cd into the folder where Landsat bands and .MTL files downloaded and run Fmask by entering "c:\Tools\Fmask" in the Command Prompt you can find in the Accessories.

There are four important tuning variables that you can play with:

1) "cldpix" is dilated number of pixels for cloud with default values of 3.

2) "sdpix" is dilated number of pixels for cloud shadow with default values of 3.

3) "snpix" is dilated number of pixels for snow with default values of 0.

4) "cldprob" is the" cloud probability threshold with default values of 22.5 (range from 0~100). If you want to use default values "c:\Tools\Fmask" is enough, if you want to customize your own parameters, you can use “c:\Tools\Fmask cldpix sdpix snpix cldprob", for example “c:\Tools\Fmask 3 3 0 22.5"in the terminals

### CFmask ###

There is also a C version of Fmask 3.2 version performed by USGS. See their site for details [here](http://code.google.com/p/cfmask/).

## 2.2 Version ##

Updates (since 2.1):

1) Fixed a bug find in writing the ENVI header for the UTM zone number (Zhe 02/26/2013).

2) Better cloud and cloud shadow matching results (Zhe 03/01/2013)

### Linux Executable ###

Stand alone Linux executable Fmask software which do not need to install Matlab or R and runs on Linux 64 bits machine with 4G+ memory. It is based on the same Fmask 2.2sav Matlab code and can be downloaded at the "Downloads" tab with help files in the "Wiki" tab.

### Windows Executable ###

Stand alone Windows executable Fmask software created by Sean Griffin (segriffin@gmail.com) which do not need to install Matlab or R and runs on Windows 64 bits machine with 4G+ memory. It is based on the same Fmask 2.2sav Matlab code and can be downloaded at the "Downloads" tab with help files in the "Wiki" tab.

## 2.1 Version ##

Updates (since 2.0):

1) Process both the new and old "MTL.txt" metadata (Zhe Zhu 10/18/2012)

### Matlab ###

On August 29, 2012, filenames and metadata files associated with the Landsat Level 1 Products has been changed. Modifications are being made to make filenames, metadata fields, and files consistent for all sensors, including upcoming LDCM (Landsat 8) data products. The previous 1.6.3 and 1.6.3sav Matlab version will not be able to work for Landsat data downloaded later than August 29, 2012.

You need to have Matlab software with statistic and image process toolboxes installed on 64 bits machine with 4+G memory.
The Fmask 2.1sav software are located at the ["Downloads"](http://code.google.com/p/fmask/downloads/list) tab and the help files are in the ["Wiki"](http://code.google.com/p/fmask/w/list) tab.

### Windows Executable ###

This website also hosts a stand alone Windows executable Fmask software created by Sean Griffin (segriffin@gmail.com) which do not need to install Matlab or R and runs on Windows 64 bits machine with 4G+ memory. It is based on the same Fmask 2.1sav Matlab code and can be at the "Downloads" tab with help files in the "Wiki" tab.


## 2.0 Version ##

Updates (since 1.6.3):

1) Process TM and ETM+ images with the new "MTL.txt" metadata (Zhe Zhu 09/28/2012)

2) Change the Fmask band name to "Fmask" (Zhe 09/27/2012)

3) Dilate snow by default 3 pixels in 8 connect directions (by Zhe 05/24/2012)

4) Exclude small cloud object <= 9 pixels (by Zhe 03/07/2012)

### Matlab ###

The Fmask 2.0sav software can only process the new Landsat metadata format downloaded after August 29, 2012. It includes the most recent updates since 1.6.3sav as follows:


## 1.6.3 Version ##

### Matlab ###

The Fmask 1.6.3 & Fmask 1.6.3sav software can only process the old Landsat metadata format downloaded before August 29, 2012.

Two Matlab versions of Fmask: 1.6.3 Version need to use LEDAPS to prepare inputs for Fmask (works with WO.txt and MTL.txt header); 1.6.3 Stand Alone Version (sav) can be run in Matlab environment directly (works with MTL.txt header at the moment). The Fmask 1.6.3v and 1.6.3sav software are located at the ["Downloads"](http://code.google.com/p/fmask/downloads/list) tab and the help files are in the ["Wiki"](http://code.google.com/p/fmask/w/list) tab.

The Fmask1.6.3 version has been validated with the 142 Landsat reference scenes distributed in different continents and the overall accuracy has improved more than 0.06% (overall accuracy of 96.47%) since the 1.6.0 version explained in following paper.

### R ###

There is also a R script translated from Matlab 1.6.3sav version (They will code the most recent Fmask algorithm soon) performed by Joseph Henry (joseph.henry@sydney.edu.au) and Willem Vervoort (willem.vervoort@sydney.edu.au) at Department of Environmental Sciences, Faculty of Agriculture and Environment, The University of Sydney, Australia. See their site for details [here](http://code.google.com/p/fmask-for-r/).