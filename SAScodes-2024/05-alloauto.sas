/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-27
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/alloauto.csv';

proc import out = alloauto
   datafile = myfile
   dbms = csv replace;
run;

proc print data = alloauto; run;

/********************************************************************* 
 * Weibull distribution
 *********************************************************************/

proc sort data = alloauto; by type;
proc lifereg data = alloauto;
   model time * delta(0) =  / covb;
   by type;
run;

/********************************************************************* 
 * exponential distribution
 *********************************************************************/

proc lifereg data = alloauto;
   model time * delta(0) =  / covb distribution = exponential;
   by type;
run;

/********************************************************************* 
 * log-logistic distribution
 *********************************************************************/

proc lifereg data = alloauto;
   model time * delta(0) =  / covb distribution = llogistic;
   by type;
run;

/********************************************************************* 
 * log-normal distribution
 *********************************************************************/

proc lifereg data = alloauto;
   model time * delta(0) =  / covb distribution = lnormal;
   by type;
run;

/********************************************************************* 
 * gamma distribution
 *********************************************************************/

proc lifereg data = alloauto;
   model time * delta(0) =  / covb distribution = gamma;
   by type;
run;

/********************************************************************* 
 * Log normal distribution with covariates 
 *********************************************************************/

proc lifereg data = alloauto;
   class type;
   model time * delta(0) = type / covb distribution = lnormal; 
run;

/********************************************************************* 
 * model diagnostics
 *********************************************************************/

proc phreg data = alloauto;
   model time * delta(0) = ;
   by type;
   output out = fitted survival = surv;
run;

data fitted_update;
   set fitted;
   haz = -log(surv);
   loghaz = log(haz);
   lnhaz = probit(1 - exp(-haz));
   lohaz = log(exp(haz) - 1);
   logtime = log(time);
run;

proc sort data = fitted_update; by time;

proc sgplot data = fitted_update;
   series x = time y = haz / group = type;
   title 'Exponential Hazard Plot';
   xaxis label = 'Time';
   yaxis label = 'Estimated Cumulative Hazard Rates';
run;

proc sgplot data = fitted_update;
   series x = logtime y = loghaz / group = type;
   title 'Weibull Hazard Plot';
   xaxis label = 'Log Time';
   yaxis label = 'Log Estimated Cumulative Hazard Rates';
run;

proc sgplot data = fitted_update;
   reg x = logtime y = lohaz / group = type;
   title 'Log Logistic Hazard Plot';
   xaxis label = 'Log Time';
   yaxis label = 'Log(exp(H) - 1)';
run;

proc sgplot data = fitted_update;
   reg x = logtime y = lnhaz / group = type;
   title 'Log Normal Hazard Plot';
   xaxis label = 'Log Time';
   yaxis label = 'Probit(1 - exp(-H))';
run;

/********************************************************************* 
 * model diagnostics: probplot 
 *********************************************************************/

proc lifereg data = alloauto;
   model time * delta(0) = type / distribution = weibull;
   probplot;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
