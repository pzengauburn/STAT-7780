/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/leaders.csv';

proc import out = leaders
   datafile = myfile 
   dbms = csv replace;
run;

proc print data = leaders; run;

/********************************************************************* 
 * Are the type-specific hazard funcions the same for all event types? 
 *********************************************************************/

proc freq data = leaders;
   tables lost / testp = (0.3333, 0.3333, 0.3333);
   where lost > 0; 
run;

/********************************************************************* 
 * Are the type-specific hazard funcions proportional to each other? 
 *********************************************************************/

data const;
   set leaders;
   event = (lost = 1);
   type = 1;
data nat;
   set leaders;
   event = (lost = 2);
   type = 2;
data noncon;
   set leaders;
   event = (lost = 3);
   type = 3;
data combine;
   set const nat noncon;
run;

/**** log-log survival ****/
proc lifetest data = combine plots = lls;
   time years * event (0);
   strata type;
run;

/**** smoothed hazard ****/
proc lifetest data = combine plots = H (bw = 10);
   time years * event (0);
   strata type;
run;

/********************************************************************* 
 * test the homogeneity of the hazards by logit model. 
 *********************************************************************/

proc logistic data = leaders;
   model lost = years / link = glogit;
   where lost > 0;
run;

/********************************************************************* 
 * fit Cox PH models separately  
 *********************************************************************/

proc phreg data = leaders;
   model years * lost(0,1,2) = manner start military age conflict
         loginc growth pop land literacy;  
   strata region;
run;

proc phreg data = leaders;
   model years * lost(0,1,3) = manner start military age conflict
         loginc growth pop land literacy;  
   strata region;
run;

proc phreg data = leaders;
   model years * lost(0,2,3) = manner start military age conflict
         loginc growth pop land literacy;  
   strata region;
run;

/********************************************************************* 
 * fit Cox PH models stratified by type (event 1 and 3 only)
 *********************************************************************/

proc phreg data = combine;
   model years * event(0) = manner start military age conflict
         loginc growth pop land literacy;  
   strata region type;
   where type NE 2;
run;

/********************************************************************* 
 * accelerated failure time: nonconstitutional exist 
 *********************************************************************/

data leaders2noncon;
   set leaders;
   lower = years;
   upper = years;
   if years = 0 then do;
      lower = .;
      upper = 1;
   end;
   if lost in (0,1,2) then upper = .;
run;
 
proc lifereg data = leaders2noncon;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = exponential;
run;

proc lifereg data = leaders2noncon;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = weibull;
run;

proc lifereg data = leaders2noncon;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = lnormal;
run;

proc lifereg data = leaders2noncon;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = gamma;
run;

proc lifereg data = leaders2noncon;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = llogistic;
run;

/********************************************************************* 
 * accelerated failure time: constitutional exist 
 *********************************************************************/

data leaders2con;
   set leaders;
   lower = years;
   upper = years;
   if years = 0 then do;
      lower = .;
      upper = 1;
   end;
   if lost in (0,2,3) then upper = .;
run;
 
proc lifereg data = leaders2con;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = exponential;
run;

proc lifereg data = leaders2con;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = weibull;
run;

proc lifereg data = leaders2con;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = lnormal;
run;

proc lifereg data = leaders2con;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = gamma;
run;

proc lifereg data = leaders2con;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = llogistic;
run;

/********************************************************************* 
 * accelerated failure time: natural death 
 *********************************************************************/

data leaders2nat;
   set leaders;
   lower = years;
   upper = years;
   if years = 0 then do;
      lower = .;
      upper = 1;
   end;
   if lost in (0,1,3) then upper = .;
run;
 
proc lifereg data = leaders2nat;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = exponential;
run;

proc lifereg data = leaders2nat;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = weibull;
run;

proc lifereg data = leaders2nat;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = lnormal;
run;

proc lifereg data = leaders2nat;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = gamma;
run;

proc lifereg data = leaders2nat;
   class region;
   model (lower, upper) = manner start military age conflict
          loginc literacy region / d = llogistic;
run;

/********************************************************************* 
 * test of equality of covariates
 *********************************************************************/

data leaders3;
   set leaders;
   lyears = log(years + 0.5);
run;

proc logistic data = leaders3;
   where lost = 1 or lost = 3;
   class lost region;
   model lost = lyears manner age start military conflict loginc
         literacy region;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
