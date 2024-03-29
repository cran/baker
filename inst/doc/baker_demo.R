## ----setup,echo=FALSE,results="hide"------------------------------------------
suppressPackageStartupMessages({
library(rjags)
library(R2jags)
library(baker)
library(binom)
library(knitr)
})

## ----lkd----------------------------------------------------------------------
fname = file.path(
  "example_data", 
  "pathogen_category_simulation.csv")
fname = system.file(
  fname, 
  package = "baker")
demodat = read.csv(fname, stringsAsFactors = FALSE)
kable(head(demodat))

## ----doit---------------------------------------------------------------------
# Note: the example will only run 100 Gibbs sampling steps to save computing time.
# To produce useful posterior inferences, please modify "mcmc_options" as follows
#                      "n.itermcmc" to 50000
#                      "n.burnin"   to 10000,
#                      "n.thin"     to 40,


working_dir <- tempdir() # <-- create a temporary directory.
#curd = getwd()
#randname = paste(curd, basename(tempfile()), sep="/") # need absolute path
#dir.create(randname)
#working_dir = randname

K.true  <- 2   # no. of latent subclasses in actual simulation. 
# If eta = c(1,0), K.true is effectively 1.
J       <- 6   # no. of pathogens.
N       <- 250 # no. of cases/controls.

# case subclass weight (five values):
subclass_mix_seq <- c(0,0.25,0.5,0.75,1)


NREP   <- 100
MYGRID <- expand.grid(list(rep   = 1:NREP, # data replication.
                           iter  = seq_along(subclass_mix_seq),# mixing weights.
                           k_fit = c(1,2), # model being fitted: 1 for pLCM; >1 for npLCM.
                           scn   = 3:1)    # index for different truth; see "scn_collection.R".
)

n_seed   <- nrow(unique(MYGRID[,-3]))
seed_seq <- rep(1:n_seed,times=length(unique(MYGRID[,3])))

SEG   <- 1 # The value could be 1 to nrow(MYGRID)=3000; here we just simulate one data set.
scn   <- MYGRID$scn[SEG]
k_fit <- 2#MYGRID$k_fit[SEG] 
iter  <- MYGRID$iter[SEG] 
rep   <- MYGRID$rep[SEG] 


# current parameters:
curr_mix <- subclass_mix_seq[iter]
lambda   <- c(0.5,0.5) #c(curr_mix,1-curr_mix)
eta      <- c(curr_mix,1-curr_mix) 

# set fixed simulation sequence:
seed_start <- 20161215  
set.seed(seed_start+seed_seq[SEG])

if (scn == 3){
  ThetaBS_withNA <- cbind(c(0.95,0.95,0.55,0.95,0.95,0.95),#subclass 1.
                          c(0.95,0.55,0.95,0.55,0.55,0.55))#subclass 2.
  PsiBS_withNA   <- cbind(c(0.4,0.4,0.05,0.2,0.2,0.2),     #subclass 1.
                          c(0.05,0.05,0.4,0.05,0.05,0.05)) #subclass 2.
}

if (scn == 2){
  ThetaBS_withNA <- cbind(c(0.95,0.9,0.85,0.9,0.9,0.9),   #subclass 1.
                          c(0.95,0.9,0.95,0.9,0.9,0.9))   #subclass 2.
  PsiBS_withNA   <- cbind(c(0.3,0.3,0.15,0.2,0.2,0.2),    #subclass 1.
                          c(0.15,0.15,0.3,0.05,0.05,0.05))#subclass 2.
}

if (scn == 1){
  ThetaBS_withNA <- cbind(c(0.95,0.9,0.9,0.9,0.9,0.9),#subclass 1.
                          c(0.95,0.9,0.9,0.9,0.9,0.9))#subclass 2.
  PsiBS_withNA   <- cbind(c(0.25,0.25,0.2,0.15,0.15,0.15),#subclass 1.
                          c(0.2,0.2,0.25,0.1,0.1,0.1))    #subclass 2.
}



# the following paramter names are set using names in the 'baker' package:
set_parameter <- list(
  cause_list      = c(LETTERS[1:J]),
  etiology        = c(0.5,0.2,0.15,0.05,0.05,0.05),# same length as cause_list.
  pathogen_BrS    = LETTERS[1:J],
  meas_nm         = list(MBS = c("MBS1")), # a single source of Bronze Standard (BrS) data.
  Lambda          = lambda,              #ctrl mix (subclass weights).
  Eta             = t(replicate(J,eta)), #case mix; # of rows equals length(cause_list).
  PsiBS           = PsiBS_withNA,
  ThetaBS         = ThetaBS_withNA,
  Nu      =     N, # control sample size.
  Nd      =     N  # case sample size.
)

# # visualize pairwise log odds ratios for cases and controls when eta changes 
# # from 0 to 1. In the following simulation, we just use one value: eta=0.
# example("compute_logOR_single_cause")

