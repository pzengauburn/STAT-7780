/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/hodg.csv';

proc import out = hodg
   datafile  = myfile 
   dbms = csv replace;
run;

proc print data = hodg; run;

/********************************************************************* 
 * martingale residuals
 *********************************************************************/

proc phreg data = hodg;
   class gtype dtype;
   model time * delta(0) = dtype gtype dtype * gtype score;
   output out = hodg_fitted resmart = mgale;
run;

proc print data = hodg_fitted; run;

proc sgplot data = hodg_fitted; 
   loess x = wtime y = mgale;
run;

/********************************************************************* 
 * deviance residuals
 *********************************************************************/

proc phreg data = hodg;
   class gtype dtype;
   model time * delta(0) = dtype gtype dtype * gtype score wtime;
   output out = hodg_fitted2 resmart = mgale resdev = resdev xbeta = risk;
run;

proc sgplot data = hodg_fitted2; 
   scatter x = risk y = mgale;
run;

proc sgplot data = hodg_fitted2; 
   scatter x = risk y = resdev;
run;

/********************************************************************* 
 * scrore residuals
 *********************************************************************/

proc phreg data = hodg;
   class gtype dtype;
   model time * delta(0) = dtype gtype dtype * gtype score wtime;
   output out = hodg_fitted3 ressco = rs_dtype rs_gtype rs_dXg rs_score rs_wtime;
run;

proc print data = hodg_fitted3; run;

data hodg_fitted3;
   set hodg_fitted3;
   id = _n_;
run;

proc sgplot data = hodg_fitted3;
   scatter x = id y = rs_dtype; 
   refline 0;
run;

proc sgplot data = hodg_fitted3;
   scatter x = id y = rs_gtype; 
   refline 0;
run;

proc sgplot data = hodg_fitted3;
   scatter x = id y = rs_dXg; 
   refline 0;
run;

proc sgplot data = hodg_fitted3;
   scatter x = id y = rs_score; 
   refline 0;
run;

proc sgplot data = hodg_fitted3;
   scatter x = id y = rs_wtime; 
   refline 0;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
