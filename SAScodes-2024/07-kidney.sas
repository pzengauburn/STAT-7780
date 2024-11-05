/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-15
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/kidney.csv';

proc import out = kidney
   datafile = myfile
   dbms = csv replace;
run;

proc print data = kidney; run;

/********************************************************************* 
 * test proportional hazards assumption 
 *********************************************************************/

proc lifetest data = kidney plot = S (CL);
   time time * delta(0);
   strata type;
run;

/********************************************************************* 
 * test proportional hazards assumption 
 *********************************************************************/

proc phreg data = kidney;   
   model time * delta(0) = z1 z2;
   z1 = type - 1;
   z2 = log(time) * z1;
run;

/********************************************************************* 
 * choose tau: find all possible candidates of tau 
 *********************************************************************/

proc freq data = kidney;
   tables time;
   where delta = 1;
run;

/********************************************************************* 
 * choose tau: how to fit the model when tau = 1.5 
 *********************************************************************/

proc phreg data = kidney;   
   model time * delta(0) = z1 z2;
   z1 = type - 1;
   if time > 1.5 then z2 = z1; else z2 = 0;
run;

/********************************************************************* 
 * choose tau: how to fit the model when tau = 3.5
 *********************************************************************/

proc phreg data = kidney;   
   model time * delta(0) = z1 z2;
   z1 = type - 1;
   if time > 3.5 then z2 = z1; else z2 = 0;
   test z1 + z2;
run;

/********************************************************************* 
 * repeat the above process for different tau
 *********************************************************************/

proc sql;
   create table kidney_new as
   select a.*, b.tau 
   from kidney as a, 
        (select distinct time as tau from kidney where delta = 1) as b
   order by tau;
quit;

proc phreg data = kidney_new outest = kidney_fitted;
   model time * delta(0) = z1 z2;
   by tau;
   z1 = type - 1;
   if time > tau then z2 = z1; else z2 = 0;
run;

proc print data = kidney_fitted; run;

/********************************************************************* 
 * THE END
 *********************************************************************/
