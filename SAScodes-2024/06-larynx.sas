/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-09-20 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/larynx.csv';

proc import out = larynx
   datafile = myfile
   dbms = csv replace;
run;

proc print data = larynx; run;

/********************************************************************* 
 * include only one covariate 
 *********************************************************************/

proc phreg data = larynx;
   class stage (ref = '1');
   model time * delta(0) = stage;
run;

proc phreg data = larynx;
   model time * delta(0) = diagyr;
run;

/********************************************************************* 
 * include both covariate 
 * demonstrate hypothesis testing 
 *********************************************************************/

proc phreg data = larynx;
   class stage (ref = '1');
   model time * delta(0) = stage diagyr / covb;
   contrast 'compare 4 stages' stage 1 0 0, stage 0 1 0, stage 0 0 1 / e estimate = both;
   contrast 'stage 2-3' stage  1 -1  0 / estimate = both;   
   contrast 'stage 2-4' stage  1  0 -1 / estimate = both;   
   contrast 'stage 3-4' stage  0  1 -1 / estimate = both;   
run;

/********************************************************************* 
 * multiple comparison, need to set param = glm
 *********************************************************************/

proc phreg data = larynx;
   class stage / param = glm;
   model time * delta(0) = stage diagyr;
   lsmeans stage / adjust = tukey; 
run;

/********************************************************************* 
 * include interaction 
 *********************************************************************/

proc phreg data = larynx;
   class stage (ref = '1');
   model time * delta(0) = stage diagyr stage * diagyr / covb;
   contrast 'stage 2 vs 1 at diagyr = 60' stage 1 0 0 stage * diagyr 60 0 0 / estimate = both;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
