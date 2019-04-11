# Introduction to Spells
Historical administrative data for family self-sufficiency programs is usually tracked as a series of transactions or point in time data. An alternative method of representing the same data is spells. Each spell defines a start and end date for a particular set of characteristics. It is frequently convient to store data in a spells format for analysis. The code in the section will introduce you to converting point in time data to spells data. 

## Point in Time Data
Each row in point in time data includes one date and several other characteristics such as case id and benefit status.

| case_id | date       | status |
|---------|------------|--------|
| 578     | 2001-01-01 | 1      |
| 578     | 2001-02-01 | 0      |
| 578     | 2001-03-01 | 1      |
| 933     | 2001-01-01 | 1      |
| 933     | 2001-02-01 | 1      |
| 933     | 2001-03-01 | 1      |

## Spells
Each row in a spells file includes a start date and an end date and several other characteristics such as case id and benefit status.

| case_id | start_date | end_date   | status |
|---------|------------|------------|--------|
| 578     | 2001-01-01 | 2001-01-31 | 1      |
| 578     | 2001-02-01 | 2001-02-28 | 0      |
| 578     | 2001-03-01 | 2001-03-31 | 1      |
| 933     | 2001-01-01 | 2001-03-31 | 1      |


## General Spell Creation
We have provided sample code for creating spells in R and Python.

[Create spells in Python](create_spells_with_python.md)

[Create spells in R](create_spells_with_R.md)
