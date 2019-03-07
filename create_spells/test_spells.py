import pytest
from spells import create_spells

### Build expected spells ###
expected_1par_1spell = [['caseID','startDate','endDate'],
[0,'1900-11-01', '1901-07-01']]

expected_1par_2spell = [['caseID', 'startDate', 'endDate'],
[0, '1900-11-01', '1901-02-01'],
[0, '1901-04-01', '1901-07-01']]

expected_2par_1spell = [['caseID', 'startDate', 'endDate'],
[0, '1900-11-01', '1901-07-01'],
[1, '1900-11-01', '1901-07-01']]

expected_2par_2spell = [['caseID', 'startDate', 'endDate'],
[0, '1900-11-01', '1901-02-01'],
[0, '1901-04-01', '1901-07-01'],
[1, '1900-11-01', '1901-02-01'],
[1, '1901-04-01', '1901-07-01']]

### Spells Creation Tests ###
def test_1par_1spell():
    actual_spells = create_spells("python_test_data/par1.csv", "active",
     "caseID", "month", "62")
    assert actual_spells == expected_1par_1spell

def test_1par_2spell():
    actual_spells = create_spells("python_test_data/par1.csv", "active",
     "caseID", "month", "31")
    assert actual_spells == expected_1par_2spell

def test_2par_1spell():
    actual_spells = create_spells("python_test_data/par2.csv", "active",
    "caseID", "month", "62")
    assert actual_spells == expected_2par_1spell

def test_2par_2spell():
    actual_spells = create_spells("python_test_data/par2.csv", "active",
    "caseID", "month", "31")
    assert actual_spells == expected_2par_2spell
