#' @title Twitter API authentication
#' 
#' @description Twitter authentication uses OAuth and typically requires four developer API keys
#' generated when you create a twitter app via the twitter developer web site.
#' 
#' There is another method available commonly used by third-party apps in which an app can be
#' authorized by a user to use the twitter API on their behalf. The implementation
#' of this method in vosonSML does not require a developer account but does still require
#' the user to have access to a developers apps two consumer API keys. This allows multiple
#' users to access the twitter API with vosonSML via a single developer account and app. 
#' 
#' The twitter OAuth process is described here: 
#' \url{https://developer.twitter.com/en/docs/basics/authentication/overview/oauth}.
#' 
#' @param socialmedia Character string. Identifier for social media API to authenticate, set to \code{"twitter"}.
#' @param appName Character string. Registered twitter app name associated with the API keys.
#' @param apiKey Character string. API consumer key to authenticate.
#' @param apiSecret Character string. API consumer secret to authenticate.
#' @param accessToken Character string. API access token to authenticate.
#' @param accessTokenSecret Character string. API access token secret to authenticate.
#' @param ... Additional parameters passed to function. Not used in this method.
#' 
#' @return A \code{credential} object containing an access token \code{$auth} and social media type descriptor 
#' \code{$socialmedia} set to \code{"twitter"}. Object has the class names \code{"credential"} and \code{"twitter"}.
#' 
#' @examples
#' \dontrun{
#' # twitter authentication using developer app API keys
#' myDevKeys <- list(appName = "My App", apiKey = "xxxxxxxxxxxx",
#'   apiSecret = "xxxxxxxxxxxx", accessToken = "xxxxxxxxxxxx",
#'   accessTokenSecret = "xxxxxxxxxxxx")
#' 
#' twitterAuth <- Authenticate("twitter", appName = myDevKeys$appName, 
#'   apiKey = myDevKeys$apiKey, apiSecret = myDevKeys$apiSecret, accessToken = myDevKeys$accessToken, 
#'   accessTokenSecret = myDevKeys$accessTokenSecret)
#' 
#' # twitter authentication via authorization of an app to their user account
#' # requires the apps consumer API keys
#' # apiKey and apiSecret parameters are equivalent to the apps consumer key and secret
#' # will open a web browser to twitter prompting the user to log in and authorize the app
#' twitterAuth <- Authenticate("twitter", appName = "An App",
#'   apiKey = "xxxxxxxxxxxx", apiSecret = "xxxxxxxxxxxx"
#' )
#' }
#'  
#' @export
Authenticate.twitter <- function(socialmedia, appName, apiKey, apiSecret, accessToken, accessTokenSecret, ...) {
  
  if (!requireNamespace("rtweet", quietly = TRUE)) {
    stop("Please install the rtweet package before calling Authenticate.", call. = FALSE)
  }
  
  credential <- list(socialmedia = "twitter", auth = NULL)
  class(credential) <- append(class(credential), c("credential", "twitter"))   

  if (missing(appName)) {
    stop("Missing twitter app name.", call. = FALSE)
  } 
  
  if (missing(apiKey) || missing(apiSecret)) {
    stop("Missing twitter consumer API keys.", call. = FALSE)
  }
  
  if (missing(accessToken) || missing(accessTokenSecret)) {
    credential$auth <- rtweet::create_token(
      app = appName,
      consumer_key = apiKey,
      consumer_secret = apiSecret,
      set_renv = FALSE)
    
    return(credential)
  }
  
  credential$auth <- rtweet::create_token(
    app = appName,
    consumer_key = apiKey,
    consumer_secret = apiSecret,
    access_token = accessToken,
    access_secret = accessTokenSecret,
    set_renv = FALSE)
  
  credential
}
