
/*********************************************************************
* Creates food stamp receipt spells for specified multi-service
* matching round.  Four types of spells are generated:
*  1.  Case spells: active status for cases determined from case-
*      level fields alone.
*  2.  Indcase spells: active status for individuals with specific
*      case identified.  Note that individuals can be active on 
*      multiple cases at the same time.  These situations are treated
*      as valid for the purpose of calculating spells.
*  3.  Nogap spells:  active status for individuals aggregating  
*      across cases.  Nogap signifies that gaps in 
*      service receipt are not bridged, thus a one month interruption
*      is treated as a valid event sequence.
*  4.  Standard spells:  same as no gap, but one month interruptions
*      in service receipt are bridged.
*  Spells still open as of the month of the multiservice match
*  are given a spell end date of one month later, thus the R8
*  spells have a maximum end date of jan 31 2014, and dec 2013 is
*  not a valid end date.        
*********************************************************************;
*********************************************************************
* SETTING REFERENCE AND OUTPUT LIBRARIES.         
*********************************************************************/;

libname here '.';
libname oracli oracle user=&orauser orapw=&orapass path=&oradb;

libname xwalk '/researchdata/il/dhs/sas_spells/';

options nocenter implmac obs=max mprint ;

%include "/projects/sasmacros/fixupdt.sas";

***** Specify ms matching round used and corresponding cdb pull;

%let currupdt=350;
%let msdate=201512;



%macro getspell;

*********************************************************************
* Pull case data for all cases. 
*********************************************************************;

	PROC SQL;
            CREATE TABLE CASES AS
            SELECT A.ch_dpa_caseid, 
                   B.fsstat,
                   B.catstat, 
                   B.last_update_id,
                   B.update_id AS case_update_id
            FROM oracli.ilpard_CaseAll A, oracli.ilpard_CaseStatus B
            WHERE A.ch_dpa_caseid=B.ch_dpa_caseid and
                  b.update_id<=&currupdt.

            UNION ALL

            SELECT A.ch_dpa_caseid,
                   B.fsstat,
                   B.catstat, 
                   B.last_update_id,
                   B.orig_update_id  AS case_update_id
            FROM oracli.ilpard_CaseAll A, oracli.ilpard_CaseStatus_changes B
            WHERE A.ch_dpa_caseid=B.ch_dpa_caseid and         
                  b.orig_update_id<=&currupdt.;

data cases;
set cases;
  if catstat in ('A','G') and fsstat='3' then fs=1;
  else fs=0;

proc sort data=cases;
  by ch_dpa_caseid case_update_id;


***** Calculate case fs spells;

data case_sp;
set cases;

fixupdt update=case_update_id pulldt=pull_date;
if last_update_id^=99999 then do;
  fixupdt update=last_update_id pulldt=last_pull_date;
end;
else last_pull_date=.;

proc sort;
  by ch_dpa_caseid pull_date;

proc datasets lib=work nolist;
delete cases;
quit;

data case_sp;
set case_sp;
  by ch_dpa_caseid pull_date;
  
  retain case_start last_fs;

  if first.ch_dpa_caseid then do;
    case_start=pull_date;
    last_fs=fs;
  end;
  else do;
    if last_fs^=fs then do;
      case_start=pull_date;
    end;
    last_fs=fs;
  end;

proc sort data=case_sp;
  by ch_dpa_caseid case_start;

data case_sp;
set case_sp;
  by ch_dpa_caseid case_start;
  if last.case_start;
 
proc sort data=case_sp;
  by ch_dpa_caseid descending case_start ;

data case_sp;
set case_sp;
  by ch_dpa_caseid descending case_start ;
  
  retain last_start;
  if first.ch_dpa_caseid then do;
    case_end=.;
    last_start=case_start;
  end; 
  else do;
    case_end=last_start-1; 
    last_start=case_start;
  end; 

proc sort data=case_sp;
  by ch_dpa_caseid case_start case_end;

