/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/bmt.csv';

proc import out = bone
   datafile = myfile 
   dbms = csv replace;
run;

proc print data = bone; run;

/**********************************************************************
 * Cox-Snell residuals
 **********************************************************************/

/***** output Cox-Snell residuals *****/

proc phreg data = bone;
   class group;
   model t2 * d3(0) = group z11 z22 z11 * z22 z77 z8 z10;
   z11 = z1 - 28;
   z22 = z2 - 28;
   z77 = z7 / 30 - 9;
   output out = bone_fitted logsurv = logsurv;
run;

/***** Cox-Snell residual is -logsurv *****/

data bone_fitted;
   set bone_fitted;
   CoxSnell = -logsurv;   
   label CoxSnell = 'Cox-Snell Residual';
run;

/***** Calculate Nelson-Aalen estimate *****/

proc phreg data = bone_fitted;
   model CoxSnell * d3(0) = ;   
   output out = bone_fitted2 logsurv = logsurv2;
run;

data bone_fitted2;
   set bone_fitted2;
   haz = -logsurv2;
   label haz = 'Estimated Cumulative Hazard Rate';
run;

proc sort data = bone_fitted2; by CoxSnell;

proc sgplot data = bone_fitted2 noautolegend;
   step x = CoxSnell y = haz;   
   series x = CoxSnell y = CoxSnell / lineattrs = (color = green pattern = dot);    
run;

/***** generate plot directly using lifetest *****/

proc lifetest data = bone_fitted notable plots = ls; 
   time CoxSnell * d3(0); 
run;

/**********************************************************************
 * Cox-Snell residuals: explore Z10 
 **********************************************************************/

proc sort data = bone_fitted; by z10;

proc phreg data = bone_fitted;
   model CoxSnell * d3(0) = ;   
   output out = bone_fitted3 logsurv = logsurv3 / method = ch;
   by z10;
run;

data bone_fitted3;
   set bone_fitted3;
   haz = -logsurv3;
   label haz = 'Estimated Cumulative Hazard Rate';
run;

proc sort data = bone_fitted3; by CoxSnell;

proc sgplot data = bone_fitted3;
   step x = CoxSnell y = haz / group = z10;   
   series x = CoxSnell y = CoxSnell / lineattrs = (color = green pattern = dot); 
   xaxis label = 'Cox-Snell Residuals';
   yaxis label = 'Estimated Cumulative Hazard Rates';
run;

/***** generate plot directly using lifetest *****/

proc lifetest data = bone_fitted notable plots = ls; 
   time CoxSnell * d3(0); 
   strata z10; 
run;

/**********************************************************************
 * Cox-Snell residuals: stratified by Z10 
 **********************************************************************/

/***** Cox-Snell residuals: stratified *****/

proc phreg data = bone;
   class group;
   model t2 * d3(0) = group z11 z22 z11 * z22 z77 z8;
   z11 = z1 - 28;
   z22 = z2 - 28;
   z77 = z7 / 30 - 9;
   strata z10;
   output out = bone_stratified logsurv = logsurv;
run;

data bone_stratified;
   set bone_stratified;
   CoxSnell = -logsurv;   
   label CoxSnell = 'Cox-Snell Residual';
run;

proc sort data = bone_stratified; by z10;

proc phreg data = bone_stratified;
   model CoxSnell * d3(0) = ;   
   output out = bone_stratified2 logsurv = logsurv2 / method = ch;
   by z10;
run;

data bone_stratified2;
   set bone_stratified2;
   haz = -logsurv2;
   label haz = 'Estimated Cumulative Hazard Rate';
run;

proc sort data = bone_stratified2; by CoxSnell;

proc sgplot data = bone_stratified2;
   step x = CoxSnell y = haz / group = z10;   
   series x = CoxSnell y = CoxSnell / lineattrs = (color = green pattern = dot); 
   xaxis label = 'Cox-Snell Residual';
   yaxis label = 'Estimated Cumulative Hazard Rate';
run;

/***** generate plot directly using lifetest *****/

proc lifetest data = bone_stratified notable plots = ls; 
   time CoxSnell * d3(0); 
   strata z10; 
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
