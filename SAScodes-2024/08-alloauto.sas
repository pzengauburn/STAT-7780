/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/alloauto.csv';

proc import out = alloauto
   datafile  = myfile
   dbms = csv replace;
run;

proc print data = alloauto; run;

/********************************************************************* 
 * fit a Cox PH model stratified by type 
 *********************************************************************/

proc phreg data = alloauto;   
   model time * delta(0) = ;
   strata type;
   output out = alloauto_fitted logsurv = ls;
run;

/********************************************************************* 
 * first plot: log(H) against t 
 *********************************************************************/

data alloauto_fitted;
   set alloauto_fitted;
   loghaz = log(-ls);
run;

proc print data = alloauto_fitted; run;

proc sgplot data = alloauto_fitted;
   step x = time y = loghaz / group = type; 
run;

/********************************************************************* 
 * second plot: log(H1) - log(H2) against t 
 *********************************************************************/

data alloauto_fitted2;
   set alloauto_fitted;
   if type = 1 then loghaz1 = loghaz;
   if type = 2 then loghaz2 = loghaz;
run;

proc sort data = alloauto_fitted2; by time;

proc print data = alloauto_fitted2; run;

data alloauto_fitted3;
   set alloauto_fitted2;
   retain a1 a2 -4;
   if not missing(loghaz1) then a1 = loghaz1;
   if not missing(loghaz2) then a2 = loghaz2;
   hazdiff = a2 - a1;
proc print data = alloauto_fitted3; run;

proc sgplot data = alloauto_fitted3; 
   series x = time y = hazdiff;
   refline 0 / lineattrs = (color = red pattern = dot);
run;

/********************************************************************* 
 * third plot: H1 against H2 
 *********************************************************************/

data alloauto_fitted4;
   set alloauto_fitted2;
   retain a1 a2 0;
   if not missing(loghaz1) then a1 = exp(loghaz1);
   if not missing(loghaz2) then a2 = exp(loghaz2);
   label a1 = 'allo' a2 = 'auto';
proc print data = alloauto_fitted4; run;

proc sgplot data = alloauto_fitted4 noautolegend; 
   step x = a1 y = a2;
   series x = a1 y = a1 / lineattrs = (color = red pattern = dot);
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