data case_sp (keep=ch_dpa_caseid case_start case_end);
set case_sp;
  by ch_dpa_caseid case_start case_end;
  if last.case_start;

  currupdate=&currupdt.;

  fixupdt update=currupdate pulldt=open_pull_date;
  
  if fs=1;
  if case_end=. then do;
    if last_pull_date^=. then case_end=intnx('month',last_pull_date,1,'same')-1;
    else case_end=intnx('month',open_pull_date,2,'same')-1;
  end;

data here.foodstamp_case_spells_cdbid;
set case_sp;


proc datasets lib=work nolist;
delete case_sp;
quit;



/***************************************************************************
  Now pull member data
***************************************************************************/;


PROC SQL;
CREATE TABLE INDIV AS 
  SELECT 
       A.ch_dpa_caseid,
       B.recptno,
       B.update_id      AS member_update_id,
       B.typebnft,
       B.mdclstat,
       B.fdspstat,
       B.last_update_id
  FROM oracli.ilpard_CaseAll A, oracli.ilpard_MemberStatus B
    WHERE A.ch_dpa_caseid=B.ch_dpa_caseid  and
          b.update_id<=&currupdt.

UNION ALL

  SELECT 
       A.ch_dpa_caseid,
       B.recptno,
       B.orig_update_id      AS member_update_id,
       B.typebnft,
       B.mdclstat,
       B.fdspstat,
       B.last_update_id
 FROM oracli.ilpard_CaseAll A, oracli.ilpard_MemberStatus_changes B
   WHERE A.ch_dpa_caseid=B.ch_dpa_caseid and 
          b.orig_update_id<=&currupdt.;

data indiv;
set indiv;
       if typebnft IN (' ','3','4','7','8','B','P','D',
                        'A','F','J','N','R','S') AND 
         (mdclstat='1' or fdspstat in ('1','2')) then fs=1;
       else fs=0;


/*******************************************************************************
  Add CHCDBID and calculate preliminary individual spells;
*******************************************************************************/;

proc sql;
create table indiv_sp as
select a.*,
       b.chcdbid 
from indiv a, xwalk.cdb_chcdbid_&msdate. b
where a.ch_dpa_caseid=b.ch_dpa_caseid and
      a.recptno=b.recptno;


data indiv_sp;
set indiv_sp;

  fixupdt update=member_update_id pulldt=pull_date;
  if last_update_id^=99999 then do;
    fixupdt update=last_update_id pulldt=last_pull_date;
  end;
  else last_pull_date=.;

proc sort;
  by chcdbid ch_dpa_caseid pull_date;

proc datasets lib=work nolist;
delete indiv;
quit;

data indiv_sp;
set indiv_sp;
  by chcdbid ch_dpa_caseid pull_date;
  
  retain indiv_start last_fs;
  if first.ch_dpa_caseid then do;
    indiv_start=pull_date;
    last_fs=fs;
  end;
  else do;
    if last_fs^=fs then do;
      indiv_start=pull_date;
    end;
    last_fs=fs;
  end;

proc sort data=indiv_sp;
  by chcdbid ch_dpa_caseid indiv_start;

data indiv_sp;
set indiv_sp;
  by chcdbid ch_dpa_caseid indiv_start;
  if last.indiv_start;
 
proc sort data=indiv_sp;
  by chcdbid ch_dpa_caseid descending indiv_start ;

data indiv_sp;
set indiv_sp;
  by chcdbid ch_dpa_caseid descending indiv_start ;
  
  retain last_start;
  if first.ch_dpa_caseid then do;
    indiv_end=.;
    last_start=indiv_start;
  end; 
  else do;
    indiv_end=last_start-1; 
    last_start=indiv_start;
  end; 

proc sort data=indiv_sp;
  by chcdbid ch_dpa_caseid indiv_start indiv_end;
  
data indiv_sp;
set indiv_sp;
  by chcdbid ch_dpa_caseid indiv_start indiv_end;
  if last.indiv_start;
  if fs=1;

  currupdate=&currupdt.;

  fixupdt update=currupdate pulldt=open_pull_date;
  if indiv_end=. then do;
    if last_pull_date^=. then indiv_end=intnx('month',last_pull_date,1,'same')-1;
    else indiv_end=intnx('month',open_pull_date,2,'same')-1;
  end;

