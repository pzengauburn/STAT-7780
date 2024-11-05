/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-14
 *********************************************************************/

data chemo;
   input time @@;
   type = 'chemo';
   if time > 2500 then delta = 0; else delta = 1;
datalines;
1 63 105 129 182 216 250 262 301 301 342 354
356 358 380 383 383 388 394 408 460 489 499 523
524 535 562 569 675 676 748 778 786 797 955 968
1000 1245 1271 1420 1551 1694 2363 2754 2950
;

data chemoradio;
   input time @@;
   type = 'C&R';
   if time > 2400 then delta = 0; else delta = 1;
datalines;
17 42 44 48 60 72 74 95 103 108 122 144
167 170 183 185 193 195 197 208 234 235 254 307
315 401 445 464 484 528 542 547 577 580 795 855
1366 1577 2060 2412 2486 2796 2802 2934 2988
;

data mydata;
   set chemo chemoradio;
proc print data = mydata; run;

proc lifetest data = mydata;
   time time * delta(0);
   strata type / test = all;
run;

/********************************************************************* 
 * THE END
 *********************************************************************/
