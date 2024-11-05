/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-07
 *********************************************************************/

data Males;
   keep Freq Years Censored;
   retain Years - 0.5;
   input fail withdraw @@;
   Years + 1;
   Censored = 0;  Freq = fail;      output;
   Censored = 1;  Freq = withdraw;  output;
datalines;
456   0 226  39 152  22 171  23 135 24 125 107
 83 133  74 102  51  68  42  64  43 45  34  53
 18  33   9  27   6  23   0  30
;
proc print data = Males; run;

proc lifetest data = Males  method = lt intervals = (0 to 15 by 1)
              plots = (s, ls, lls, h, p);
   time Years * Censored(1);
   freq Freq;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
