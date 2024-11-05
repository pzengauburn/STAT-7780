/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-27
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/recid.csv';

proc import out = recid
   datafile = myfile
   dbms = csv replace;
run;

proc print data = recid; run;

/********************************************************************* 
 * summary 
 *********************************************************************/

proc freq data = recid;
   tables week arrest;    
run;

/********************************************************************* 
 * right censoring
 *********************************************************************/

proc lifereg data = recid;
   model week * arrest(0) = fin age race wexp mar paro prio;
   probplot;
run;

/********************************************************************* 
 * interval censoring
 *********************************************************************/

data recidint;
   set recid;

       /* interval-censored cases: */
   if arrest = 1 then do;
      upper = week;
      lower = week - 0.9999;
   end; /** avoid 0 for those with week = 1 **/

      /* right-censored cases: */
   if arrest = 0 then do;
      upper = .;
      lower = 52;
   end;
run;

proc lifereg data = recidint;
   model (lower, upper) = fin age race wexp mar paro prio;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
