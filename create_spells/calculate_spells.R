# The calculate_spells.R file was created by the FSSDC team.
# More information on the FSSDC can be found here:
# https://harris.uchicago.edu/research-impact/centers/family-self-sufficiency-data-center

# Set Workspace ----------------------------------------------------------------
rm(list = ls())
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(require(doParallel))

# Variables all states must change ---------------------------------------------
PRIMARY_FILE <- ""
OUTPUT_FILE <- ""
SUMMARY_FILE <- ""

# Optional variables to modify -------------------------------------------------
CHURN <- 0
CASE_FIELDS <- c()
WAGES_FILE <- ""
DATE_FORMAT <- '%m/%d/%Y' # see https://www.statmethods.net/input/dates.html for info on R date formatting
MULTI_CORE <- FALSE # Set to True to run on multiple cores. This may make large jobs run faster.



# Functions --------------------------------------------------------------------
ReadCases <- function(primary_file, active_status, inactive_status,case_fields,
                      date_format){
  # Read and sort cases
  cases <- tryCatch(
    {
      read.csv(file=primary_file, sep=",", header=TRUE,
               colClasses = "character")
    },
    error=function(cond){
      if(tolower(.Platform$OS.type) == "windows"){
        stop("Failed to read input file. It looks like you are running
             a Windows operating system. Check the PRIMARY_FILE filepath. R cannot
             read the backslash character used by Windows to seperate folders.
             Use a double backslash instead. For more information see:
             https://kb.iu.edu/d/azzp")
      }
      else{
        stop("Failed to read input file. Check the PRIMARY_FILE filepath.")
      }
      }
        )
  colnames(cases) <- tolower(colnames(cases))
  # read in date depending on format of input file.
  # dates can either be in one field called 'date' or two fields called 'month' and 'year'
  # the date_format parameter is '' if the input file is in the 'month' 'year' format.
  if (date_format != ''){
    cases$date <- as.Date(cases$date,format=date_format)
  }
  else {
    cases$date <- as.Date(paste0(cases$year,"-",cases$month,"-01",
                               format="%Y-%m-%d"))
  }
  cases <- cases %>%
    arrange(caseid,date)
  cases_nonmissing <- cases %>%
    filter(!is.na(caseid),!is.na(date))
  num_drop <- nrow(cases) - nrow(cases_nonmissing)
  if(num_drop != 0){
    message(paste("Dropped", num_drop, "rows due to missing caseid or date fields"))
  }
  return(cases_nonmissing)
}

ValidateInputs <- function(cases, active_status, inactive_status, case_fields,
                           churn){
  inactive_flag <- TRUE # Flag for files that contain rows with inactive_status.
  # Check inputs for invalid data
  if (!all(case_fields %in% colnames(cases))){
    stop("Check the CASE_FIELDS variable. There are field names listed in CASE_FIELDS
         that do not exist in the input file.")
  }

  if (!all(c("caseid","tanf") %in% colnames(cases))){
    stop("Check the input file. It must contain the columns: caseid, date, tanf.
         Column headers are case insensitive.")
  }

  if (!("date" %in% colnames(cases) | all(c("month","year") %in% colnames(cases)))){
    stop("Check the input file. It must contain a date field or a month and year field.")
  }

  if (length(unique(cases$tanf)) > 2){
    stop("More than two values were found in the tanf column. Check the data.
         This field should indicate either active or inactive.")
  }
  if (!active_status %in% unique(cases$tanf)){
    stop("No active cases found in the data.")
  }
  if (!inactive_status %in% unique(cases$tanf)){
    message("No inactive cases found in the data. Inactive cases will
            be inferred.")
    inactive_flag <- FALSE
  }
  if(churn < 0) stop("CHURN must be at least 0")
  if(churn%%1 != 0) stop("CHURN must be an integer")

  return(inactive_flag)
}

CreateInactiveRows <- function(caseid,startMonth,endMonth,inactive_status){
  # Populate a missing value row as inactive
  dates <- seq(from=startMonth, to=endMonth,by='month')
  missingRows <- data.frame(date=dates[1:length(dates)-1],
                            caseid=caseid,
                            tanf=inactive_status,
                            stringsAsFactors = FALSE)
  return(missingRows)
}


FillMissingCasesAll <- function(cases, active_status, inactive_status, inactive_flag){
  if (inactive_flag){
    return(cases)
  } else {
    max_date <- max(cases[,'date'])
    # Fill in new rows
    out <- setDT(cases)[, list(date=seq(min(date), max_date, by = 'month')), caseid]
    # Join with cases to get tanf
    out <- cases[out, on = c('caseid', 'date')]
    out[is.na(get('tanf')), ('tanf'):='0']
    return(as.data.frame(out))
  }
}


CalculateSpells <- function(processed_cases,case_fields){
  # Calculate spells on cases processed for churn and missing rows
  processed_cases <- processed_cases %>%
    group_by(caseid) %>%
    mutate(lag=lag(x=spellField,n=1,default='-9999')) %>%
    mutate(lead=lead(x=spellField,n=1,default='-9999'))

  # Calculate spell start and end dates
  spellStart <- processed_cases[processed_cases$spellField !=
                                  processed_cases$lag,] %>%
    ungroup() %>%
    select(one_of(c(case_fields,"caseid","date","tanf"))) %>%
    mutate(startMonth = as.integer(format(date,"%m")),
           startYear = as.integer(format(date, "%Y"))) %>%
    rename(startDate=date)

  spellEnd <- processed_cases[processed_cases$spellField !=
                                processed_cases$lead,] %>%
    ungroup() %>%
    select(date) %>%
    mutate(endMonth = as.integer(format(date,"%m")),
           endYear = as.integer(format(date, "%Y"))) %>%
    rename(endDate=date)

  spells <- cbind(spellStart,spellEnd) %>%
    arrange(caseid,startDate) %>%
    select(one_of("caseid","tanf",case_fields,"startDate","startMonth",
                  "startYear","endDate","endMonth","endYear"))
  return(spells)
}

CalculateSpellLength <- function(spells){

  start_month <- as.numeric(spells$startMonth)
  end_month <- as.numeric(spells$endMonth)
  start_year <- as.numeric(spells$startYear)
  end_year <- as.numeric(spells$endYear)
  spells$spellLength <- (end_year - start_year) * 12 + (end_month - start_month) + 1

  return(spells)
}

SummarizeSpells <- function(spells,summary_file){
  # Write a summary text file

  fileConn <- file(summary_file)
  # Total Summaries
  summaryDateRange <- paste("Date Range:",
                            paste(format(min(spells$startDate),"%m"),
                                  format(min(spells$startDate),"%Y"),sep = "/"),
                            "to",
                            paste(format(max(spells$endDate),"%m"),
                                  format(max(spells$endDate),"%Y"),sep = "/"))
  uniqueCases <- paste("Number of Cases:",length(unique(spells$caseid)))

  # Active Summaries
  activeSpells <- paste("Number of Active Spells:",
                        nrow(spells[spells$tanf=="1",]))
  activeMaxSpellsCase <- paste("Max Number of Active Spells in a Case:", max(table(spells[spells$tanf=="1",]$caseid)))
  activeAvgSpellLength <- paste("Average Length of Active Spell (in months):", round(mean(spells[spells$tanf=="1",]$spellLength),2))

  # Inactive Summaries
  inactiveSpells <- paste("Number of Inactive Spells:",
                          nrow(spells[spells$tanf=="0",]))

  if (nrow(spells[spells$tanf=="0",]) > 0) { # special case for no inactive spells
    inactiveMaxSpellsCase <- paste("Max Number of Inactive Spells in a Case:", max(table(spells[spells$tanf=="0",]$caseid)))
    inactiveAvgSpellLength <- paste("Average Length of Inactive Spell (in months):", round(mean(spells[spells$tanf=="0",]$spellLength),2))
  }
  else{
    inactiveMaxSpellsCase <- "Max Number of Inactive Spells in a Case: 0"
    inactiveAvgSpellLength <- "Average Length of Inactive Spell (in months): 0"
  }
  # Write to file
  writeLines(c("Total Spells Summary:",summaryDateRange,uniqueCases
               ,"\n","Active Spells:",activeSpells,
               activeMaxSpellsCase,activeAvgSpellLength,"\n",
               inactiveSpells,inactiveMaxSpellsCase,
               inactiveAvgSpellLength), fileConn)
  close(fileConn)

}

WriteSpells <- function(spells,output_file){
  # Write spells to csv file
  tryCatch(
    {
      write.csv(x= spells,file=output_file,row.names = FALSE,na = '""')

    },
    error=function(cond){
      if(tolower(.Platform$OS.type) == "windows"){
        stop("Failed to write output file. It looks like you are running
             a Windows operating system. Check the  OUTPUT_FILE filepath. R cannot
             read the backslash character used by Windows to seperate folders.
             Use a double backslash instead. For more information see:
             https://kb.iu.edu/d/azzp")
      }
      else{
        stop("Failed to write output file. Check the OUTPUT_FILE filepath.")
      }
      }
        )
}

ChangeStatusCase <- function(cases,caseid,active_status,inactive_status, churn){
  # Change status of a unique case depending on churn global parameter
  case <- cases[cases$caseid==caseid,]
  sequential_inactive <- 0
  for (i in 1:nrow(case)){
    if(case[i,'tanf']==inactive_status){
      sequential_inactive <- sequential_inactive + 1
    }
    else if(case[i,'tanf']==active_status){
      if(sequential_inactive >= 1 & sequential_inactive <= churn){
        for(j in 1:sequential_inactive){
          case[i-j,'tanf'] <- active_status
          case[i-j,'churn'] <- TRUE
        }
      }
      else if(sequential_inactive==1 & churn > 0){
        case[i-1,'tanf'] <- active_status
        case[i-j,'churn'] <- TRUE
      }
      sequential_inactive <- 0
    }
  }
  return(case)
}

ChangeStatusAll <- function(cases,active_status,inactive_status,case_fields,
                            churn, multi_flag){
  # Change status of all cases depending on churn global parameter

  if (churn == 0){ # Exit if chuen is 0.
    # Concat fields that define spells
    cases$spellField <- do.call(paste0,cases[c("tanf",case_fields)])
    return(cases)
  }

  if (multi_flag) { # Use multiple cores.
    # Change status of all cases depending on churn global parameter
    cases$churn <- FALSE
    all_caseid <- unique(cases$caseid)
    env_functions <- c("ChangeStatusCase","bind_rows")
    processed_cases <- foreach (i=1:length(all_caseid),.export=env_functions) %dopar%{
      caseid <- all_caseid[i]
      temp <- ChangeStatusCase(cases=cases,caseid = caseid,
                               active_status = active_status,
                               inactive_status = inactive_status,
                               churn = churn)
    }
    processed_cases <- bind_rows(processed_cases)
    # concat fields that define spells
    processed_cases$spellField <- do.call(paste0,
                                          processed_cases[c("tanf",case_fields)])
    #resort
    processed_cases <- processed_cases %>%
      arrange(caseid,date)
    # set rows change due to churn to most recent active row for that case
    last_active_spellField <- NULL
    for (i in 1:nrow(processed_cases)){
      if (!processed_cases[i,'churn']){
        last_active_spellField <- processed_cases[i,'spellField']
      }
      if (processed_cases[i,'churn']){
        processed_cases[i,'spellField'] <- last_active_spellField
      }
    }
  } else { # Do not use multiple cores.
    cases$churn <- FALSE
    processed_cases <- data.frame()
    for (caseid in unique(cases$caseid)){
      temp <- ChangeStatusCase(cases=cases,caseid = caseid,
                               active_status = active_status,
                               inactive_status = inactive_status,
                               churn)
      processed_cases <- bind_rows(processed_cases,temp)
    }
    # concat fields that define spells
    processed_cases$spellField <- do.call(paste0,
                                          processed_cases[c("tanf",case_fields)])
    #resort
    processed_cases <- processed_cases %>%
      arrange(caseid,date)
    # set rows change due to churn to most recent active row for that case
    last_active_spellField <- NULL
    for (i in 1:nrow(processed_cases)){
      if (!processed_cases[i,'churn']){
        last_active_spellField <- processed_cases[i,'spellField']
      }
      if (processed_cases[i,'churn']){
        processed_cases[i,'spellField'] <- last_active_spellField
      }
    }
  }
  return(processed_cases)
}

ReadWages <- function(wages_file){
  wages <- tryCatch(
    {
      read.csv(file = wages_file, sep = ",", header = TRUE,
               colClasses = "character")
    },
    error=function(cond){
      stop("Failed to read wages file. Check the file path. If you do not have a
            wages file to merge, set the WAGES_FILE parameter to be an empty string.")

    }
  )
  colnames(wages) <- tolower(colnames(wages))
  wages <- wages %>% mutate(quarter = as.integer(quarter),
                            year = as.integer(year),
                            earnings = as.integer(earnings))
  return(wages)
}

# Add Quarter info to Spells
quarterLookup <- function(month){
  quarter <- ifelse(month %in% c(1,2,3),1,
                    ifelse(month %in% c(4,5,6),2,
                           ifelse(month %in% c(7,8,9),3,
                                  ifelse(month %in% c(10,11,12),4,NA))))
}

MergeWages <- function(wages_file,spells,case_fields){
  # remove unused fields from output
  spells <- spells %>% select(-startDate,-endDate)

  # If wages_file is an empty string do not perform a merge
  if (wages_file != ''){
    wages <- ReadWages(wages_file)
    spells <- spells %>%
      mutate_at(vars(contains("month")),.funs = funs(quarter = quarterLookup(.))) %>%
      mutate(endYearPlus1 = endYear + 1,
             endMonth_quarterPlus1 = endMonth_quarter + 1) %>% # add startWage
      left_join(wages, by = c("startMonth_quarter" = "quarter",
                              "startYear" = "year",
                              "caseid" = "caseid"))%>%
      rename(startWage = earnings) %>%                         # add endWage
      left_join(wages,
                by = c("endMonth_quarter" = "quarter",
                       "endYear" = "year",
                       "caseid" = "caseid")) %>%
      rename(endWage = earnings)

    # add nextWage (wage in quarter after endMonth_quarter)
    # this is done in two parts - quarters 1 - 3 and quarters 4 done seperately
    spells_q1_q3 <- spells %>%
      filter(endMonth_quarter != 4) %>%
      left_join(wages,
                by = c("endMonth_quarterPlus1" = "quarter",
                       "endYear" = "year",
                       "caseid" = "caseid")) %>%
      rename(nextWage = earnings) %>%
      select(one_of("caseid", "tanf",case_fields, "startMonth","startYear",
                    "endMonth", "endYear", "spellLength","startWage","endWage",
                    "nextWage"))

    spells_q4 <- spells %>%
      filter(endMonth_quarter == 4) %>%
      left_join(wages %>% filter(quarter == 1),
                by = c("endYearPlus1" = "year",
                       "caseid" = "caseid")) %>%
      rename(nextWage = earnings) %>%
      select(one_of("caseid", "tanf",case_fields, "startMonth","startYear",
                    "endMonth", "endYear", "spellLength","startWage","endWage",
                    "nextWage"))

    # combine nextWage for merges in q1-q3 and in q4
    spells_merged <- bind_rows(spells_q1_q3,spells_q4)

    # resort after combining
    spells <- spells_merged %>% arrange(caseid,startYear,startMonth)
  }

  #convert date fields to string type
  spells <- spells %>% mutate(startMonth = as.character(startMonth),
                                     startYear = as.character(startYear),
                                     endMonth = as.character(endMonth),
                                     endYear = as.character(endYear))
  return(spells)
}

CallFunctions <- function(primary_file, output_file, summary_file,
                          wages_file = "",
                          active_status = "1", inactive_status = "0",
                          case_fields = NULL, churn = 0,
                          date_format = '', multi_flag=FALSE){
  if (multi_flag){
    # Set up cores for parallel processing.
    cores <- detectCores()
    cluster1 <- makeCluster(cores[1]-1)
    registerDoParallel(cluster1)
    on.exit(stopCluster(cluster1))

  }
  # Call all functions needed to read,calculate,write spells
  if (is.null(case_fields)){
    case_fields <- c()
  }
  case_fields <- tolower(case_fields) # make case_fields case insensitive
  cases <- ReadCases(primary_file=primary_file, active_status= active_status,
                     inactive_status = inactive_status,
                     case_fields = case_fields, date_format = date_format)
  inactive_flag <- ValidateInputs(cases,active_status, inactive_status, case_fields,
                 churn)
  cases <- FillMissingCasesAll(cases = cases,active_status=active_status,
                          inactive_status=inactive_status,
                          inactive_flag=inactive_flag)
  processed_cases <- ChangeStatusAll(cases = cases,active_status=active_status,
                                     inactive_status=inactive_status,
                                     case_fields=case_fields, churn, multi_flag)
  spells <- CalculateSpells(processed_cases = processed_cases,
                            case_fields=case_fields)
  spells <- CalculateSpellLength(spells)
  SummarizeSpells(spells,summary_file)
  spells <- MergeWages(wages_file = wages_file,spells = spells,case_fields = case_fields)
  WriteSpells(spells = spells, output_file= output_file)
}


# Run Script -------------------------------------------------------------------

CallFunctions(primary_file = PRIMARY_FILE, output_file = OUTPUT_FILE,
              summary_file = SUMMARY_FILE, wages_file = WAGES_FILE,
              case_fields = CASE_FIELDS, churn = CHURN,
              multi_flag = MULTI_CORE, date_format = DATE_FORMAT)
