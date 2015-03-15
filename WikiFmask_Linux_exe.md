#Linux executable Fmask software.

# Introduction #

Take Fmask 2.2 version Linux executable as an example.


# Details #

Instruction for Installation and Use for the stand alone Linux executable Fmask 2.2 version (also the 3.0 beta version)
Copyright: Zhe Zhu, Boston University    Date: 04/09/2013

1.  Download MCRInstaller.exe for R2012b Linux version at http://www.mathworks.com/products/compiler/mcr/;

2.  Unzip the MCRInstaller file and type ./install in Linux terminals to install
> Matlab Runtime Compiler (MCRInstaller.exe);

3.  At the end, it tells you to save two environment variables called
> "LD\_LIBRARY\_PATH" and "XAPPLRESDIR". Write that done.

> For example, if I save my MCR at /MCR
> I'll got the following two environmental variables
  1. LD\_LIBRARY\_PATH /MCR/v80/runtime/glnxa64:/MCR/v80/bin/glnxa64:/MCR/v80/sys/os/glnxa64:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64/native\_threads:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64/server:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64
> 2) XAPPLRESDIR /MCR/v80/X11/app-defaults

4.  Edit your .cshrc (or equivalent) file and add this (if I save my MCR at /MCR):
> setenv LD\_LIBRARY\_PATH /MCR/v80/runtime/glnxa64:/MCR/v80/bin/glnxa64:/MCR/v80/sys/os/glnxa64:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64/native\_threads:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64/server:/MCR/v80/sys/java/jre/glnxa64/jre/lib/amd64
> setenv XAPPLRESDIR /MCR/v80/X11/app-defaults
> (.tcsh is the same, for .bash replace it with export LD\_LIBRARY\_PATH="...")

5.  Save the shell or bash script and source it;

6.  Copy the Fmask\_Linux software to any location you want (for example /Tools/Fmask);

7.  cd into the folder where Landsat bands and .MTL files downloaded and run Fmask by
> Entering /Tools/Fmask\_Linux in the terminals.

> There are three important tuning variables that you can play with:
  1. 'cldpix' is dilated number of pixels for cloud with default values of 3.
> 2) 'sdpix' is dilated number of pixels for cloud shadow with default values of 3.
> 3) 'cldprob' is the cloud probability threshold with default values of 22.5 (range from 0~100).
> If you want to use default values /Tools/Fmask\_Linux is enough, if you want to customize your
> own parameters, you can use /Tools/Fmask\_Linux cldpix sdpix cldprob in the terminals

8.  Process takes about 0.5 to 5 minute depending on machine

