/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-08
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/kidney.csv';

proc import out = kidney
   datafile = myfile
   dbms = csv replace;
run;

proc print data = kidney; run;

proc lifetest data = kidney;
   time time * delta(0);
   strata type;
run;

proc lifetest data = kidney plots = survival(CL CB strata = panel);
   time time * delta(0);
   strata type;
run; 

/********************************************************************* 
 * THE END
 *********************************************************************/
