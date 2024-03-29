% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eda.R
\name{summarize_BrS}
\alias{summarize_BrS}
\title{summarize bronze-standard data}
\usage{
summarize_BrS(BrS_dat, Y)
}
\arguments{
\item{BrS_dat}{bronze-standard data, which is usually \code{data_nplcm$Mobs$MBS[[1]]}}

\item{Y}{A vector of case/control status: 1 for case; 0 for control}
}
\value{
a list of summaries for BrS data
}
\description{
summarize bronze-standard data
}
\examples{
data(data_nplcm_noreg)
summarize_BrS(data_nplcm_noreg$Mobs$MBS[[1]], data_nplcm_noreg$Y)

}
\seealso{
Other exploratory data analysis functions: 
\code{\link{get_top_pattern}()},
\code{\link{plot_logORmat}()},
\code{\link{show_individual}()},
\code{\link{summarize_SS}()},
\code{\link{visualize_season}()}
}
\concept{exploratory data analysis functions}
