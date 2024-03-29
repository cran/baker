% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eda.R
\name{plot_logORmat}
\alias{plot_logORmat}
\title{Visualize pairwise log odds ratios (LOR) for data that are available in
both cases and controls}
\usage{
plot_logORmat(data_nplcm, pathogen_display, BrS_slice = 1, logOR_rounding = 2)
}
\arguments{
\item{data_nplcm}{See \code{\link[=assign_model]{assign_model()}}.}

\item{pathogen_display}{The pathogen vector in desired order for display.
It can be of larger length than that of \code{pathogen_BrS}.}

\item{BrS_slice}{Default is 1 - the set of BrS data to visualize.}

\item{logOR_rounding}{Rounding number of the log odds ratio. Default is 2.}
}
\value{
Figure of LOR matrix and relevant s.e. and significance information.
}
\description{
Visualize pairwise log odds ratios (LOR) for data that are available in
both cases and controls
}
\details{
\code{plot_logORmat} visualizes a matrix of pairwise log odds ratios (LOR)
for cases (upper) and controls (lower). LOR is at the top of the cell.
Below it, its standard error is in smaller type, using the same color as the LOR.
Then the estimate is divided by its standard error. We put the actual value when
the Z-statistics has an absolute value greater than $2$; a plus (red) or minus (blue)
if between $1$ and $2$; blank otherwise.
}
\examples{
data(data_nplcm_noreg)
plot_logORmat(data_nplcm_noreg,names(data_nplcm_noreg$Mobs$MBS[[1]]))

}
\seealso{
Other exploratory data analysis functions: 
\code{\link{get_top_pattern}()},
\code{\link{show_individual}()},
\code{\link{summarize_BrS}()},
\code{\link{summarize_SS}()},
\code{\link{visualize_season}()}
}
\concept{exploratory data analysis functions}
