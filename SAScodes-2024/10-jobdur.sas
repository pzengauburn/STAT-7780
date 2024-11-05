/********************************************************************* 
 * STAT 7030 - Categorical Data Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/jobdur.csv';

proc import out = jobdur
   datafile = myfile
   dbms = csv replace;
run;

proc print data = jobdur; run;

proc freq data = jobdur; 
   table dur * event; 
run;

/********************************************************************* 
 *  using different approaches for handling ties
 *********************************************************************/

proc phreg data = jobdur; 
   model dur * event(0, 2) = ed prestige salary / ties = breslow;
run;

proc phreg data = jobdur; 
   model dur * event(0, 2) = ed prestige salary / ties = efron;
run;

proc phreg data = jobdur; 
   model dur * event(0, 2) = ed prestige salary / ties = exact;
run;

proc phreg data = jobdur; 
   model dur * event(0, 2) = ed prestige salary / ties = discrete;
run;

/********************************************************************* 
 *  fit a logit model
 *********************************************************************/

data jobyrs;
   set jobdur;
   do year = 1 TO dur;
      if year = dur AND event = 1 then quit = 1;
      else quit = 0;
      output;
   end;
run;

proc logistic data = jobyrs; 
   class year / param = glm; 
   model quit (event = '1') = ed prestige salary year; 
run;

proc logistic data = jobyrs; 
   model quit (event = '1') = ed prestige salary year; 
run;

proc logistic data = jobyrs; 
   model quit (event = '1') = ed prestige salary year year * year; 
run;

data jobyrslog; 
   set jobyrs; 
   logyear = log(year); 
run;

proc logistic data = jobyrslog; 
   model quit (event = '1') = ed prestige salary logyear; 
run;

/********************************************************************* 
 * use cloglog link
 *********************************************************************/

proc logistic data = jobyrs; 
   class year / param = glm; 
   model quit (event = '1') = ed prestige salary year / link = cloglog; 
run;

proc logistic data = jobyrs; 
   model quit (event = '1') = ed prestige salary year / link = cloglog; 
run;

proc logistic data = jobyrs; 
   model quit (event = '1') = ed prestige salary year year * year / link = cloglog; 
run;

proc logistic data = jobyrslog; 
   model quit (event = '1') = ed prestige salary logyear / link = cloglog; 
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
