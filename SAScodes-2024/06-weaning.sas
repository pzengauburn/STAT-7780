/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-09-20 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/bfeed.csv';

proc import out = weaning
   datafile = myfile
   dbms = csv replace;
run;

proc contents data = weaning; run;

proc freq data = weaning nlevels;
   tables delta agemth alcohol pc3mth poverty race smoke ybirth; 
run;

/********************************************************************* 
 * Cox proportional hazard regression 
 *********************************************************************/

proc phreg data = weaning;
   class race;
   model duration * delta(0) = agemth alcohol pc3mth poverty race smoke yschool;
run;

/********************************************************************* 
 * variable selection
 *********************************************************************/

proc phreg data = weaning;
   class race;
   model duration * delta(0) = agemth alcohol pc3mth poverty race smoke yschool
                 / selection = stepwise details;
run;

/********************************************************************* 
 * baseline hazard 
 *********************************************************************/

proc phreg data = weaning plots = survival;
   class race;
   model duration * delta(0) = race smoke;
   baseline out = wearning_surv survival = s lower = lcl upper = ucl;
run;

proc print data = wearning_surv; run;

/********************************************************************* 
 * THE END
 *********************************************************************/
