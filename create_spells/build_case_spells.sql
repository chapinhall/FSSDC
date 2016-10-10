--******************************************************************************************
-- 
-- Sample spell transformation script written for use in a postgres database
--
-- G.Sanders 2016-02-26 --> Updated E.Wiegand 2016-03-28
-- Create a spells table for TANF cases and append spell information to the case_master. 
-- This creates final case_months file. 
--******************************************************************************************

\c etl03;
SET search_path TO fss_co;

--Create a new table structure for Case Spells table
DROP TABLE IF EXISTS fss_co.case_spells_co;
CREATE TABLE fss_co.case_spells_co (
CS_ID CHAR(9),
start_month BIGINT,
end_month BIGINT,
spell_months INT,
prior_months_for_case INT,
prior_months_temp VARCHAR(300));

--Create a new table structure for fss_co.orlin_case_months
DROP TABLE IF EXISTS fss_co.orlin_case_months;
CREATE TABLE fss_co.orlin_case_months (
-- insert values
  month BIGINT,
  case_id CHAR(9),
  county_cd CHAR(2),
  county_name TEXT,
  case_type CHAR(3),
  paid_late INT,
  active_ind INT,
  first_month INT,
  first_month_ever INT,
  last_month INT,
  last_month_ever INT,
  total_months INT,
  total_months_spell INT,
  hh_count INT,
  hh_act_count INT,
  adult_count INT,
  adult_act_count INT,
  child_count INT,
  child_act_count INT,
  hhcomp_casetype INT,
  hoh_race_ethn_hl CHAR(2),
  hoh_race_ethn_ak CHAR(2),
  hoh_race_ethn_as CHAR(2),
  hoh_race_ethn_ba CHAR(2),
  hoh_race_ethn_hp CHAR(2),
  hoh_race_ethn_wh CHAR(2),
  hoh_ethnicity VARCHAR(20),
  hoh_gender CHAR(2),
  hoh_citizenship CHAR(2),
  hoh_dob DATE,
  hoh_age INT,
  hoh_marital VARCHAR(26),
  hoh_refugee CHAR(2),
  hoh_spoken_lang VARCHAR(23),
  hoh_written_lang VARCHAR(23),
  any_af INT,
  any_fs INT,
  any_ma INT);

--****************************************************************************************
--Import all records from the case file which have no case records in the previous month - 
-- in other words, payments that begin new spells.
--
--Add prev/next indicators to case_master
DROP TABLE IF EXISTS fss_co.case_spells_temp;
CREATE TABLE fss_co.case_spells_temp AS
  SELECT *,
  0 AS chprev_month_pmt 
  FROM fss_co.case_master_co;

--Calculate prior and later payments made on each case
--This is done by JOINing the new temp payments table to itself,
--so that we can check for existence of prior payments for every payment in the table.
--Previous month had a payment?
UPDATE fss_co.case_spells_temp t1 
  SET chprev_month_pmt = 1 
  FROM fss_co.case_spells_temp t2
  WHERE t2.CS_ID=t1.CS_ID 
  AND t2.pay_mnth=t1.pay_mnth -1;

--Handle cases where December payments appear to be 89 month earlier than January payments (example: 201512, 201601)
UPDATE fss_co.case_spells_temp t1 
  SET chprev_month_pmt = 1 
  FROM fss_co.case_spells_temp t2
  WHERE t2.CS_ID=t1.CS_ID  
  AND RIGHT(RTRIM(TO_CHAR(t1.pay_mnth,'999999')),2) ='01' AND t2.pay_mnth=t1.pay_mnth - 89;

--***************************************************************************************
--The SPELLS table will be created directly from this 'case_spells_temp' table.
--Note that initially, all spells will begin and end in the same month.
--End_Month will be updated as payments for each subsequent month are evaluated.

