# SAMPLE_DATA_INTRODUCTION.R

# This script provides a basic introduction to the sample TANF data

library("ggplot2")

# setwd("")
# Set working directory to folder containing GitRepo

# Read in case data and review basic data structure
cases <- read.csv("sample_TANF_data/CaseMonths.csv", stringsAsFactors=FALSE, header=TRUE)
head(cases)
dim(cases)
dim(unique(cases[,c("caseid", "month")])) 
# Note that this data is unique at case ID/month combination
summary(cases)
# Set month as date
cases$month <- as.Date(cases$month)

# Read in member data and review basic data structure
members <- read.csv("sample_TANF_data/MemberMonths.csv", stringsAsFactors=FALSE, header=TRUE)
head(members)
dim(members)
dim(unique(members[,c("client_id", "month")]))
# Note that this data is unique at client ID/month combination
summary(members)
# Set month as date
members$month <- as.Date(members$month)


# Using this data to look at characteristics at a particular point-in-time

caseload_by_hoh_age <- ggplot(data=cases[cases$month=="2014-12-01",], aes(x=hoh_age)) + geom_bar()
print(caseload_by_hoh_age)

caseload_by_hoh_gender <- ggplot(data=cases[cases$month=="2014-12-01",], aes(x=hoh_gender)) + geom_bar()
print(caseload_by_hoh_gender)

caseload_by_hhcomp <- ggplot(data=cases[cases$month=="2013-09-01",], aes(x=hhcomp_casetype)) + geom_bar()
print(caseload_by_hhcomp)

caseload_by_child_count <- ggplot(data=cases[cases$month=="2013-09-01",], aes(x=child_count)) + geom_bar()
print(caseload_by_child_count)


# Looking at change in caseload size and composition over time

caseload_over_time <- ggplot(data=cases[cases$active_ind==1,], aes(x=month)) + geom_line(stat="bin")
print(caseload_over_time)

caseload_over_time_by_type <- ggplot(data=cases[cases$active_ind==1,], aes(x=month, group=case_type, color=case_type)) + geom_line(stat="bin")
print(caseload_over_time_by_type)


# Explore changes in caseload in more detail

starts_over_time <- ggplot(data=cases[cases$first_month==1,], aes(x=month)) + geom_line(stat="bin")
print(starts_over_time)

stops_over_time <- ggplot(data=cases[cases$last_month==1,], aes(x=month)) + geom_line(stat="bin")
print(stops_over_time) # Note surge at end of period is product of data structure

new_over_time <- ggplot(data=cases[cases$first_month_ever==1,], aes(x=month)) + geom_line(stat="bin")
print(new_over_time)

returns_over_time <- ggplot(data=cases[cases$first_month==1 & cases$first_month_ever!=1,], aes(x=month)) + geom_line(stat="bin")
print(returns_over_time)