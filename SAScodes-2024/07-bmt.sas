/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-15
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/bmt.csv';

proc import out = bmt
   datafile = myfile
   dbms = csv replace;
run;

proc print data = bmt; run;

/********************************************************************* 
 * group and aGVHD
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = za group;
   if(t2 >= ta and da = 1) then za = 1; else za = 0;
run;

/********************************************************************* 
 * group and cGVHD
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = zc group;
   if(t2 >= tc and dc = 1) then zc = 1; else zc = 0;
run;

/********************************************************************* 
 * group and platelet recovery
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = zp group;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
run;

/********************************************************************* 
 * model 1: fixed covariates only
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model 2: group and platelet recovery 
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group zp;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
run;

/********************************************************************* 
 * model 3: fixed covariates and platelet recovery 
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model 4: all covariates and interactions
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp group * zp z8 * zp z11 * zp z22 * zp z11 * z22 * zp;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model 5: stepwise selection 
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp group * zp z8 * zp z11 * zp z22 * zp z11 * z22 * zp / selection = stepwise;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/*** final 1 ***/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 zp group * zp z8 * zp;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model 6: backward selection 
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp group * zp z8 * zp z11 * zp z22 * zp z11 * z22 * zp / selection = backward;
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/*** final 2 ***/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp group * zp z8 * zp z11 * zp z22 * zp; 
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * check proportional hazards assumption
 *********************************************************************/

proc phreg data = bmt;
   model t2 * d3(0) = z10 z10t;
   z10t = log(t2) * z10;
run;

/********************************************************************* 
 * model with no stratification
 *********************************************************************/

proc phreg data = bmt;
   class  group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp; 
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model with stratification
 *********************************************************************/

proc phreg data = bmt;
   class  group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp; 
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   strata z10;
   z11 = z1 - 28;
   z22 = z2 - 28;
run;

/********************************************************************* 
 * model with z10 = 1
 *********************************************************************/

proc phreg data = bmt;
   class  group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp; 
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
   where z10 = 1;
run;

/********************************************************************* 
 * model with z10 = 0
 *********************************************************************/

proc phreg data = bmt;
   class  group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 zp; 
   if(t2 >= tp and dp = 1) then zp = 1; else zp = 0;
   z11 = z1 - 28;
   z22 = z2 - 28;
   where z10 = 0;
run;

/********************************************************************* 
 * left truncation
 *********************************************************************/

proc phreg data = bmt;
   class group (ref = '1');
   model t2 * d3(0) = group z8 z11 z22 z11 * z22 / entry = tp;
   z11 = z1 - 28;
   z22 = z2 - 28;
   strata z10;
run;

proc phreg data = bmt;
   class group (ref = '1');
   model (tp, t2) * d3(0) = group z8 z11 z22 z11 * z22;
   z11 = z1 - 28;
   z22 = z2 - 28;
   strata z10;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
