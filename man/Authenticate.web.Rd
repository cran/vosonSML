% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Authenticate.web.R
\name{Authenticate.web}
\alias{Authenticate.web}
\title{Web crawler authentication}
\usage{
\method{Authenticate}{web}(socialmedia, ..., verbose = TRUE)
}
\arguments{
\item{socialmedia}{Character string. Identifier for social media API to authenticate, set to \code{"web"}.}

\item{...}{Additional parameters passed to function. Not used in this method.}

\item{verbose}{Logical. Output additional information. Default is \code{TRUE}.}
}
\value{
A \code{credential} object containing a \code{$auth = NULL} value and social media type descriptor
\code{$socialmedia} set to \code{"web"}. Object has the class names \code{"credential"} and \code{"web"}.
}
\description{
Web crawler does not require authentication in this version of vosonSML.
}
\note{
Even though the web crawler does not require authentication in this version of vosonSML the \code{Authenticate}
function must still be called to set the \code{socialmedia} identifier. This is used to route to the appropriate
social media \code{Collect} function.
}
\examples{
\dontrun{
# web authentication
webAuth <- Authenticate("web")
}

}
