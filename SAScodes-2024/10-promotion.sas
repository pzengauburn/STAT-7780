/********************************************************************* 
 * STAT 7030 - Categorical Data Analysis 
 * Peng Zeng (Auburn University)
 * 2024-10-24
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/rank.csv';

proc import out = rank
   datafile = myfile
   dbms = csv replace;
run;

data rankyrs; 
   set rank; 
   array arts(*) art1-art10; 
   array cits(*) cit1-cit10; 
   if jobtime = . then jobtime = 11; 
   do year = 1 to dur;
      if year = dur then promo = event; else promo = 0;
      if year >= jobtime then prestige = prest2; else prestige = prest1; 
      articles = arts(year); 
      citation = cits(year); 
      output; 
   end; 
run;

proc logistic data = rankyrs; 
   model promo (event = '1') = undgrad phdmed phdprest articles citation
        prestige year year * year; 
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
