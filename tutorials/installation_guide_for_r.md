# Installation Guide for R 

This document contains instructions for installing the software (R and RStudio) needed to run the code that formats your state’s data into spells. These programs should be installed in the location where the analysis will run prior to the demonstration. You may need to work with your IT team to have these programs installed in a place that can access the data you wish to transform into spells.  

 This document walks through installation of the software needed to execute the spells code.  

1. Install R: R is a free, open source, programming language often used for data manipulation, analysis, and visualization. The code that creates spells, “calculate_spells.R”, is written in R. The R software is available from the CRAN website (https://cran.r-project.org/). Click the download button for your operating system (Linux, Mac, or Windows). 

2. Install RStudio: RStudio is a development environment that makes using R easier. It is also free to download. You can download RStudio from the RStudio website (https://www.rstudio.com/products/rstudio/download/). Select the RStudio Desktop Open Source option. 

3. Install the R packages “dplyr”, "data.table", and "doParallel": Open RStudio once you have installed it (and R). The panel on the bottom of your screen is the console. You can type commands to R here. To install each package type the installation instructions into the console as illustrated below for the "dplyr" package. For more information on packages, see this DataCamp tutorial (https://www.datacamp.com/community/tutorials/r-packages-guide).  

![R console](r_console.jpg)

4. Confirm packages installed: Step 3 installs packages and additional package dependencies. Your RStudio console should print “package ‘dplyr’ successfully unpacked” if the install worked correctly (similar messages should print for the other packages). To confirm, try loading the package with the command “library(dplyr)”. Repeat this process for “data.table” and “doParallel”. If no error messages are received, the install is complete.  