INSERT INTO fss_co.case_spells_co 
  (CS_ID, start_month, end_month)
  SELECT DISTINCT  
    CS_ID, 
    pay_mnth AS start_month,
    pay_mnth AS end_month
  FROM fss_co.case_spells_temp 
  WHERE (chprev_month_pmt IS NULL OR chprev_month_pmt !=1)
  ORDER BY CS_ID, pay_mnth; 
  
--View initial results
-- SELECT 'Initial import of spells from payments_by_case_month_temp -- ONLY payments that show NO payments for this case in the previous month' AS message;
-- SELECT * FROM fss_co.case_spells_co ORDER BY CS_ID, start_month LIMIT 30; 

--Average difference between start and emd months of each spell should be ZERO at this point.
SELECT ROUND(AVG(end_month - start_month),1) AS avg_diff  FROM fss_co.case_spells_co WHERE (end_month - start_month) < 89  ;


--*****************************************************************************************
--Now all case with no immediate predecessor (that is, no active case in the previous month)
--have been pulled into the new Spells table. We can now start finding end-dates for each of these spells,
--one month at a time. For each successive month, set the End_Month to that month 
--if and only if the CS_IDs match and the existing spell End_Date immediately precedes the payment month.  

--Create a function to sequentially evaluate case/months against spells 
--for as many iterations as we have months in the sample.
--Some spells will continue from the very first month until the very last month, 
--but many cases willl have interruptions or will stop altogether. 
DROP FUNCTION IF EXISTS fss_co.extend_spell(_months_in_sample int);
CREATE OR REPLACE FUNCTION fss_co.extend_spell(_months_in_sample int) RETURNS INTEGER AS $$
DECLARE 
  x INTEGER := 0;
BEGIN
  LOOP
    UPDATE fss_co.case_spells_co t1 
      SET end_month = t2.PAY_MNTH
      FROM fss_co.case_master_co t2
      WHERE t2.CS_ID=t1.CS_ID 
      AND t2.PAY_MNTH = t1.end_month +1;
  
    UPDATE fss_co.case_spells_co t1 
      SET end_month = t2.PAY_MNTH 
      FROM fss_co.case_master_co t2 
      WHERE t2.CS_ID = t1.CS_ID 
        AND RIGHT(RTRIM(TO_CHAR(t1.end_month,'999999')),2) ='12' 
        AND t2.PAY_MNTH = t1.end_month +89;

    x := x+1;
    IF x = $1 THEN
    --IF x = 50 THEN
        EXIT;  
    END IF;

  END LOOP;
  RETURN x;
END;
$$ LANGUAGE plpgsql VOLATILE;

--Execute the function:
SELECT fss_co.extend_spell(14);

--Demonstrate what it has done: 
SELECT ROUND(AVG(end_month - start_month),1) AS avg_diff  FROM fss_co.case_spells_co WHERE (end_month - start_month) < 89  ;
SELECT start_month, end_month, (end_month-start_month) AS diff  FROM fss_co.case_spells_co 
  WHERE (end_month-start_month) > 3 AND (end_month-start_month) < 89 ORDER BY start_month LIMIT 10;

--******************************************************************************************************************
-- Index because creating cumulative spells will require lots of joins on this data

CREATE INDEX case_id_pmsp ON fss_co.case_spells_co (cs_id);
CREATE INDEX start_month_pmsp ON fss_co.case_spells_co (start_month);
CREATE INDEX end_month_pmsp ON fss_co.case_spells_co (end_month);
CREATE INDEX spell_months_pmsp ON fss_co.case_spells_co (spell_months);

--******************************************************************************************************************
  

--In order to calculate true spell lengths, we need logic that can handle same-year subtraction (201504 - 201501)
-- AND different-year subtraction (201409 to 201601).

UPDATE fss_co.case_spells_co
  SET spell_months = 
   ( DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(end_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(end_month,'999999'))),2) || '01', 'YYYYMMDD')) - DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(start_month,'999999'))),2) || '01', 'YYYYMMDD')) )  *12  + ( DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(end_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(end_month,'999999'))),2) || '01', 'YYYYMMDD')) -  DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(start_month,'999999'))),2) || '01', 'YYYYMMDD')) ) +1 ;

