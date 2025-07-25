% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Graph.R
\name{Graph}
\alias{Graph}
\title{Create an igraph graph from network}
\usage{
Graph(net, directed = TRUE, ..., writeToFile = FALSE, verbose = TRUE)
}
\arguments{
\item{net}{A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.}

\item{directed}{Logical. Create a directed graph. Default is \code{TRUE}.}

\item{...}{Additional parameters passed to function. Not used in this method.}

\item{writeToFile}{Logical. Save graph to a file in the current working directory. Default is \code{FALSE}.}

\item{verbose}{Logical. Output additional information. Default is \code{TRUE}.}
}
\value{
An igraph object.
}
\description{
Create an igraph graph from network
}
