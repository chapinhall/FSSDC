# Data File Orientation Toolkit

This Data File Orientation Toolkit is an open source toolkit for researchers and analysts interested in assessing the quality of administrative data files and understanding the strengths and weaknesses of the file for conducting policy research. After going through a few set up steps, this toolkit will produce a report producing data quality insights regarding your data file. The content is guided by best practices for data quality assessment.

The toolkit is particularly suited for data from state and local agencies that the [Family Self-Sufficiency Data Center](https://harris.uchicago.edu/research-impact/centers/family-self-sufficiency-data-center) supports, although it can run on any file that meets the format requirements. Each analysis presented includes guidance on how to interpret the results and take further steps to understand the quality of your data file before conducting analysis. 

The toolkit checks the data accuracy, the completeness of records, and the comparability of the data over time and among subgroups of interest. It incorporates exploratory data analysis and data visualization to draw attention to sets of records or variables that contain anomalies or for which data quality may be a concern. 

This toolkit is written using the R programming language and utilizes RMarkdown for reporting. It is oriented for a user new to R to follow our instructions and produce a report for their data file in a few steps. For a user who wants to customize analyses in the toolkit, it is helpful to be familiar with R.

To learn more about this effort, see our [slide deck](https://repository.upenn.edu/cgi/viewcontent.cgi?article=1029&context=admindata_conferences_presentations_2018) from the 2018 ADRF Network Research Conference and [article](https://ijpds.org/article/view/937/1031) in the International Journal of Population Data Science.

## About This Project

This toolkit was developed at [NORC at the University of Chicago](http://www.norc.org/Pages/default.aspx) and includes contributions from Rupa Datta, Evan Herring-Nathan, Andrew Latterner, Zachary Seeskin, and Gabriel Ugarte. We particularly thank Bob Goerge and Emily Wiegand for their valuable guidance and feedback.

The work is supported by the Family Self-Sufficiency Research Consortium, Grant Number #90PD0272, funded by the Office of Planning, Research, and Evaluation in the Administration for Children and Families, U.S Department of Health and Human Services to the University of Chicago, with NORC at the University of Chicago as a sub-grantee. The contents of the toolkit are solely the responsibility of the developers and do not necessarily represent the official views of the Office of Planning, Research, and Evaluation, the Administration for Children and Families, or the U.S. Department of Health and Human Services.

## How to utilize this toolkit
In order to use this toolkit, you must first install R and RStudio on your computer. You may need to work with your IT team to have these programs installed in a place that can access the data file you wish to analyze. The following steps are needed to install this software.

### Install R (latest version, 3.6.1 as of August 2019) and RStudio

1. Install R (Latest version, currently 3.6.1): R is a free, open source, programming language often used for data manipulation, analysis, and visualization. The code for the toolkit is written in R. R software is available from the Comprehensive R Archive Network (CRAN) website (https://cran.r-project.org/). Click the download button for your operating system (Linux, Mac, or Windows). 

    If you already have R installed on your computer, please work with your IT team to update R to the latest version. A description of how to do this is on Windows is described at (https://www.r-bloggers.com/upgrade-r-on-windows-with-the-installr-package/).

2. Install RStudio: RStudio is a development environment that makes using R easier. It is also free to download. You can download RStudio from the RStudio website (https://www.rstudio.com/products/rstudio/download/). Select the RStudio Desktop Open Source option.

### Set Up R Scripts and Packages

3. After installing these programs, clone this repository to use the R scripts on your computer. Within the GitHub site, you can click on 'Clone or Download' to save the files to a convenient location on your computer.

4. You will need to install the R packages required for the toolkit. To do so, use RStudio to open the script “Step1_InstallPackages.R” included in the 'data-file-orientation-toolkit' folder. Run this script by clicking the 'Run' button. The script includes checks to verify that the packages below from CRAN are installed successfully: 
- 'plyr',
- 'dplyr',
- 'data.table',
- 'readxl',
- 'bit64',
- 'descr',
- 'tinytex', 
- 'stringr',
- 'gdata',
- 'knitr',
- 'ggplot2',
- 'ggthemes',
- 'dataQualityR',
- 'lvplot',
- 'fda',
- 'tables',
- 'RDIDQ',
- 'validate',
- 'VIM',
- 'lvplot',
- 'tidyr',
- 'gridExtra', 
- 'yaml',
- 'devtools',
- 'glue',
- 'lazyeval',
- 'caTools',
- 'bitops',
- 'rmarkdown'.

    In addition, one package 'tabplot' needs to be installed from GitHub.

    **Please make sure you are using the latest version of R (3.6.1 as of August 2019) to install 'tabplot'.** Note that the installation of 'tabplot' may produce warning messages, but as long as you use the latest version of R, the installation should proceed successfully. 

    For more information on R packages, see the following DataCamp tutorial (https://www.datacamp.com/community/tutorials/r-packages-guide).

### Modify '.Rmd' R Markdown files and 'setup.yml' files to generate report

5. Next, using RStudio, navigate to the 'data-file-orientation-toolkit' folder and open the master 'Toolkit.Rmd' R Markdown script. You may also open the setup file 'setup.yml' in the same folder. Follow the instructions below to customize the input and R code for these files and other .Rmd R Markdown scripts in the subfolders to correspond with your data file. After following these instructions, clicking the 'knit' button in RStudio to run 'Toolkit.Rmd' will produce a report with data quality analysis for your data file.

## Example Data File and Report for Testing
In this repository, we include an example data file 'test_data_file.csv' we simulated for users to test and explore the toolkit. The file is a longitudinal dataset representing benefit recipients tracking cases/households over time for each month they are recorded in the file. A codebook for this test dataset is provided in the text file 'Codebook for test_data_file.txt.'

The master R script 'Toolkit.Rmd' and set up file 'setup.yml' incorporate defaults to analyze this data file. However, you may modify the report output and functionality through changes to these scripts (see the 'Modifying the output' section below). 

An example output report from the toolkit based on this data file is also provided in 'Toolkit_Output_Example.html'.

**IMPORTANT NOTE:** We recommend reading through Sections 1 to 5 of the example report Toolkit_Output_Example.html' and/or the text of 'Toolkit.Rmd' to orient yourself to the toolkit before running it to produce your report. Reading through this text will orient you to the content of the report and how to set it up. In addition, the report introduces the components of data quality assessment, including data relevance, which we recommend as an early step for investigating a data file. 

## Format of Data Files Needed for Toolkit
'test_data_file.csv' provides an example of the data file format needed for the toolkit. The toolkit is best suited to analyze data that come in a longitudinal 'long' format, containing a column for an ID variable identifying unique entities (for example, households) and a time variable to track the entities over time. This 'rectangular' data file would have rows for the units/time periods and columns for the variables. A user should avoid duplicate records for units/time periods. (A check for duplicates is planned for a later version of the toolkit.)

As for 'test_data_file.csv', a header row in the data file should provide the variable names/labels.

The input YAML file 'setup.yml' (described below) can be used to identify the ID variable and time variable in the dataset by designating the classifications as 'id' or 'time'. 

**NOTE:** For proper sorting of time periods in the toolkit, we recommend a time variable similar to either YYYY format for year (ex: 2015) or YYYYMM format for year-month (ex: 201503 for March 2015).

While the toolkit requires a variable to be identified as a 'time' variable, the toolkit can also run on a cross-sectional data file (that does not involve different time periods) by adding a filler variable with the same value for all records. For example, a user may create a variable titled 'time' with the value '1' for all rows.

**NOTE:** Please make sure that column labels for variable names match formats needed for R syntax. For example, variable names should not have spaces or other special characters.

**NOTE:** While the toolkit will run successfully on any categorical variable input, some graphs and tables may not present well categorical variables with more than 15 categories. We recommend that users consider collapsing categorical variables to the groupings of most interest before running the toolkit. 

## Setting up the report
The YAML file 'setup.yml' provides a convenient setup for describing the variable types in your dataset for the toolkit analyze. The file can be used to designate different variable types to be analyzed, including which variables are for identification, time periods, key for analysis (such as outcomes), domains or groups to compare, and location-related variables. These variables provide inputs for analyses in the toolkit. Follow the instructions in the existing setup YAML file to learn how to modify it to fit your needs. Each variable should have a classification as 'id', 'time', 'key', 'domain', or 'location' and a type as 'categorical' or 'numeric'.

There should be at least one variable classified as each of 'id', 'time', 'key', and 'domain.' 

In the main 'Toolkit.Rmd' master script, you may specify the name of your data file, add new labels for your variables, and subset your data file as desired for analyses. More description of these steps is below under 'Modifying existing components.'
 
## Running the report
In the 'Toolkit.Rmd' RMarkdown file, click on the 'Knit' button at the top of the RStudio screen. You may be prompted to update R packages at the outset, and we advise allowing the R packages to update before rerunning the toolkit.

Clicking the 'knit' button will run the entire script and, if there are no errors, produce an HTML document 'Toolkit.html' when it is finished.

The 'Toolkit.Rmd' master script sets up the data file for analysis and calls other scripts saved in the subfolders to conduct analysis for specific components of data quality. Setting up and running 'Toolkit.Rmd' allows for running the entire set of data quality analyses.

## Modifying the output
If you'd like to modify the report functionality, you can do so in two ways -- adding/removing components for analysis or modifying the existing components in the R scripts for analysis.

### Adding/removing components
At the bottom of the 'Toolkit.Rmd' file, you will find a series of lines that related to creating the report's various subcomponents. You can remove components from your final report by removing these lines.
For instance, if you want to remove outlier analysis, simply comment out or remove the following lines:
'''{r outliers, child='outliers/outliers.rmd', echo=True}
'''
If you'd like to add components back into the report, simply add these lines back into the report.

### Modifying existing components
If you'd like to modify the output of various report subcomponents, you can change the existing code. To do this, open the subfolder associated with that functionality. For instance, the outlier analysis is located in the 'outliers' folder.
Most of the readily available input modifications are located at the top of each subcomponent's code. 

# Description of components

To run the toolkit on your data file, this section describes places where we expect changes will be needed to adapt the toolkit to your data file.

## Toolkit (Toolkit.Rmd)
Master script for the toolkit, including data input  
Components to Modify:
- analysis_file: Enter directory and name of your data file to read. There is no need for a directory if the data file is saved in the same location as 'Toolkit.Rmd'.
- input_yaml: Location of the yaml to detail variables for analysis. For documentation on how to modify the YAML, refer to the existing YAML file (setup.yml).
- Add labels for categorical variables: See the example for adding labels to categorical variables under 'EDIT THIS SECTION TO DEFINE LABELS OF CHARACTER VARIABLES'
- subset_param: Select subsetting parameters, including time period, for report output. For example, to subset test_data_file.csv to months prior to July 2015, the user would enter " subset_param <- 'month < 201507' ". This can be set to "" if the user does not need subsetting.

## Accuracy and Completeness

### Data Checks (Data_Checks.Rmd)

**NOTE:** This section is designed to be specific to the example data file. A user should either modify this to match expected rules corresponding to their input data file or mark out the running of the Data_Checks.Rmd script in the master Toolkit.Rmd script, as described above under "Adding/removing components."

Check whether the data conform to rules based on the codebook or other sources. In this section, the user should add variable rules based on the codebook and verify the extent to which any of these rules are violated. The main section for adding codebook rules is for the validation object 'v'. See examples provided in the script based on the example file.
Variables to Modify:  
- selected_var: Select variables for section's analyses
- zip_str: Regular expression used to check zip code consistency that can be modified or marked out
- zip_detect: For verifying zip code; Can be marked out if zip code not in dataset
- v: Validator object where user can specify variable rules

### Outliers (Outliers.Rmd)
Assess distributions of single variables and detect potential outliers  
Variables to Modify:
- selected_var: Select variables for section's analyses

### Examine Variable Distributions (examine_var_distributions.Rmd)
Graphical analysis of variable distributions to detect any patterns suggesting inaccuracy.

### Unit Completeness (Completeness_unit.Rmd)
Assess completeness of data with respect to units in the dataset  
Variables to Modify:
- time_var: Designate the time variable
- location_var: Designate the location/geographic variable for analysis

### Value Completeness (Completeness_values.Rmd)
Assess completeness of data with respect to variables within units (Item nonresponse)

## Comparability

### Relationships Among Variables (Comparability_Relationship_among_variables.Rmd)
Assess comparability with respect to relationships among variables and by groups
Variables to Modify:  
- sort_var: Select sort variable to examine relationship among variables via tableplots
- subgroup: Select subgroup variable for examining tableplots by subgroup

### Patterns Over Time (Comparability_Patterns_over_time.Rmd)
Assess comparability of data over time  
Variables to Modify:
- selected_var: Select variables for section's analyses
- subgroup: Select subgroup variable for examining tableplots by subgroup



