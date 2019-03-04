# Data File Orientation Toolkit

This Data File Orientation Toolkit enables automated assessment of the quality of administrative data files to provide guidance as to the strengths and weaknesses of the file for conducting policy research. 

It is particularly suited for data from state and local agencies that the Family Self-Sufficiency Data Center supports. Each analysis presented includes guidance on how to interpret the results and take further steps to understand the quality of your data file. The toolkit focuses on checks on data accuracy, the completenteness of records, and the comparability of the data over time and among subgroups of interest. It incorporates exploratory data analysis and data visualization to draw attention to sets of records or variables that contain outliers or for which data quality may be a concern.

This toolkit is written using the R programming language and utilizes RMarkdown for reporting.

To learn more about this effort, see our [slide deck](https://repository.upenn.edu/cgi/viewcontent.cgi?article=1029&context=admindata_conferences_presentations_2018) from the 2018 ADRF Network Research Conference and [article](https://ijpds.org/article/view/937/1031) in the International Journal of Population Data Science.

This toolkit is under development at [NORC at the University of Chicago](http://www.norc.org/Pages/default.aspx) and includes contributions from Rupa Datta, Evan Herring-Nathan, Andrew Latterner, Zachary Seeskin, and Gabriel Ugarte. We particularly thank Bob Goerge and Emily Wiegand for their valuable guidance and feedback.

The work is supported by the Family Self-Sufficiency Research Consortium, Grant Number #90PD0272, funded by the Office of Planning, Research, and Evaluation in the Administration for Children and Families, U.S Department of Health and Human Services to the University of Chicago, with NORC at the University of Chicago as a sub-grantee. The contents of the toolkit are solely the responsibility of the developers and do not necessarily represent the official views of the Office of Planning, Research, and Evaluation, the Administration for Children and Families, or the U.S. Department of Health and Human Services.


## How to utilize this toolkit
In order to use this toolkit, you must install R and RStudio on your computer. You may need to work with your IT team to have these programs installed in a place that can access the data file you wish to analyze. The following steps are needed to install this software.

1. Install R: R is a free, open source, programming language often used for data manipulation, analysis, and visualization. The key code for the toolkit is written in R. The R software is available from the CRAN website (https://cran.r-project.org/). Click the download button for your operating system (Linux, Mac, or Windows).

2. Install RStudio: RStudio is a development environment that makes using R easier. It is also free to download. You can download RStudio from the RStudio website (https://www.rstudio.com/products/rstudio/download/). Select the RStudio Desktop Open Source option.

3. Install the following list of R packages: 

- "dplyr",
- "data.table",
- "tabplot",
- "readxl",
- "bit64",
- "descr",
- "tinytex", 
- "stringr",
- "gdata",
- "knitr",
- "ggplot2",
- "ggthemes",
- "dataQualityR",
- "lvplot",
- "fda",
- "tables",
- "RDIDQ",
- "validate",
- "VIM",
- "lvplot",
- "tidyr",
- "gridExtra", 
- "yaml". 

To install these packages, open RStudio once you have installed it (and R). The panel on the bottom of your screen is the console. You can type commands to R here. To install each package type the installation instructions into the console as illustrated below for the "dplyr" package. For more information on packages, see this DataCamp tutorial (https://www.datacamp.com/community/tutorials/r-packages-guide).

4. Confirm packages installed: Step 3 installs packages and additional package dependencies. Your RStudio console should print “package ‘dplyr’ successfully unpacked” if the install worked correctly (similar messages should print for the other packages). To confirm, try loading the package with the command “library(dplyr)”. Repeat this process for “data.table” and remaining packages. If no error messages are received, the install is complete. 

### Using with Git
After installing these programs, use Git to clone this repository. You can click above on "Clone or Download" to save the files to a convenient location on your computer.

Next, using RStudio, open the master "DQToolkit.Rmd" file in the data-quality-toolkit folder. You may also open the setup file setup.yml file in the same folder.

## Setting up the report
The YAML file setup.yml is a convenient setup for describing the variable types in your dataset for the toolkit analyze. The file can be used to designate different variable types to be analyzed including which variables are for identification, time periods, key for analysis, key domains or groups to compare, and location-related variables.  Follow the instructions in the existing setup YAML file to learn how to modify it to fit your needs.  

In the main DQToolkit.Rmd file, you can specify the location of your case and member files, create new variables for analysis, add new labels for your variables, or even subset your data.  
## Running the report
In the DQToolkit RMarkdown file, click on the "Knit" button at the top of the RStudio screen. This will run the entire script and an HTML document will appear when it is finished.

## Modifying the output
If you'd like to modify the report functionality, you can do it in two ways -- adding/removing components or modifying existing elements.
### Adding/removing components
At the bottom of the DQToolkit.Rmd file, you will find a series of lines that refer to the creating of various report subcomponents. You can remove components from your final report by removing these lines.
For instance, if you want to remove outlier analysis, simple comment out or remove the following lines:
```{r outliers, child='outliers/outliers.rmd', echo=True}
```
If you'd like to add elements back into the report, simply add these lines back into the report.

### Modifying existing elements
If you'd like to modify the output of various report subcomponents, you can change the existing code. To do this, open the subfolder associated with that functionality. For instance, the outlier analysis is located in the "outliers" folder.
Most of the readily available input modifications are located at the top of each subcomponent's code. 

# Description of Elements

## DQToolkit (DQToolkit.Rmd)
Master script for the toolkit, including data input  
Variables to Modify:
- input_yaml: Location of the yaml to detail variables for analysis. For documentation on how to modify YAML, refer to the existing YAML file (setup.yml).
- subset_param: Select subsetting parameters, including time period, for report output


## Technical Checks (Technical_Checks.Rmd)
Check whether the data conform to rules based on the codebook or other sources  
Variables to Modify:  
- selected_var: Select variables for section's analyses
- zip_str: Regular expression used to check zip code consistency that can be modified or marked out
- zip_detect: For verifying zip code; Can be marked out if zip code not in dataset
- v: Validator object where user can specify variable rules
- var2: Set grouping variable for record-level rule check plot (plot2)
- varlabel2: Label for grouping variable for record-level rule check plot (plot2)
- var3: Set grouping variable for record-level rule check plot (plot3)
- varlabel3: Label for grouping variable for record-level rule check plot (plot3)
## Outliers (Outliers.Rmd)
Assess distributions of single variables and detect potential outliers  
Variables to Modify:
- selected_var: Select variables for section's analyses

## Completeness

### Unit Completeness (Completeness_unit.Rmd)
Assess completeness of data with respect to units in the dataset  
Variables to Modify:
- subset_param: Select subsetting parameters for section's analyses
- time_var: Designate the time variable
- location_var: Designate the location/geographic variable for analysis

### Values Completeness (Completeness_values.Rmd)
Assess completeness of data with respect to variables within units (Item nonresponse)

## Comparability

### Distribution (Comparability_Distribution.Rmd)
Assess comparability based on variable distributions and comparisons among domains

### Patterns Over Time (Patterns_over_time.Rmd)
Assess comparability of data over time  
Variables to Modify:
- selected_var: Select variables for section's analyses
- subgroup: Select subgroup variable for examining tableplots by subgroup

### Relationships Among Variables (Relationships_among_variables.Rmd)
Assess comparability with respect to relationships among variables and by groups
Variables to Modify:  
- sort_var: Select sort variable to examine relationship among variables via tableplots
- subgroup: Select subgroup variable for examining tableplots by subgroup
