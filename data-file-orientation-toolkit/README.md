# Data File Orientation Toolkit

This Data File Orientation Toolkit enables automated assessment of the quality of administrative data files to provide guidance as to the strengths and weaknesses of the file for conducting policy research. After going through a few set up set up steps, this toolkit will provide valuable insight into your data file.

It is particularly suited for data from state and local agencies that the Family Self-Sufficiency Data Center supports, although it can run on any file that meets the format requirements. Each analysis presented includes guidance on how to interpret the results and take further steps to understand the quality of your data file. The toolkit focuses on checks on data accuracy, the completenteness of records, and the comparability of the data over time and among subgroups of interest. It incorporates exploratory data analysis and data visualization to draw attention to sets of records or variables that contain outliers or for which data quality may be a concern. 

This toolkit is written using the R programming language and utilizes RMarkdown for reporting.

To learn more about this effort, see our [slide deck](https://repository.upenn.edu/cgi/viewcontent.cgi?article=1029&context=admindata_conferences_presentations_2018) from the 2018 ADRF Network Research Conference and [article](https://ijpds.org/article/view/937/1031) in the International Journal of Population Data Science.

## How to utilize this toolkit
In order to use this toolkit, you must install R and RStudio on your computer. You may need to work with your IT team to have these programs installed in a place that can access the data file you wish to analyze. The following steps are needed to install this software.

1. Install R: R is a free, open source, programming language often used for data manipulation, analysis, and visualization. The key code for the toolkit is written in R. The R software is available from the CRAN website (https://cran.r-project.org/). Click the download button for your operating system (Linux, Mac, or Windows).

2. Install RStudio: RStudio is a development environment that makes using R easier. It is also free to download. You can download RStudio from the RStudio website (https://www.rstudio.com/products/rstudio/download/). Select the RStudio Desktop Open Source option.

3. Use the R script Step1_InstallPackages.R to install a set of additional R packages from the Comprehensive R Achive Network (CRAN) with functionalities needed for the toolkit: 
- "plyr",
- "dplyr",
- "data.table",
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
- "yaml",
- "devtools". 

In addition, one package "tabplot" needs to be installed from GitHub.

To install these packages, open RStudio once you have installed it (and R). Within R Studio, open the script Step1_InstallPackages.R. Run this script by clicking the run button. The script includes check to verify that the packages were installed successfully.  

For more information on R packages, see this DataCamp tutorial (https://www.datacamp.com/community/tutorials/r-packages-guide).

4. After installing these programs, clone this repository to use it on your computer. Within our GitHub site, you can click above on "Clone or Download" to save the files to a convenient location on your computer.

Next, using RStudio, navigate to the data-quality-toolkit folder and open the master "Toolkit.Rmd". You may also open the setup file setup.yml file in the same folder.

## Example Data File and Report for Testing
We include in this repository an example data file we simulated which can be used to test and explore the toolkit: test_data_file.csv. The file represents a longitudinal dataset of benefit recipients, tracking cases/households over time for each month they are recorded in the file. A codebook for this test dataset is provided in the text file "Codebook for test_data_file.txt."

The master R script Toolkit.Rmd and set up file setup.yml are prepared with convenient defaults to analyze this data file. An example output report from the toolkit based on this data file is also provided in Toolkit_Output_Example.html.

## Format of Data Files Needed for Toolkit
test_data_file.csv provides an example of the data file format needed for the toolkit. The toolkit is best suited to analyze data that come in a longitudinal "long" format with an ID variable identifying unique entities (for example, households) and a time variable to track the entities over time. There should be one "rectangular" data file with rows for the units/time periods and columns for the variables. A user should avoid duplicate records for units/time period.

As in test_data_file.csv, a header row in the data file should provide the variable names/labels.

The input YAML file setup.yml (described below) can be used to identify the ID variable and time variable in the dataset by designating the classifications as "id" or "time". 

While the toolkit requires a variable to be identified as a "time" variable, the toolkit can also run on a cross-sectional data file (that does not involve different time periods) but adding a filler variable with the same value for all records. For example, a user may create a variable titled "time" with the value '1' for all rows.


## Setting up the report
The YAML file setup.yml is a convenient setup for describing the variable types in your dataset for the toolkit analyze. The file can be used to designate different variable types to be analyzed including which variables are for identification, time periods, key for analysis, key domains or groups to compare, and location-related variables. These variables provide inputs for analyses in the toolkit to assess the accuracy and completeness of key variables as well as the comparability over time and among groups. Follow the instructions in the existing setup YAML file to learn how to modify it to fit your needs. Each variable should have a classification as "id", "time", "key", "domain", or "location" and a type as "categorical" or "numeric".

There should be at least one variable classified as each of "id", "time", "key", and "domain." 

In the main Toolkit.Rmd master script, you can specify the name and location of your data file, create new variables for analysis, add new labels for your variables, and there is also an option to subset your data. 
 
## Running the report
In the Toolkit.Rmd RMarkdown file, click on the "Knit" button at the top of the RStudio screen. This will run the entire script and, if there are no errors, produce an HTML document Toolkit.html when it is finished.

The Toolkit.Rmd master script sets up the data file for analysis and calls other scripts saved in the subfolders to conduct analysis for specific elements of data quality. Setting up and running Toolkit.Rmd allows for running the entire set of data quality analyses.

## Modifying the output
If you'd like to modify the report functionality, you can do it in two ways -- adding/removing components for analysis or modifying the existing elements in the R scripts for analysis.
### Adding/removing components
At the bottom of the Toolkit.Rmd file, you will find a series of lines that refer to the creating of various report subcomponents. You can remove components from your final report by removing these lines.
For instance, if you want to remove outlier analysis, simple comment out or remove the following lines:
```{r outliers, child='outliers/outliers.rmd', echo=True}
```
If you'd like to add elements back into the report, simply add these lines back into the report.

### Modifying existing elements
If you'd like to modify the output of various report subcomponents, you can change the existing code. To do this, open the subfolder associated with that functionality. For instance, the outlier analysis is located in the "outliers" folder.
Most of the readily available input modifications are located at the top of each subcomponent's code. 

# Description of Elements

To run the toolkit on your data file, this section describes places where we expect changes will be needed to adapt the toolkit to your data file.

## Toolkit (Toolkit.Rmd)
Master script for the toolkit, including data input  
Elements to Modify:
- analysis_file: Enter directory and name of your data file to read in. There is no need for a directory if the data file is saved in the same location as Toolkit.Rmd.
- input_yaml: Location of the yaml to detail variables for analysis. For documentation on how to modify the YAML, refer to the existing YAML file (setup.yml).
- Add labels for categorical variables: See the example for adding labels to categorical variables under "EDIT THIS SECTION TO DEFINE LABELS OF CHARACTER VARIABLES"
- subset_param: Select subsetting parameters, including time period, for report output. Can set to "" if the user does not need subsetting.


## Data Checks (Data_Checks.Rmd)
Check whether the data conform to rules based on the codebook or other sources. In this section, the user should add variable rules based on the codebook and verify the extent to which any of these rules are violated. The main section for adding codebook rules is for the validation object 'v'. See examples provided in the script based on the example file.
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
- time_var: Designate the time variable
- location_var: Designate the location/geographic variable for analysis

### Values Completeness (Completeness_values.Rmd)
Assess completeness of data with respect to variables within units (Item nonresponse)

## Comparability

### Distribution (Comparability_Distribution.Rmd)
Assess comparability based on variable distributions and comparisons among domains

### Patterns Over Time (Comparability_Patterns_over_time.Rmd)
Assess comparability of data over time  
Variables to Modify:
- selected_var: Select variables for section's analyses
- subgroup: Select subgroup variable for examining tableplots by subgroup

### Relationships Among Variables (Comparability_Relationship_among_variables.Rmd)
Assess comparability with respect to relationships among variables and by groups
Variables to Modify:  
- sort_var: Select sort variable to examine relationship among variables via tableplots
- subgroup: Select subgroup variable for examining tableplots by subgroup

## Contributors and Acknowledgments

This toolkit is under development at [NORC at the University of Chicago](http://www.norc.org/Pages/default.aspx) and includes contributions from Rupa Datta, Evan Herring-Nathan, Andrew Latterner, Zachary Seeskin, and Gabriel Ugarte. We particularly thank Bob Goerge and Emily Wiegand for their valuable guidance and feedback.

The work is supported by the Family Self-Sufficiency Research Consortium, Grant Number #90PD0272, funded by the Office of Planning, Research, and Evaluation in the Administration for Children and Families, U.S Department of Health and Human Services to the University of Chicago, with NORC at the University of Chicago as a sub-grantee. The contents of the toolkit are solely the responsibility of the developers and do not necessarily represent the official views of the Office of Planning, Research, and Evaluation, the Administration for Children and Families, or the U.S. Department of Health and Human Services.

