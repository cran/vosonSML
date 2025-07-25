% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Merge.R, R/zzz.R
\name{Merge}
\alias{Merge}
\alias{merge_data}
\title{Merge collected data}
\usage{
Merge(..., unique = TRUE, rev = TRUE, writeToFile = FALSE, verbose = TRUE)

merge_data(..., unique = TRUE, rev = TRUE, writeToFile = FALSE, verbose = TRUE)
}
\arguments{
\item{...}{Collect data to merge.}

\item{unique}{Logical. Remove duplicates based on observation id. Default is \code{TRUE}.}

\item{rev}{Logical. Reverses order of observations before removing duplicates. If collect data is provided
chronologically then this should ensure the most recent copy of a duplicate is kept. Default is \code{TRUE}.}

\item{writeToFile}{Logical. Save data to a file in the current working directory. Default is \code{FALSE}.}

\item{verbose}{Logical. Output additional information. Default is \code{TRUE}.}
}
\value{
A merged Collect object.
}
\description{
Merge collected data
}
