# Introduction to Spells
Historical administrative data for family self-sufficiency programs is usually tracked as a series of transactions or point-in-time information.
However, analyses of duration, churn, and recidivism require that data be constructed in some interim step as spells. Spells files have an index variable
(i.e. case ID) and fields for service start date and service end date. Each unbroken spell of service receipt is reflected as a single row. For research
purposes interruptions in benefit receipt of 1-4 months may be regarded as administrative churn (for example, delays related to paperwork processing) and
disregarded. These decisions around gaps inform how spells are defined and constructed, but do not change the essential data structure.

## General Spell Creation
This repo contains sample code for creating spells in R and Python.

[Create spells in R](create_spells_with_python.md)

[Create spells in Python](create_spells_with_R.md)
