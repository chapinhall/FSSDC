# This program can be run before using the Data File Orientation Toolkit to install all
# needed packages and verify installation.

# Just click the "Run" button in RStudio.

packages <- c('plyr',
              'dplyr',
              'data.table',
              'readxl',
              'bit64',
              'descr',
              'tinytex',
              'stringr',
              'gdata',
              'knitr',
              'ggplot2',
              'ggthemes',
              'dataQualityR',
              'lvplot',
              'fda',
              'tables',
              'RDIDQ',
              'validate',
              'VIM',
              'lvplot',
              'tidyr',
              'gridExtra',
              'yaml',
              'devtools')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages()))) 
}

# This line will return any packages not successfully installed. 
# A return of "character(0)" indicates that all packages were installed successfully.
setdiff(packages, rownames(installed.packages()))

# One package "tabplot" needs to be installed from GitHub instead of CRAN
devtools::install_github("mtennekes/tabplot")