/****************************************************************************
  Reconcile individual and case spells.
****************************************************************************/;

proc sql;
  create table all_sp as
  select a.chcdbid,
         a.recptno,
         a.ch_dpa_caseid,
         a.indiv_start,
         a.indiv_end,
         b.case_start,
         b.case_end
  from indiv_sp a, here.foodstamp_case_spells_cdbid b
  where a.ch_dpa_caseid=b.ch_dpa_caseid ;

proc sort nodupkey out=test;
  by chcdbid indiv_start case_start;
proc sort data=all_sp;
  by chcdbid indiv_start case_start;

proc datasets lib=work nolist;
delete indiv_sp;
quit;

data all_sp;
set all_sp;

  if case_end<indiv_start then delete;
  if case_start>indiv_end then delete;

  if case_start<=indiv_start then start_date=indiv_start;
  else start_date=case_start;
  if case_end>=indiv_end then end_date=indiv_end;
  else end_date=case_end;


proc sort;
  by chcdbid start_date ch_dpa_caseid;


data all_sp;
set all_sp;
  by chcdbid start_date ch_dpa_caseid;
  if last.start_date;

proc sort;
  by chcdbid start_date end_date;


/****************************************************************************
  Write indcase spells. 
****************************************************************************/;

data here.foodstamp_indcase_spells_cdbid (keep=chcdbid ch_dpa_caseid start_date end_date);
set all_sp;



/****************************************************************************
  Now create individual spells. 
****************************************************************************/;

***** First generate nogap spells where service interruptions >= 1 month  are treated as valid;

proc sort data=all_sp;
  by chcdbid start_date end_date;
 
data nogap;
set all_sp;
  by chcdbid start_date end_date;
  if last.start_date;

data nogap;
set nogap;
  by chcdbid start_date end_date;

  retain last_start last_end;
  
  if first.chcdbid then do;
    new_start=start_date;
    new_end=end_date;
    last_start=new_start;
    last_end=new_end;
  end;

  else do;
    ** Where adjacent spells do not overlap and gap is 1 month or greater;
    if start_date-last_end>1 then do;
      new_start=start_date;
      new_end=end_date;

      last_start=new_start;
      last_end=new_end;
    end;
    ** Where adjacent spells abut or overlap;
    if start_date-last_end<=1 then do;

      new_start=last_start;

      if end_date<last_end then new_end=last_end;
      else new_end=end_date;

      last_start=new_start;
      last_end=new_end;
    end;
  end;



proc sort data=nogap;
  by chcdbid new_start new_end;

data nogap;
set nogap;
  by chcdbid new_start new_end;
  if last.new_start;


data here.foodstamp_spells_nogap_cdbid (keep=chcdbid new_start new_end rename=(new_start=start_date new_end=end_date));
set nogap;


proc datasets lib=work nolist;
delete nogap all_sp;
quit;
***** Next generate standard spells where service interruptions >= 2 months  are treated as valid;

proc sort data=here.foodstamp_spells_nogap_cdbid out=gap (keep=chcdbid start_date end_date);
  by chcdbid start_date end_date; 

data gap;
set gap;
  by chcdbid start_date end_date;

  retain last_start last_end;
  
  if first.chcdbid then do;
    new_start=start_date;
    new_end=end_date;
    last_start=new_start;
    last_end=new_end;
  end;

  else do;
    ** Where adjacent spells do not overlap and gap is 2 months or greater;
    if start_date-last_end>45 then do;
      new_start=start_date;
      new_end=end_date;

      last_start=new_start;
      last_end=new_end;
    end;
    ** Where adjacent spells abut or overlap;
    else do;

      new_start=last_start;

      if end_date<last_end then new_end=last_end;
      else new_end=end_date;

      last_start=new_start;
      last_end=new_end;
    end;
  end;

proc sort data=gap;
  by chcdbid new_start new_end;

data gap;
set gap;
  by chcdbid new_start new_end;
  if last.new_start;


data here.foodstamp_spells_cdbid (keep=chcdbid new_start new_end rename=(new_start=start_date new_end=end_date));
set gap;



%mend;
%getspell;



