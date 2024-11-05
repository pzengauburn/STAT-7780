/********************************************************************* 
 * STAT 7780 - Survival Analysis 
 * Peng Zeng (Auburn University)
 * 2024-08-08
 *********************************************************************/

proc print data = sashelp.bmt; run; 

proc lifetest data = sashelp.bmt;
   time T * status(0);
   strata group;  
run; 

proc lifetest data = sashelp.bmt plots = survival(CL CB strata = panel);
   time T * status(0);
   strata group / adjust = sidak;  
run; 

proc lifetest data = sashelp.bmt plots = survival(CL CB strata = panel);
   time T * status(0);
   strata group / adjust = sidak diff = control("AML-Low Risk");  
run; 

/********************************************************************* 
 * THE END
 *********************************************************************/
