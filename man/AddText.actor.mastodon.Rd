% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AddText.mastodon.R
\name{AddText.actor.mastodon}
\alias{AddText.actor.mastodon}
\title{Add columns containing text data to mastodon actor network dataframes}
\usage{
\method{AddText}{actor.mastodon}(net, data, ..., writeToFile = FALSE, verbose = TRUE)
}
\arguments{
\item{net}{A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.}

\item{data}{A dataframe generated by \code{Collect}.}

\item{...}{Additional parameters passed to function. Not used in this method.}

\item{writeToFile}{Logical. Write data to file. Default is \code{FALSE}.}

\item{verbose}{Logical. Output additional information. Default is \code{TRUE}.}
}
\value{
Network as a named list of two dataframes containing \code{$nodes} and \code{$edges} including columns
containing text data.
}
\description{
Add columns containing text data to mastodon actor network dataframes
}
\examples{
\dontrun{
# add text to an actor network ignoring references to actors at the beginning of
# comment text
net_actor <- collect_mdn |>
  Create("actor") |>
  AddText(collect_mdn)

# network
net_actor$nodes
net_actor$edges
}

}
