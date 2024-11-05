/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-09-20 
 *********************************************************************/

filename myfile url 'http://www.auburn.edu/~zengpen/teaching/STAT-7780/datasets/VAlung.csv';

proc import out = VAlung
    datafile = myfile dbms = csv replace; 
run;

proc print data = VAlung; run;

/********************************************************************* 
 * option diff = ref requests comparisons between the reference level 
 * and all other levels of the CLASS variable
 *********************************************************************/

proc phreg data = VALung;
   class Prior (ref = 'no') Cell (ref = 'large') Therapy (ref = 'standard');
   model Time * Status(0) = Kps Cell Prior | Therapy / covb;
   hazardratio 'H1' Kps / units = 10;
   hazardratio 'H2' Cell / diff = ref;
   hazardratio 'H3' Therapy;
run;

/********************************************************************* 
 * contrast
 *********************************************************************/

proc phreg data = VALung;
   class Prior (ref = 'no') Cell (ref = 'large') Therapy (ref = 'standard');
   model Time * Status(0) = Kps Cell Prior | Therapy / covb;
   hazardratio 'H1' Kps / units = 10;
   hazardratio 'H2' Cell;
   hazardratio 'H3' Therapy / diff = ref;
   contrast 'C1' Kps 10 / estimate = exp;
   contrast 'C2' cell 1  0  0, /* adeno vs large    */
                 cell 1 -1  0, /* adeno vs small    */
                 cell 1  0 -1, /* adeno vs squamous */
                 cell 0 -1  0, /* large vs small    */
                 cell 0  0 -1, /* large vs Squamous */
                 cell 0  1 -1  /* small vs squamous */
                  / estimate = exp;
   contrast 'C3' Prior 0 Therapy 1  Prior*Therapy 0,
                 Prior 0 Therapy 1  Prior*Therapy 1  / estimate = exp;
run;

/********************************************************************* 
 * variable selection
 *********************************************************************/

proc phreg data = VALung;
   class Prior (ref = 'no') Cell (ref = 'large') Therapy (ref = 'standard');
   model Time * Status(0) = Kps Duration Age Cell Prior | Therapy
            / selection = backward slstay = 0.1;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
