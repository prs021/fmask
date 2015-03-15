# Introduction #

This Wiki helps the use of the stand alone Windows executable Fmask 2.1 version algorithm for automated clouds, cloud shadows, and snow detection in Landsat TM/ETM+ images. This wiki take Fmask 2.1 for example, you can updated to newer versions similarly.


# Details #

This stand alone Windows executable Fmask software is created by Sean Griffin (segriffin@gmail.com) which do not need to install Matlab or R and runs on Windows 64 bits machine with 4G memory.

**How to install it**

1.  Unpack Fmask\_pkg.exe (contained Fmask\_2.1.exe and MCR)
> or you can download the MCR file from oneline at:
> http://www.mathworks.com/products/compiler/ with 64 bit windows 2012a MCRInstaller

2.  Follow promps to install Matlab Runtime Compiler (MCRInstaller.exe)

3.  Place Fmask\_2\_1.exe and SunEarthDistance.txt into directory of choice
> e.g., C:\Fmask

4.  Place Landsat bands and .MTL files into the same directory

note: you can also set the 'Path=' to the executable and change directory 'cd' to point to the data in another location.

5.  Run Fmask.exe from DOS command line (be patient after you hit enter)
> i.e. > Fmask\_2\_1

6.  Process takes about 1 minute depending on machine

**This version only runs on Windows 64-bit and requires at least 4GB of memory.**

There is an image called XXXFmask which can be opened by ENVI. The image values are presenting the following classes:

0=>clear land pixel

1=>clear water pixel

2=>cloud shadow

3=>snow

4=>cloud

255=>no observation