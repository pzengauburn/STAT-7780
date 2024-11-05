/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/rats.csv';

proc import out = rats
   datafile = myfile
   dbms = csv replace;
run;

proc print data = rats; run;

proc freq data = rats;
   tables litter trt;
run;

/********************************************************************* 
 * consider correlation
 *********************************************************************/

proc phreg data = rats;
   class litter;
   model time * tumor(0) = trt;
   random litter / dist = gamma;
run;

/********************************************************************* 
 * assume independence
 *********************************************************************/

proc phreg data = rats;
   model time * tumor(0) = trt;
run;

/********************************************************************* 
 * sandwich estimate 
 *********************************************************************/

proc phreg data = rats covsandwich;
   class litter;
   model time * tumor(0) = trt;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/