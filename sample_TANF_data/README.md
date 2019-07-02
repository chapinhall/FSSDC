# TANF Data Samples

This repository includes [sample synthetic data](https://github.com/chapinhall/FSSDC/tree/master/sample_TANF_data) in the initial TANF data model structure. The table below briefly describes the TANF data model components. This model is intended 
to be flexible depending on state interests and data availability, but it is generally designed to facilitate analyses around caseload dynamics, churn, and recidivism.

| **Core Data Elements**         |  **Purpose**                                                   | **Examples**                                                               |
|--------------------------------|----------------------------------------------------------------|----------------------------------------------------------------------------|
| Individual identifier          |  Identify members and link to cases                            | client ID, member ID                                                       |
| Case identifier                |  Identify cases and link to members                            | case ID                                                                    |
| Case type                      |  Create categories meaningful to program administrators        | basic cash assistance, child only                                          |
| Geographic indicator           |  Classify by jurisdiction                                      | county name, region                                                        |
| Basic client demographics      |  Characterize client population                                | DOB/age, gender                                                            |
| **Additional Data Elements**   |                                                                |                                                                            |
| Case status indicators         |  Analyze specific issues; adjust for abnormalities in the data | paid late, timed out, recipient of specific intervention                   |
| Other benefit receipt          |  Observe other program participation                           | SNAP receipt, Medicaid receipt                                             |
| Head of household identifier   |  Identify case head of household                               | HOH client ID                                                              |
| Additional client demographics |  Characterize client population more finely                    | Marital status, race/ethnicity, education attainment, citizenship, refugee |

Full documentation for the data model structure is available in an FSSDC [research brief](https://www.mathematica-mpr.com/our-publications-and-findings/publications/family-self-sufficiency-data-center-creating-a-data-model-to-analyze-tanf-caseloads).

The R script [sample_data_introduction.R](https://github.com/chapinhall/FSSDC/blob/master/sample_TANF_data/sample_data_introduction.R) reads in the sample TANF data and provides a basic introduction to this data model.