# Creating Spells
Historical administrative data for family self-sufficiency programs is usually tracked as a series of transactions or point-in-time information.
However, analyses of duration, churn, and recidivism require that data be constructed in some interim step as spells. Spells files have an index variable
(i.e. case ID) and fields for service start date and service end date. Each unbroken spell of service receipt is reflected as a single row. For research
purposes interruptions in benefit receipt of 1-4 months may be regarded as administrative churn (for example, delays related to paperwork processing) and
disregarded. These decisions around gaps inform how spells are defined and constructed, but do not change the essential data structure.

## General Spell Creation
We have provided one example script of a file that dynamically takes inputs from the user and runs the code based on these inputs. Accepting these inputs (such as name of the unique identifier column) allows for more flexible application of the code to a variety of files.

### Spell Creation in Python
We have created a Python script to create general spells files that can work with data that has point-in-time information where each observation is associated with a time period and a unique identifier. The script allows you to select the input file with the point-in-time data, the name of the column indicating if the case is active for this time period, the name of the column with the unique identifier, the name of the column with the time period, how much time to allow for administrative churn (in days), and the name of the spells file you wish to create.

Running the file requires knowledge of how to use a terminal and execute Python code with parameters. Please see the tutorial section of this site if you are not familiar with these concepts.

An example of specifying your inputs in the terminal might look like this: `python spells.py CaseMonths.csv active_ind caseid month 31 spells.csv`

1. The input from the user is accepted in lines 66-87. The line `if __name__=='__main__':` is only invoked if the Python script is called directly from the terminal. This block of the code accepts the inputs the user has selected and hands them off to the main function *create_spells* and afterwards writes the spells to an output file in the helper function *write_file*.

2. In the *create_spells* function, lines 30-35 reads in the input file into a Python data object, filters the file so only active periods are kept, and sorts the remaining values by the unique identifier and the time. Having cases in order allows us to determine if there are gaps which demarcate the spells.

3. Lines 39-40 determine if the case is continuous based on time. The code `.shift(periods=-1)` takes the column and creates a new column where all the values are shifted one below. This allows for quick comparison between rows to see if the time difference is within our administrative churn threshold.

4. Line 41 repeats the same process but for the unique identifier ensuring that the case being compared are the same. Line 42 combines the time and the unique identifier requirements and creates one flag that determines if the row has another observation within the spell after it. Values that are false are rows that are the end of a spell.

5. Lines 47 starts a loop over the Python data structure we have created which we use to build our spells. The code `for i in range(len(df)):` loops over each index of the Python data structure which we can then use to access specific observations of the data structure like this `df.iloc[i][args.time]`. The reason we are choosing to iterate over the index instead of the data directly is it makes referencing the previous value as well as the current value straightforward as we iterate. The code `strftime('%Y-%m-%d')` saves the value as a formatted string value instead of a timestamp.

6. If a row has a *continuous* flag of False that means it is the last observation in a spell and should be its own row in our output file. Therefore the Line 48 `if not(df.iloc[i-1]['continous']):` checks to see if the previous row (that's why the index is i -1) was the end of a spell, and if so it sets a new start date for a new spell.

7. Similarly, the Line 50  `if not(df.iloc[i]['continous']):` also uses Python conditional logic to see if the current observation is the end of spell and if so it sets the end date to that row's time observation and appends that spell to our running count of spells stored in the `records` variable.

8. Lines 55-64 take the spells which we have been keeping track of in the variable `records` and outputs them to a csv file with the name chosen by the user when initially calling the Python script via the terminal.

#### Testing The Python Script
A file to test the Python code against a few simple use cases is available in *test_spells.py*. This file uses the [pytest](https://docs.pytest.org/en/latest/) library. Test data is provided in  [test_data](https://github.com/chapinhall/FSSDC/tree/master/create_spells/test_data). If you make changes to the Python file to add a new feature you may wish to run some tests to ensure they work correctly. Update the new expected output based on your additions inside the *test_spells.py* file and rerun the tests. You can run the test file by typing `py.test test_spells.py` in your terminal.

## Specific Use Cases of Spell Creation
This repository also includes two sample scripts created by FSSDC staff to create spell data formats in working with our partner states.  The first, `build_case_spells.sql`,
was created working with Colorado TANF data. Most of this script is written in pure SQL; however, it was originally intended for use in a PostgreSQL database,
and it includes a few functions that are specific to that database. The second script (`create_foodstamp_spells.sas`), originally used in conjunction with Illinois
SNAP data, is written in SAS.

The two scripts take different approaches to creating spells, reflecting the strengths and constraints of the tools used to develop these scripts.

These scripts were originally created as part of routine data processing. Each has some idiosyncrasies related to the input data, particularly around the formatting of dates.
These code samples are not generalized for use in other contexts, nor have they been compared to assess the pros, cons, and overall efficiencies of each approach. These
are all avenues that we are interested in exploring further through the FSSDC, and we welcome your contributions of scripts and findings as you explore this space.


### Spell Creation in SQL
In SQL, spell creation is done through a series of joins and a function iterating over the data.  Note that because there are so many joins involved in this
approach, indexing the datasets prior to joining can significantly impact performance.

1. The input file is a point-in-time dataset with a time sequence field (here, month/year, though that creates a need to correct for December to January transitions,
so a basic sequence field would be easier), a case identifier, and a flag for active status.  This dataset is filtered to only active records.  A new flag field
indicating whether the case was active in the previous month is created and set to 0 for all records (this will be populated in step 2).

2. The input file is joined to itself where month = month-1 and case id = case id.  Where a matching record is found, the flag for activity in the previous month is reset
to 1.

3. The dataset created in step 2 is filtered to include only records where there was no activity in a previous month.  These records are beginnings of spells, and the data
is reshaped to begin to look like spells files, with columns for case id, start month, and end month.  Start month and end month are both set to the same value.

4. A function iterates through the total number of months in the dataset and checks to see if the initial spells table can be joined to a record in the raw data where
month = end month + 1.  If a join can be made, end month is updated appropriately and the spell is expanded.

The remainder of this script demonstrates how several of the fields used to analyze duration and churn in the data model are created, including total months,
total months in spell, first month, and last month.

### Spell Creation in SAS

In SAS, where data is always processed sequentially, the script relies on repeatedly sorting the data and retaining key fields.

1. The raw data is point-in-time, sorted by case ID and chronologically by the sequence field update ID (note that the fixupdt macro is called to work on a dataset-specific
issue in update IDs). Every case/time combination from when the case first originates is represented, with an indicator that is 1 for active benefit receipt and 0 for months
of non-receipt.

2. Two fields are created with a retain statement: one indicating spell start and one indicating whether benefits were received in the prior month.  For each new case ID, these
are reset to match the current line of data. Otherwise, if the previous row had the same benefit status, the start date is unchanged. If benefit status changes between months,
the start date changes and a new spell starts.

3. After the retain processing, only the last observation with any given start date is kept, so that there is only one line per spell.

4. This initial spell data is sorted in reverse chronological order, with the new (chronologically) start date for each row retained for reference. This facilitates the creation
of a spell end date.

5. Spells of benefit non-receipt are filtered out.

Subsequent code repeats similar operations at the individual or case/individual levels, and with logic ignoring one month gaps.


### Spell Creation in R

Although we do not have a current sample spell creation script in R, it looks like [the R package DataCombine](https://cran.r-project.org/web/packages/DataCombine/DataCombine.pdf) has some
functions to work with calculating spell-related outcomes.
