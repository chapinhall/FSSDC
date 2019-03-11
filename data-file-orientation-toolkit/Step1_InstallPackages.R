# This program can be run before using the Data File Orientation Toolkit to install all
# needed packages and verify installation.

# Just click the "Run" button in RStudio.

packages <- c('dplyr',
              'data.table',
              'tabplot',
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
              'plyr',
              'devtools')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages()))) 
}
install_github("smtennekes/tabplot")
# This line will return any packages not successfully installed. 
# A return of "character(0)" indicates that all packages were installed successfully.
setdiff(packages, rownames(installed.packages()))



