/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-31
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/bfeed.csv';

proc import out = weaning
   datafile = myfile
   dbms = csv replace;
run;

proc lifetest method = lt 
       intervals = (2 3 5 7 11 17 25 37 53)
       plots = (s ls, lls, h, p);
   time duration * delta(0); 
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
