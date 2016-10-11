# Creating Spells

Historical administrative data for family self-sufficiency programs is usually tracked as a series of transactions or point-in-time information.
However, analyses of duration, churn, and recidivism require that data be constructed in some interim step as spells. Spells files have an index variable
(i.e. case ID) and fields for service start date and service end date. Each unbroken spell of service receipt is reflected as a single row. For research
purposes interruptions in benefit receipt of 1-4 months may be regarded as administrative churn (for example, delays related to paperwork processing) and 
disregard. These decisions around gaps inform how spells are defined and constructed, but do not change the essential data structure.

This repository includes two sample scripts created by FSSDC staff to create spell data formats in working with our partner states.  The first, `build_case_spells.sql` 
was created working with Colorado TANF data. Most of this script is written in pure SQL; however, it was originally intended for use in a PostgreSQL database, 
and it includes a few functions that are specific to that database. The second script (`create_foodstamp_spells.sas`), originally used in conjunction with Illinois 
SNAP data is written in SAS.

The two scripts take different approaches to creating spells, reflecting the strengths and constraints of the tools used to develop these scripts.

These scripts were originally created as part of routine data processing. Each has some idiosyncracies related to the input data, particularly around the formatting of dates.
These code samples are not generalized for use in other contexts, nor have they been compared to assess the pros, cons, and overall efficiencies of each approach. These
are all avenues that we are interested in exploring further through the FSSDC, and we welcome your contributions of scripts and findings as you explore this space.

Spell Creation in SQL
---------------------

In SQL, spell creation is done through a series of joins and a function iterating over the data.  Note that because there are so many joins involved in this
approach, indexing the datasets prior to joining can significantly impact performance.

1. The input file is a point-in-time dataset with a time sequence field (here, month/year, though that creates a need to correct for December to January transitions, 
so a basic sequence field would be easier), a case identifier, and a flag for active status.  This dataset is filtered to only active records.  A new flag field
indicating whether the case was active in the previous month is created and set to 0 for all records (this will be populated in step 2).

2. The input file is joined to istelf where month = month-1 and case id = case id.  Where a matching record is found, the flag for activity in the previous month is reset
to 1.

3. The dataset created in step 2 is filtered to include only records where there was no activity in a previous month.  These records are beginnings of spells, and the data
is reshaped to begin to look like spells files, with columns for case id, start month, and end month.  Start month and end month are both set to the same value.

4. A function iterates through the total number of months in the dataset and checks to see if the initial spells table can be joined to a record in the raw data where 
month = end month + 1.  If a join can be made, end month is updated appropriately and the spell is expanded.

The remainder of this script demonstrates how several of the fields used to analyze duration and churn in the data model are created, including total months, 
total months in spell, first month, and last month.

Spell Creation in SAS
---------------------

In SAS, where data is always processed sequentially, the script relies on repeatedly sorting the data and retaining key fields. 

Spell Creation in R
-------------------

Although we do not have a current sample spell creation script in R, it looks like [the R package DataCombine](https://cran.r-project.org/web/packages/DataCombine/DataCombine.pdf) has some 
functions to work with calculating spell-related outcomes.