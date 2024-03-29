% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean-perch-data.R
\name{clean_perch_data}
\alias{clean_perch_data}
\title{Clean PERCH data}
\usage{
clean_perch_data(clean_options)
}
\arguments{
\item{clean_options}{The list of options for cleaning PERCH data.
Its elements are defined as follows:

\describe{
\item{\code{raw_meas_dir}}{: The file path to the raw data;}
\item{\code{case_def}}{: Variable name in raw data for \strong{case} definition;}
\item{\code{case_def_val}}{: The value for \strong{case} definition;}
\item{\code{ctrl_def}}{: Variable name in raw data for \strong{control} definition;}
\item{\code{ctrl_def_val}}{: The value for \strong{control} definition;}
\item{\code{X_strat}}{: A vector of variable names for stratifying the data
to perform SEPARATE analyses;}
\item{\code{X_strat_val}}{: A list of values for \code{X_strat}. The output
data only have individuals with \code{identical(X_strat,X_strat_val)==TRUE}.
To perform analysis on a single site, say \code{"02GAM"}, use \code{X_strat="newSITE"} and
\code{X_strat_val=list("02GAM")};}
\item{\code{BrS_objects}}{: A list of BrS objects built by \code{\link[=make_meas_object]{make_meas_object()}};}
\item{\code{SS_objects}}{: A list of SS objects built by \code{\link[=make_meas_object]{make_meas_object()}};}
\item{\code{X_extra}}{: A vector of covariate names for regression
or visualization;}
\item{\code{patho_taxo_dir}}{: The file path to the pathogen category or taxonomy
information (.csv). The information should be as complete as possible for a particular
analysis. If not, the pathogen without taxonomy information could not be
assigned to bacterial or viral groups (see \code{plot_group_etiology()});
See \code{assign_taxo_cause_list()} that requires this taxonomy information.}.
}}
}
\value{
A List: \code{list(Mobs,Y,X)}
\itemize{
\item \code{Mobs} A list of bronze- (\code{MBS}), silver- (\code{MSS}),
and gold-standard (\code{MGS}, if available) measurements. See the formats
of these measurements in \code{\link[=extract_data_raw]{extract_data_raw()}}.
\item \code{Y} 1 for case; 0 for control;
\item \code{X} Data frame of covariates for cases and controls. The covariate
names are specified in \code{X_extra};
}
This function does not re-order pathogens that only have silver-standard data.
}
\description{
\code{clean_perch_data} transforms a raw data table (row for subjects, column
for variables - named as \code{\{pathogen name\}_\{specimen\}\{test\}} for lab tests
or other covariates) into a list. It is designed for PERCH data format.
}
\seealso{
\link{make_meas_object} for wrapping information about a particular
type of measurement; \link{extract_data_raw} for reading raw data table
and organizing them into \code{data_nplcm} format. Also see \link{clean_combine_subsites}
for combining subsites and \link[lubridate:parse_date_time]{parse_date_time} for parsing date.
}
\concept{data tidying functions}
