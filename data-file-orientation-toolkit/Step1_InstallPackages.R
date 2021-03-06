# This program can be run before using the Data File Orientation Toolkit to install all
# needed packages and verify installation.

# PLEASE MAKE SURE YOU ARE USING THE LATEST VERSION OF R FOR THE INSTALLATION OF "tabplot."
# AS OF AUGUST 2019, THE LATEST VERSION IS R 3.6.1.

# Click the "Run" button in RStudio to run this script.

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
              'devtools',
              'glue',
              'lazyeval',
              'caTools',
              'bitops',
              'rmarkdown')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages()))) 
}

# This line will return any packages not successfully installed. 
# A return of "character(0)" indicates that all packages were installed successfully.
setdiff(packages, rownames(installed.packages()))

# One package "tabplot" needs to be installed from GitHub instead of CRAN
# While the installation of the package produces warning messages,
# This code will still successfully install the package, if not already installed
if (!('tabplot' %in% installed.packages())) {
  devtools::install_github("mtennekes/tabplot")
}

# This line will return 'TRUE' if tabplot has been installed successfully
'tabplot' %in% installed.packages()

