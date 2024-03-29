% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{unfactor}
\alias{unfactor}
\title{Convert factor to numeric without losing information on the label}
\usage{
unfactor(f)
}
\arguments{
\item{f}{A factor}
}
\value{
A numeric vector
}
\description{
Convert factor to numeric without losing information on the label
}
\examples{
unfactor(factor(c("1","3","3"),levels=c("1","3")))
# contrast this to:
as.numeric(factor(c("1","3","3"),levels=c("1","3"))) 
}