--*******************************************************************************************************************
--Determine the number of months of benefits PREVIOUS to any given month (including all prior spells)
--NOTE: this query JOINS the spells table with a copy of itself.
--As each previous spell is tallied, we import it into a TEMP field so that it will not be tallied again --
--because we check to make sure that it does not yet occur in the TEMP field string.
DROP TABLE IF EXISTS fss_co.case_spells_temp;
CREATE TABLE fss_co.case_spells_temp AS 
  SELECT DISTINCT CS_ID, start_month, end_month, spell_months 
  FROM fss_co.case_spells_co
  ORDER BY CS_ID, start_month, end_month;

CREATE INDEX case_id_pmsptmp ON fss_co.case_spells_temp (cs_id);
CREATE INDEX start_month_pmsptmp ON fss_co.case_spells_temp (start_month);
CREATE INDEX end_month_pmsptmp ON fss_co.case_spells_temp (end_month);
CREATE INDEX spell_months_pmsptmp ON fss_co.case_spells_temp (spell_months);

--*****************************************************************************************************************
--Loop thru the spells as many times as might be necessary to catch all prior spells for every case
UPDATE fss_co.case_spells_co SET prior_months_for_case = 0;
UPDATE fss_co.case_spells_co SET prior_months_temp = '';

DROP FUNCTION IF EXISTS fss_co.calc_prior_case_months(_months_in_sample int);
CREATE OR REPLACE FUNCTION fss_co.calc_prior_case_months(_months_in_sample int) RETURNS INTEGER AS $$
DECLARE
  x INTEGER := 0;
BEGIN
  LOOP
    UPDATE fss_co.case_spells_co t1 
      SET prior_months_for_case = prior_months_for_case + t2.spell_months,
        prior_months_temp = 
          RTRIM(prior_months_temp) || ' | ' || LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))) || '-' || LTRIM(RTRIM(TO_CHAR(t2.end_month,'999999'))) || ':' || LTRIM(RTRIM(TO_CHAR(t2.spell_months,'99'))) 
    FROM fss_co.case_spells_temp t2 
    WHERE t2.CS_id=t1.CS_id 
      AND t2.end_month < t1.start_month 
      AND POSITION(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))) IN t1.prior_months_temp) = 0; --this previous spell has NOT been tallied yet 

    x := x+1;
    IF x = $1 THEN
    --IF x = 50 THEN
        EXIT;
    END IF;

  END LOOP;
  RETURN x;
END;
$$ LANGUAGE plpgsql VOLATILE;

--Execute the function:
SELECT fss_co.calc_prior_case_months(36);

--*********************************************************************************************************
-- Execute final recodes and append spell information

INSERT INTO fss_co.orlin_case_months (
    month, case_id, county_cd, county_name, case_type, paid_late, active_ind, hh_count, hh_act_count,
    adult_count, adult_act_count, child_count, child_act_count, hhcomp_casetype, hoh_race_ethn_hl,
    hoh_race_ethn_ak, hoh_race_ethn_as, hoh_race_ethn_ba, hoh_race_ethn_hp, hoh_race_ethn_wh, hoh_ethnicity,
    hoh_gender, hoh_citizenship, hoh_dob, hoh_age, hoh_marital, hoh_refugee, hoh_spoken_lang, hoh_written_lang,
    any_af, any_fs, any_ma)
   
    SELECT DISTINCT pay_mnth AS month, CS_ID AS case_id, cnty_cd AS county_cd, cnty_nm AS county_name, 
	   case_type, paid_late, active_ind, hh_count, hh_act_count, adult_count, adult_act_count, child_count, 
	   child_act_count, hhcomp_casetype, hoh_race_ethn_hl,  hoh_race_ethn_ak, hoh_race_ethn_as, hoh_race_ethn_ba, 
	   hoh_race_ethn_hp, hoh_race_ethn_wh, hoh_ethnicity, hoh_gender, hoh_citizenship, hoh_dob, 0 AS hoh_age, hoh_marital, 
	   hoh_refugee, hoh_spoken_lang, hoh_written_lang, any_af, any_fs, any_ma
	
    FROM fss_co.case_master_co;

