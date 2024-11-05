/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-09-20 
 *********************************************************************/

filename myfile url "http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/btrial.csv";

proc import out = breast
   datafile = myfile
   dbms = csv replace;
run;

proc print data = breast; run;

proc freq data = breast; 
   tables im; 
run;

/********************************************************************* 
 * Cox proportional hazard regression 
 *********************************************************************/

proc phreg data = breast;
   class im;
   model time * death(0) = im;
   hazardratio im; 
run;

/********************************************************************* 
 * different coding for categorical variable 
 *********************************************************************/

proc phreg data = breast;
   class im / param = effect;
   model time * death(0) = im;
   hazardratio im; 
run;

proc phreg data = breast;
   class im (ref = '1');
   model time * death(0) = im;
   hazardratio im; 
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
