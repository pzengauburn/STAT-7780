/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-07
 *********************************************************************/

data drug6mp;
   input survtime status;
datalines;
 10    1 
  7    1 
 32    0 
 23    1 
 22    1 
  6    1 
 16    1 
 34    0 
 32    0 
 25    0 
 11    0 
 20    0 
 19    0 
  6    1 
 17    0 
 35    0 
  6    1 
 13    1 
  9    0 
  6    0 
 10    0 
;
proc print data = drug6mp; run;

/********************************************************************* 
 * Kaplan-Meier estimator for survival function 
 *********************************************************************/

proc lifetest data = drug6mp;
   time survtime * status(0);
run;

/********************************************************************* 
 * Kaplan-Meier estimator with more options 
 *********************************************************************/

proc lifetest data = drug6mp plots = S(CL CB = EP) 
   outsurv = drug6mp_fitted stderr conftype = linear confband = ep alpha = 0.05;
   time survtime * status(0);
run;

proc print data = drug6mp_fitted; run;

/********************************************************************* 
 * Nelson-Aalan estimator for cumulative hazard function 
 *********************************************************************/

proc lifetest data = drug6mp nelson;
   time survtime * status(0);
   ods output ProductLimitEstimates = KMestimate;
run;

proc print data = KMestimate; run;

proc sgplot data = KMestimate;
   step x = survtime y = CumHaz;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
