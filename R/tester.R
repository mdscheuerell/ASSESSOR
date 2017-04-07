

if(!require("R2jags")) {
  install.packages("R2jags")
  library("R2jags")
}
if(!require("RCurl")) {
  install.packages("RCurl")
  library("RCurl")
}
if(!require("gsl")) {
  install.packages("gsl")
  library("gsl")
}

## 1. file with escapement data
## [n_yrs x 2] matrix of obs counts; 1st col is calendar yr
fn_esc <- "SkagitSthdEsc.csv"

## 2. file with age comp data
## [n_yrs x (1+A)]; 1st col is calendar yr
fn_age <- "SkagitSthdAge.csv"
## min & max ages
age_min <- 3
age_max <- 8
## years, if any, of age-comp to skip; see below
age_skip <- 2

## 3. file with harvest data
## [n_yrs x 2] matrix of obs catch; 1st col is calendar yr
fn_harv <- "SkagitSthdCatch.csv"

## 4. file with covariate data
## [n_yrs x (1+MM)]; 1st col is calendar yr
fn_hrel <- "SkagitHatchRel.csv"

## time lags (years) for covariates
flow_lag <- 1
marine_lag <- 2
hrel_lag <- 2

## number of years of forecasts
n_fore <- 1

## file where to save JAGS model
fn_jags <- "SkagitSthd_RR_JAGS.txt"

## upper threshold for Gelman & Rubin's (1992) potential scale reduction factor (Rhat).
Rhat_thresh <- 1.1

## URL for example data files
## set to NULL if using a local folder/directory
ex_url <- "https://raw.githubusercontent.com/mdscheuerell/ASSESSOR/master/datafiles/"

## escapement
dat_esc <- read.csv(text = getURL(paste0(ex_url,fn_esc)))
## years of data
dat_yrs <- dat_esc$year
## number of years of data
n_yrs <- length(dat_yrs)
## get first & last years
yr_frst <- min(dat_yrs)
yr_last <- max(dat_yrs)
## log of escapement
ln_dat_esc <- c(log(dat_esc[,-1]),rep(NA,n_fore))