--First_Month: For every case-month, determine whether it appears as a Start_Month in the case spells table.
UPDATE fss_co.orlin_case_months t1 
  SET first_month = 1 
  FROM fss_co.case_spells_co t2 
  WHERE t2.cs_id=t1.case_id AND t2.start_month=t1.month;

--Last_Month: For every case-month, determine whether it appears as an End_Month in the case spells table.
UPDATE fss_co.orlin_case_months t1 
  SET last_month = 1 
  FROM fss_co.case_spells_co t2 
  WHERE t2.cs_id=t1.case_id AND t2.end_month=t1.month;

--First_Month_Ever: For every case-month, determine whether it appears as earliest spell start. 
UPDATE fss_co.orlin_case_months t1
  SET first_month_ever = 1 
  FROM 
      (SELECT CS_ID AS case_id, MIN(start_month) as earliest_start
	   FROM fss_co.case_spells_co
	   GROUP BY CS_ID) t2
  WHERE t2.case_id=t1.case_id AND t2.earliest_start = t1.month;
  
--Last_Month_Ever: For every case-month, determine whether it appears as latest spell end. 
UPDATE fss_co.orlin_case_months t1
  SET last_month_ever = 1 
  FROM 
      (SELECT CS_ID AS case_id, MAX(end_month) as last_end
	   FROM fss_co.case_spells_co
	   GROUP BY CS_ID) t2
  WHERE t2.case_id=t1.case_id AND t2.last_end = t1.month;

--Total_months_spell
--The following calculation is not very intuitive; to see the logic more clearly, try the following SQL command:
--SELECT t1.case_id, t1.month, t2.start_month, t2.end_month, DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(t1.month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t1.month,'999999'))),2) || '01', 'YYYYMMDD')),  DATE_PART('year', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')), DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(t1.month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t1.month,'999999'))),2) || '01', 'YYYYMMDD')),  DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')),    'WOW' AS wow, ( DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(t1.month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t1.month,'999999'))),2) || '01', 'YYYYMMDD')) -  DATE_PART('year', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')) ) *12 + ( DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(t1.month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t1.month,'999999'))),2) || '01', 'YYYYMMDD')) -  DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')) )   FROM fss_co.payment_case_months_orlin t1 INNER JOIN fss_co.payment_spells_co t2 ON t2.case_id=t1.case_id AND t1.month >= t2.start_month AND t1.month <= t2.end_month AND t2.start_month != t2.end_month  LIMIT 30;
UPDATE fss_co.orlin_case_months t1
  SET total_months_spell = 
  ( DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(month,'999999'))),2) || '01', 'YYYYMMDD')) - DATE_PART('YEAR', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')) )  *12  + ( DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(month,'999999'))),2) || '01', 'YYYYMMDD')) -  DATE_PART('MONTH', TO_DATE( LEFT(LTRIM(TO_CHAR(t2.start_month,'999999')),4) || RIGHT(LTRIM(RTRIM(TO_CHAR(t2.start_month,'999999'))),2) || '01', 'YYYYMMDD')) ) +1
  FROM fss_co.case_spells_co t2
  WHERE t2.cs_id=t1.case_id
  AND t1.month >= t2.start_month
  AND t1.month <= t2.end_month;

--Total_Months
--Total_Months is the total number of payment-months that had been received PRIOR TO this month.
--NOTE: total_months must be updated AFTER total_months_spell has been populated,
--  because it is factored into total_months!!
UPDATE fss_co.orlin_case_months t1 
  SET total_months = t2.prior_months_for_case + total_months_spell
  FROM fss_co.case_spells_co t2
  WHERE t2.cs_id = t1.case_id
    AND t1.month >= t2.start_month
    AND t1.month <= t2.end_month;