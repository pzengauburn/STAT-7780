/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/jobmult.csv';

proc import out = jobs
   datafile = myfile
   dbms = csv replace;
run;

proc print data = jobs; run;

/********************************************************************* 
 * analysis by seq 
 *********************************************************************/

proc sort data = jobs; by seq;
proc phreg data = jobs;
   model duration * event(0) = prestige logsal ed;
   by seq;
run;

/********************************************************************* 
 * treat each event as distinct observation
 *********************************************************************/

proc phreg data = jobs;
   model duration * event(0) = prestige logsal ed;
run;

/********************************************************************* 
 * detect dependence 
 *********************************************************************/

proc sort data = jobs; by id seq;
data joblag;
   set jobs;
   durlag = lag(duration);
run;

proc print data = joblag; run;

proc phreg data = joblag;
   where seq = 2;
   model duration * event(0) = prestige logsal ed durlag;
run;

/********************************************************************* 
 * robust standard errors
 *********************************************************************/

proc phreg data = jobs covsandwich(aggregate);
   model duration * event(0) = prestige logsal ed seq;
   id id;
run;

/********************************************************************* 
 * correction for coefficients
 *********************************************************************/

data jobs_new;
   set jobs;
   array p(*) p1-p10;
   array s(*) s1-s10;
   array e(*) e1-e10;
   do i = 1 to 10;
      p(i) = prestige * (seq = i);
	  s(i) = logsal * (seq = i);
	  e(i) = ed * (seq = i);
	end;
run;

proc phreg data = jobs_new covsandwich(aggregate);
   model duration * event(0) = p1-p10 s1-s10 e1-e10 seq;
   id id;
   prestige:  test p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 / average;
   salary:    test s1,s2,s3,s4,s5,s6,s7,s8,s9,s10 / average;
   education: test e1,e2,e3,e4,e5,e6,e7,e8,e9,e10 / average;
run;

/********************************************************************* 
 * random-effect model
 *********************************************************************/

proc phreg data = jobs; 
   class id;
   model duration * event(0) = prestige logsal ed seq;
   random id;
run;

/********************************************************************* 
 * fixed-effect model
 *********************************************************************/

proc phreg data = jobs; 
   class id;
   model duration * event(0) = prestige logsal ed seq;
   strata id;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
