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

The two scripts take different approaches to creating spells, reflecting the strengths and constraints of the tools used to develop these scripts. In SQL, spell creation
is done through a series of joins and a loop iterating over the data. In SAS, where data is always processed sequentially, the script relies on repeatedly sorting the data
and retaining key fields.

These scripts were originally created as part of routine data processing. Each has some idiosyncracies related to the input data, particularly around the formatting of dates.
These code samples are not generalized for use in other contexts, nor have they been compared to assess the pros, cons, and overall efficiencies of each approach. These
are all avenues that we are interested in exploring further through the FSSDC, and we welcome your contributions of scripts and findings as you explore this space.
