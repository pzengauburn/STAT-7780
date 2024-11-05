/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-14
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/larynx.csv';

proc import out = larynx 
   datafile = myfile
   dbms = csv replace;
run;

proc print data = larynx; run;

/********************************************************************* 
 * log-rank test and Wilcoxon test 
 *********************************************************************/

proc lifetest data = larynx;
   time time * delta(0);
   strata stage;
run;

/********************************************************************* 
 * test for trend 
 *********************************************************************/

proc lifetest data = larynx;
   time time * delta(0);
   strata stage / trend;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