simu_out   <- simulate_nplcm(set_parameter)
data_nplcm <- simu_out$data_nplcm

## ----expl, fig.height=10, fig.width=10----------------------------------------

# specify cause list:
cause_list <- set_parameter$cause_list

# specify measurements:
# bronze-standard measurements:
patho_BrS_MBS1      <- set_parameter$pathogen_BrS
BrS_object_1        <- make_meas_object(patho_BrS_MBS1,"MBS","1","BrS",cause_list)
   # please use ?make_meas_object to see the measurement standards.



# pairwise log odds ratio plot:
pathogen_display <- BrS_object_1$patho
plot_logORmat(data_nplcm,pathogen_display,1)

## ----domod--------------------------------------------------------------------
m_opt1 <- list(likelihood   = list(cause_list = cause_list,               # <---- fitted causes.
                                   k_subclass = k_fit,                    # <---- no. of subclasses.
                                   Eti_formula = "~ 0",                   # <---- only apply FPR formula to specified slice of measurements; if not default to the first slice.
                                   FPR_formula = list(MBS1 = "~0")),      # <---- etiology regression formula.
               use_measurements = c("BrS"),                               # <---- which measurements to use to inform etiology
               prior        = list(Eti_prior   = overall_uniform(1, cause_list) ,                       # <--- etiology prior. 
                                   TPR_prior   = list(
                                     BrS  = list(info  = "informative",
                                                 input = "direct_beta_param",
                                                 val   = list(
                                                          MBS1 = list(alpha = list(rep(6,length(set_parameter$pathogen_BrS))),
                                                                      beta  = list(rep(2,length(set_parameter$pathogen_BrS)))
                                                                     )
                                                 )
                                                 
                                     )
                                     
                                   )# <---- TPR prior.
               )
)                       

model_options <- m_opt1
assign_model(model_options,data_nplcm)

## ----dofit, eval=FALSE--------------------------------------------------------
#  # date stamp for analysis:
#  Date     <- gsub("-", "_", Sys.Date())
#  # include stratification information in file name:
#  dated_strat_name    <- file.path(working_dir,
#                                   paste0("scn_",scn,"_mixiter_",iter))
#  if (dir.exists(dated_strat_name)) {
#    unlink(dated_strat_name, force = TRUE)
#  }
#  
#  # create folder
#  dir.create(dated_strat_name)
#  fullname <- dated_strat_name
#  
#  # for finer scenarios, e.g., different types of analysis applicable to the
#  # same data set. Here we just perform one analysis:
#  result_folder <- file.path(
#    fullname,
#    paste0("rep_", rep, "_kfit_",
#           model_options$likelihood$k_subclass))
#  dir.create(result_folder)
#  
#  
#  # options for MCMC chains:
#  mcmc_options <- list(
#    individual.pred = !TRUE,
#    ppd             = TRUE,
#    n.chains   = 1,
#    n.itermcmc = as.integer(200), #50000
#    n.burnin   = as.integer(100), #10000
#    n.thin     = 1, #50
#    result.folder = result_folder,
#    bugsmodel.dir = result_folder
#  )
#  
#  # Record the settings of current analysis:
#  # data clean options:
#  fname = file.path(
#    "example_data",
#    "pathogen_category_simulation.csv")
#  fname = system.file(
#    fname,
#    package = "baker")
#  global_patho_taxo_dir = fname
#  
#  clean_options <- list(
#    BrS_objects        =  make_list(BrS_object_1),         # <---- all bronze-standard measurements.
#    patho_taxo_dir = global_patho_taxo_dir,
#    allow_missing      = FALSE)
#  
#  # place the nplcm data and cleaning options into the results folder
#  dput(data_nplcm,file.path(mcmc_options$result.folder,"data_nplcm.txt"))
#  dput(clean_options,file.path(mcmc_options$result.folder,"data_clean_options.txt"))
#  
#  gs <- nplcm(data_nplcm, model_options, mcmc_options)

## ----dovizsetup,eval=FALSE----------------------------------------------------
#  result_folder <- mcmc_options$result.folder

## ----lkpan,fig.height=10, fig.width=10, eval=FALSE----------------------------
#  suppressWarnings(plot(gs, bg_color = NULL))

## ----lkpan2,fig.height=10, fig.width=10, eval=FALSE---------------------------
#  plot(gs, bg_color = NULL, select_latent = c("A","C"), exact = TRUE)

## ----doSLORD,fig.height=10, fig.width=10, eval=FALSE--------------------------
#  plot_check_pairwise_SLORD(result_folder, slice=1)

## ----doobsf,fig.height=10, fig.width=10, eval=FALSE---------------------------
#  dir_list <- as.list(c(result_folder))
#  plot_check_common_pattern(dir_list,slice_vec =c(1,1))

