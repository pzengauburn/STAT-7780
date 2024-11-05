/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-27
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/larynx.csv';

proc import out = larynx
   datafile = myfile
   dbms = csv replace;
run;

proc print data = larynx; run;

/********************************************************************* 
 * Weibull distribution
 *********************************************************************/

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age / covb;
   estimate "VI-I"  stage -1 0 0 1; 
   estimate "III-I" stage -1 0 1 0; 
run;

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = age;
run;

/********************************************************************* 
 * Log Logistic distribution
 *********************************************************************/
 
proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age / distribution = llogistic;
run;

/********************************************************************* 
 * exponential distribution
 *********************************************************************/

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age / distribution = exponential;
run;

/********************************************************************* 
 * Log normal distribution
 *********************************************************************/

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age / distribution = lnormal;
run;

/********************************************************************* 
 * gamma distribution
 *********************************************************************/
 
proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age / distribution = gamma;
run;

/********************************************************************* 
 * diagnostics
 *********************************************************************/

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age; 
   output out = fitted cres = CoxSnell; 
run;

proc phreg data = fitted;
   model CoxSnell * delta(0) = ;
   output out = fitted2 survival = surv;
run;

data fitted2;
   set fitted2;
   haz = -log(surv);
run;

proc sort data = fitted2; by CoxSnell;
proc sgplot data = fitted2 noautolegend;
   step x = CoxSnell y = haz;
   series x = CoxSnell y = CoxSnell;
run;

/********************************************************************* 
 * diagnostics: probplot 
 *********************************************************************/

proc lifereg data = larynx;
   class stage; 
   model time * delta(0) = stage age; 
   probplot;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
