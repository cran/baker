% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{get_pEti_samp}
\alias{get_pEti_samp}
\title{get etiology samples by names (no regression)}
\usage{
get_pEti_samp(res_nplcm, model_options)
}
\arguments{
\item{res_nplcm}{result from model fits}

\item{model_options}{model specification}
}
\value{
A list:
\itemize{
\code{pEti_mat}: a matrix of posterior samples (iteration by cause); overall etiology
\code{latent_nm}: a vector of character strings representing the names of the causes
}
}
\description{
get etiology samples by names (no regression)
}
