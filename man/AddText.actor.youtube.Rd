% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AddText.R
\name{AddText.actor.youtube}
\alias{AddText.actor.youtube}
\alias{AddText.activity.youtube}
\title{Add columns containing text data to YouTube activity network dataframes}
\usage{
\method{AddText}{activity.youtube}(net, data, ..., writeToFile = FALSE, verbose = TRUE)

\method{AddText}{actor.youtube}(
  net,
  data,
  repliesFromText = FALSE,
  atRepliesOnly = TRUE,
  ...,
  writeToFile = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{net}{A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.}

\item{data}{A dataframe generated by \code{Collect}.}

\item{...}{Additional parameters passed to function. Not used in this method.}

\item{writeToFile}{Logical. Write data to file. Default is \code{FALSE}.}

\item{verbose}{Logical. Output additional information. Default is \code{TRUE}.}

\item{repliesFromText}{Logical. If comment text for an edge begins with \code{screen_name} change the edge to be
directed to \code{screen_name} - if different from the top level comment author that the reply comment was posted
to. Default is \code{FALSE}.}

\item{atRepliesOnly}{Logical. Comment \code{screen_names} must begin with an '@' symbol to be redirected. Default is
\code{TRUE}.}
}
\value{
Network as a named list of two dataframes containing \code{$nodes} and \code{$edges} including columns
containing text data.

Network as a named list of two dataframes containing \code{$nodes} and \code{$edges} including columns
containing text data.
}
\description{
Text comments are added to the network as node attributes.

Text comments are added to the network as edge attributes. References to actors are detected at the
beginning of comments and edges redirected to that actor instead if they differ from the top-level comment author.
}
\examples{
\dontrun{
# add text to an activity network
net_activity <- collect_yt |>
  Create("activity") |> AddText(collect_yt)

# network
net_activity$nodes
net_activity$edges
}

\dontrun{
# add text to an actor network ignoring references to actors at
# the beginning of comment text
net_actor <- collect_yt |>
  Create("actor") |>
  AddText(collect_yt, repliesFromText = FALSE)

# network
net_actor$nodes
net_actor$edges
}

}
