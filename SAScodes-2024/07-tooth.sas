/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-15
 *********************************************************************/

filename mycsv url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/tooth.csv';

proc import out = tooth
   datafile = mycsv dbms = csv replace;
run;

/** for sex: 0 = male, 1 = female **/
proc icphreg data = tooth;
   class sex;
   model (left, right) = sex dmf;
   hazardratio sex;
run;

proc icphreg data = tooth;
   class sex;
   model (left, right) = sex dmf / base = unspecified;
   hazardratio sex;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
