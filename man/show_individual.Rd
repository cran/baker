% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eda.R
\name{show_individual}
\alias{show_individual}
\title{get an individual's data from the output of \code{\link[=clean_perch_data]{clean_perch_data()}}}
\usage{
show_individual(data_nplcm, ID)
}
\arguments{
\item{data_nplcm}{data for fitting nplcm; See \code{\link[=nplcm]{nplcm()}}}

\item{ID}{patient id: \code{patid}.}
}
\value{
a list with the inquired patient's data
}
\description{
get an individual's data from the output of \code{\link[=clean_perch_data]{clean_perch_data()}}
}
\examples{
data(data_nplcm_noreg)
data_nplcm_noreg$X$patid <- paste("PAT",1:length(data_nplcm_noreg$Y0),sep="")
data_nplcm_noreg$X <- as.data.frame(data_nplcm_noreg$X)
subset_data_nplcm_by_index(data_nplcm_noreg,which(data_nplcm_noreg$X$patid\%in\%c("PAT12","PAT408")))
data_nplcm_noreg$X <- NULL

}
\seealso{
Other exploratory data analysis functions: 
\code{\link{get_top_pattern}()},
\code{\link{plot_logORmat}()},
\code{\link{summarize_BrS}()},
\code{\link{summarize_SS}()},
\code{\link{visualize_season}()}
}
\concept{exploratory data analysis functions}
