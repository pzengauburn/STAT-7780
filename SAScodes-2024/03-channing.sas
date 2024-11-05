/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-08
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/channing.csv';

proc import out = channing
   datafile = myfile
   dbms = csv replace;
run;

proc print data = channing; run;

/********************************************************************* 
 * conditional on survival to age 68
 *********************************************************************/

proc sort data = channing; by gender;

proc phreg data = channing (where = (age > 68 * 12));
   model age * death(0) = / entry = ageentry;
   by gender;
   output out = channing_fitted68 survival = S;
run;

proc sort data = channing_fitted68; by gender age; 
proc print data = channing_fitted68; run;

proc sgplot data = channing_fitted68;
   step x = age y = S / group = gender;
run;

/********************************************************************* 
 * conditional on survival to age 80
 *********************************************************************/

proc phreg data = channing (where = (age > 80 * 12));
   model age * death(0) = / entry = ageentry;
   by gender;
   output out = channing_fitted80 survival = S;
run;

proc sort data = channing_fitted80; by gender age; 
proc print data = channing_fitted80; run;

proc sgplot data = channing_fitted80;
   step x = age y = S / group = gender;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
