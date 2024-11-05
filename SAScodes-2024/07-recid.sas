/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-15
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/recid.csv';

proc import out = recid
   datafile = myfile
   dbms = csv replace;
run;

proc print data = recid; run;

/********************************************************************* 
 * model 1 
 *********************************************************************/

proc phreg data = recid;
   model week * arrest(0) = fin age race wexp mar paro prio employed;
   array emp(*) emp1-emp52;
   employed = emp[week];
run;

/********************************************************************* 
 * model 2 
 *********************************************************************/

proc phreg data = recid;
   where week > 1;
   model week * arrest(0) = fin age race wexp mar paro prio employed;
   array emp(*) emp1-emp52;
   employed = emp[week - 1];
run;

/********************************************************************* 
 * model 3 
 *********************************************************************/

proc phreg data = recid;
   where week > 2;
   model week * arrest(0) = fin age race wexp mar paro prio employ1 employ2;
   array emp(*) emp1-emp52;
   employ1 = emp[week - 1];
   employ2 = emp[week - 2];
run;

/********************************************************************* 
 * model 4 
 *********************************************************************/

data recidcum;
   set recid;
   array emp(*) emp1-emp52;
   array cum(*) cum1-cum52;
   cum1 = emp1;
   do i = 2 to 52;
      cum(i) = (cum(i-1) * (i-1) + emp(i)) / i;
   end;
run;

proc phreg data = recidcum;
   where week > 1;
   model week * arrest(0) = fin age race wexp mar paro prio employ;
   array cumemp(*) cum1-cum52;
   employ = cumemp[week - 1];
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
