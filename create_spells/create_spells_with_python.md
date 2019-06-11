# Spell Creation in Python
We have created a Python script to create general spells files that can work with data that has point-in-time information where each observation is associated with a time period and a unique identifier. The script allows you to select the input file with the point-in-time data, the name of the column indicating if the case is active for this time period, the name of the column with the unique identifier, the name of the column with the time period, how much time to allow for administrative churn (in days), and the name of the spells file you wish to create.

Running the file requires python to be installed and knowledge of how to use a terminal. Please see the [tutorial section](../tutorials/README.md) of this site if you are not familiar with these concepts.

# Dependancies
Running this code requires the following libraries:

- `pandas`<br>
- `pytest`

If you have installed the Anaconda distribution of Python as described in the [tutorials](../tutorials/README.md) section these libraries will be installed.

## Running the Python Code
- `spells.py`: takes the following arguments:

- `csv_filename`: Location of input CSV file.

- `active`: Name of a column containing the active indicator.

- `caseID`: Name of column containing the unique caseID.

- `time`: Name of column containing the time period.

- `churn_period_days`: Time to allow for administrative churn when defining a spell (in days). Breaks in service less than or equal to this value will be considered one spell.


Example:<br>
`python spells.py CaseMonths.csv active_ind caseid month 31 spells.csv`


## Testing The Python Script
A file to test the Python code against a few simple use cases is available in *test_spells.py*. Test data is provided in  [test_data](https://github.com/chapinhall/FSSDC/tree/master/create_spells/python_test_data). If you make changes to the Python file to add a new feature you may wish to run some tests to ensure they work correctly. Update the new expected output based on your additions inside the *test_spells.py* file and rerun the tests. You can run the test file by typing `py.test test_spells.py` in your terminal.

If the tests run successfully several lines of text will print out to the terminal ending with:

```
======================= 4 passed in 1.37 seconds ========================
```

