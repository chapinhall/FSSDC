''' This python script is an example of how to create a spells file. It takes a
csv file containing a unique identifier, an activate case indicator,
and a time period for each row and creates an output csv file of the spells.
You can specify how long to allow for administrative churn (in days)
when creating the spells.

Example:
        $ python spells.py CaseMonths.csv active_ind caseID month 31 spells.csv
'''

import argparse
import csv
import pandas as pd

def create_spells(csv_filename, active, caseID, time, churn_period_days):
    '''This function accepts the user parameters from the main function below
    and uses them to transform the input file into a spells file.

    Args:
        csv_filename (str): The name of the input csv file.
        active (str): The name of the column indicating if a case is active
        caseID (str): The name of the column of the unique identifier.
        time (str): The name fo the column of the time period.
        churn_period_days (str): Number of days to allow for administrative churn.
    Returns:
        A list of lists. Each individual list represents one spell.
    '''

    # Read the input file and remove non-active observations
    df = pd.read_csv(csv_filename)
    df = df[df[active] ==1]

    # sort remaing values by caseID and time
    df[time] = pd.to_datetime(df[time])
    df = df.sort_values([caseID,time])

    # determine if the row below is a continous spell based on time being
    # within the churn allotment and caseIDs matching
    df['timeDelta'] = df[time].shift(periods=-1) - df[time]
    df['timeMatch'] = df['timeDelta'] <= pd.Timedelta(days=int(churn_period_days))
    df['caseMatch'] = df[caseID].shift(periods=-1) == df[caseID]
    df['continous'] = df['timeMatch'] & df['caseMatch']

    # iterate over each index of the dataframe and add a spell to the output
    # if the row is not continous
    records = [[caseID,'startDate', 'endDate']]
    for i in range(len(df)):
        if not(df.iloc[i-1]['continous']):
            startDate = df.iloc[i][time].strftime('%Y-%m-%d')
        if not(df.iloc[i]['continous']):
            spell = [df.iloc[i][caseID], startDate, df.iloc[i][time].strftime('%Y-%m-%d')]
            records.append(spell)
    return records

def write_file(records, output_filename):
    ''' This function writes the records to a csv file with the output_filename.
    Args:
        records (list of lists): Spells to be written to file.
        output_filename (str): The name of the output csv file
    '''
    print('Writing spells to {}'.format(output_filename))
    with open(output_filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(records)

if __name__=='__main__':
    '''This reads the users input values and calls the create_spells function.'''
    parser = argparse.ArgumentParser(description='Create Spells file from a CSV'
    ' file containing a column with a unique caseID and a column with a time period.')
    parser.add_argument('csv_filename', type=str,
                    help='Location of input CSV file.')
    parser.add_argument('active', type=str,
                    help='Name of a column containing the active indicator.')
    parser.add_argument('caseID', type=str,
                    help='Name of column containing the unique caseID.')
    parser.add_argument('time', type=str,
                    help='Name of column containing the time period.')
    parser.add_argument('churn_period_days', type=str,
                    help='Time to allow for administrative churn when defining'
                    ' a spell (in days). Breaks in service less than or equal to'
                    ' this value will be considered one spell.')
    parser.add_argument('output_filename', type=str,
                    help='Name of output file containing spells.')
    args = parser.parse_args()
    records = create_spells(args.csv_filename, args.active, args.caseID,
    args.time, args.churn_period_days)
    write_file(records, args.output_filename)
