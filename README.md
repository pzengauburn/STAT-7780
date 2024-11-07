# STAT 7780 - Survival Analysis by Peng Zeng

This repository contains the teaching materials for STAT 7780: Survival Analysis. 

## SAS codes and Datasets 

- SAS codes for examples discussed in lectures
- Datasets used in examples and homework problems

## 01. Introduction 
## 02. Basic Quantities and Models 
## 03. Inference for One Sample 

- [SAS](SAScodes-2024/03-drug6mp.sas): Leukemia remission -- Kaplan-Meier estimate and Nelson-Aalen estimate 
- [SAS](SAScodes-2024/03-channing.sas): Channing house -- left-truncated and right-censored data 
- [SAS](SAScodes-2024/03-males.sas): Males with angina pectoris -- life-table method 
- [SAS](SAScodes-2024/03-weaning.sas): Time to weaning -- life-table method 
- [R](SAScodes-2024/03-weibull-MLE.R): Newton-Raphson algorithm for Weibull distribution 

## 04. Inference for Two or More Samples 

- [SAS](SAScodes-2024/04-kidney.sas): Kidney dialysis patients -- copmare two groups
- [SAS](SAScodes-2024/04-example.sas): A simple example with three groups
- [SAS](SAScodes-2024/04-BMT.sas): Bone marrow transplant
- [SAS](SAScodes-2024/04-larynx.sas): Larynx cancer -- test for trend
- [SAS](SAScodes-2024/04-gastric.sas): Gastric cancer
- [SAS](SAScodes-2024/04-lung.sas): Lung cancer -- strata by continuous variable and test statement

## 05. Parametric Regression Models

- [SAS](SAScodes-2024/05-alloauto.sas): Autologous vs allogeneic transplants for AML
- [SAS](SAScodes-2024/05-larynx.sas): Larynx cancer -- regression using proc lifereg
- [SAS](SAScodes-2024/05-recid.sas): Efficacy of financial aid to released inmates -- interval censoring

## 06. Semiparametric Proporitional Hazards Regression 

- [SAS](SAScodes-2024/06-breast.sas) [R](SAScodes-2024/06-breast.R): Breast cancer trial
- [SAS](SAScodes-2024/06-VAlung.sas): VA lung cancer
- [SAS](SAScodes-2024/06-larynx.sas): Larynx cancer
- [SAS](SAScodes-2024/06-weaning.sas): Time to weaning

## 07. More Discussions on Semiparametric Proporitional Hazards Regression 

- [SAS](SAScodes-2024/07-bmt.sas): Bone marrow transplant
- [SAS](SAScodes-2024/07-kidney.sas): Kidney -- find tau in time-dependent covariate
- [SAS](SAScodes-2024/07-recid.sas): Efficacy of financial aid to released inmates -- different ways of including time-dependent covariates
- [SAS](SAScodes-2024/07-drug6mp.sas): Drug 6MP -- matched pairs
- [SAS](SAScodes-2024/07-tooth.sas): Tooth -- interval censoring

## 08. Cox Regression Diagnostics 

- [SAS](SAScodes-2024/08-bone.sas): Bone marrow transplant -- Cox-Snell residuals
- [SAS](SAScodes-2024/08-hodg.sas): Hodgkin's disease -- Martingale residuals, deviance residuals, score residuals
- [SAS](SAScodes-2024/08-alloauto.sas): Auto vs allo bone marrow transplants -- proportional hazards assumption
- [SAS](SAScodes-2024/08-pbc.sas): PBC from Mayo clinic trial -- assess statement

## 09. Selected Advanced Topics 

- [SAS](SAScodes-2024/09-leaders.sas): Leaders -- competing risk
- [SAS](SAScodes-2024/09-jobmult.sas): Jobs -- recurrent events
- [SAS](SAScodes-2024/09-rats.sas): Rats -- Gamma frailty model

## 10. More Topics 

- [SAS](SAScodes-2024/10-jobdur.sas): Jobs -- handling ties
- [SAS](SAScodes-2024/10-promotion.sas): Promotion -- use proc logistic
