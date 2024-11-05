/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-15
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/drug6mp.csv';

proc import out = drug6mp
   datafile = myfile
   dbms = csv replace;
run;

proc print data = drug6mp; run;

data drug6mp_update;
   set drug6mp;
   time = t1; delta = 1; treatment = 'placebo'; output;
   time = t2; delta = relapse; treatment = '6mp'; output;
   drop t1 t2 relapse;
run;

proc print data = drug6mp_update; run;

proc phreg data = drug6mp_update;
   class treatment; 
   model time * delta(0) = treatment;
   strata pair;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
