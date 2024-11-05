/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/PBC.csv';

proc import out = pbc
   datafile = myfile
   dbms = csv replace;
run;

proc print data = pbc; run;

proc phreg data = pbc;
   class edema;
   model time * status (0, 1) = bili logalb logprotime edema age_year;
   logalb = log(albumin);
   logprotime = log(protime);
   age_year = age / 365.25;
   assess var = (bili) / resample;
run;

proc phreg data = pbc;
   class edema;
   model time * status (0, 1) = logbili logalb logprotime edema age_year;
   logalb = log(albumin);
   logprotime = log(protime);
   logbili = log(bili);
   age_year = age / 365.25;
   assess var = (logbili) / resample;
run;

proc phreg data = pbc;
   class edema;
   model time * status (0, 1) = logbili logalb logprotime edema age_year;
   logalb = log(albumin);
   logprotime = log(protime);
   logbili = log(bili);
   age_year = age / 365.25;
   assess ph / resample;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
