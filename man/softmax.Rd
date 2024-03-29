% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{softmax}
\alias{softmax}
\title{softmax}
\usage{
softmax(x)
}
\arguments{
\item{x}{a vector of numbers}
}
\value{
a vector of positive values that sum to one.
}
\description{
uses logsumexp trick to prevent numerical overflow
}
\examples{

softmax2 <- function(x) exp(x) / sum(exp(x))
softmax(c(1, 2, 3) * 1000)  # NaN NaN NaN
softmax2(c(1, 2, 3) * 1000)  # 0 0 1

}
