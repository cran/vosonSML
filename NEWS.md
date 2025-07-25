# vosonSML 0.35.1

## Bug Fixes
- Updated reddit user-agent parameters as default to NULL. If NULL, requests use the `HTTPUserAgent` option value,
  which is set by default to the internal package user-agent by function `vsml_ua()` during collection.
- Automatically removed duplicate comments from youtube `Collect` data based on `CommentID`, these records can be found
  in an attribute of the object named `duplicated`. Access using `attributes(youtube_data)$duplicated`.

## Minor Changes
- Removed the twitter section from the package vignette.

# vosonSML 0.35.0

## Bug Fixes
- Changed reddit https collection method because of platform issues with the `httr` packages on Windows.
- Removed failing S3 dispatch methods from the `Graph` function.
- Replaced `httr` request methods with `httr2` versions.

## Major Changes
- Removed twitter functions from the package.

## Minor Changes
- Added `writeToFile` to all methods.
- Added `Merge` support for mastodon.
- Changed the `voson.msg` option to `voson.cat` for `cat` message output.
- Changed `verbose` message technique and `verbose = TRUE` is now the default for most functions.

# vosonSML 0.34.3

## Bug Fixes
- Disabled metadata logging that occurs when the `writeToFile` parameter of `Collect` is used. This is due to a new
  package issue with R version 4.4.
  
# vosonSML 0.34.2

## Bug Fixes
- Fixed a reddit data collection issue for threads that are specified using shorter URL's without the title part and
  that contain `continue thread` links. These links were resolving to the main thread resulting in duplication of
  comments and thread structures.
  
# vosonSML 0.34.1

## Minor Changes
- Added a parameter to `Mastodon` network `Create()` function named `subtype` for creating variations to the
  `activity` and `actor` networks. For the `activity` network a `subtype = tag` parameter can be used to create a `tag`
  network of post tags that are colocated. For the `actor` network a `subtype = server` parameter can be used to create
  a `server` network, which is an `actor` network reduced to server associations.
  
# vosonSML 0.34.0

## Major Changes
- Added `Mastodon` authentication, collection and network creation. There are two options for `Mastodon` collection, a
  hashtag search for global or local server timeline posts that is optionally authenticated: `Collect.search.mastodon()`,
  and a public thread collection function using input URL's that is similar to `Reddit` thread collection that requires
  no authentication: `Collect.thread.mastodon()`. To access these methods via `Collect` an `endpoint = "search"` or
  `endpoint = "thread"` parameter should be passed to the functions.
- The `Mastodon` authentication and collection uses the `rtoot` package and a function has been created for importing
  `rtoot` data into `vosonSML` called `ImportRtoot`. Imported data can be passed as input to the `Create` network functions.
  
## Minor Changes
- Changed default `Reddit` request wait time range from 3 to 5 seconds, to 6 to 8 seconds to avoid a proposed platform
  rate limit of 10 requests per minute. This value can still be manually set using the `waitTime = c(min, max)` wait time
  range parameter.

# vosonSML 0.33.2

## Bug Fixes
- Fixed a bug in the regex for `Reddit` URL parsing in which thread ID's were limited to 6 characters.
- Fixed verbose output for `2mode` networks to use option specified method.
- Fixed an issue with adding text to `Twitter` networks caused by missing columns in the data.
- Added twitter tokenization functions that were recently removed from the `tidytext` and `tokenizers` packages due to
  a change in the ICU library unicode standard and the `stringi` package
  ([tokenizers issue #82](https://github.com/ropensci/tokenizers/issues/82)). This affects only the generation of
  `semantic` and `2mode` twitter networks and the fix maintains their functionality until an alternative tweet
  tokenization method is implemented. Unfortunately these two twitter network types are not supported on systems using
  ICU library versions >= 72.0 at this time.
- Fixed an intermitant column mismatch error in `Twitter` caused by unexpected type when data merging.
- Fixed the number of tweet observations does not match number of users error reported with `rtweet` v1.1.
- Fixed number of tweets requested count in verbose message for `Twitter` timeline collection.
- Fixed a bug in `Reddit` thread collection where URL's missing trailing slashes would trigger loop protection errors.
- Changed the default `sort` parameter value for `Reddit` threaad collection to be `NA`. Default sort order on `Reddit`
  is not a fixed value.

## Major Changes
- Added `sort` parameter to `Reddit` collection. As this collection method is limited, it may be useful to request
  comments in sort order using the `Reddit` sort options `top`, `new`, `controversial`, `old`, `qa` and `best`.
- Added a `Collect.listing` function for subreddits on `Reddit`. This is not a search, however it allows complete
  metadata for a specified number of subreddit threads to be collected in sorted order. The sort options are `hot`,
  `top`, `new` and `rising`. There is a further time parameter `period` that can be set to `hour`, `day`, `week`,
  `month`, `year` or `all` if `sort = top`, meaning for example, results sorted by top threads over the last week.

## Minor Changes
- Added simple log file output for `Collect` and `Merge` functions when `writeToFile = TRUE`. The log file is written in
  the same location as the data file with the `.txt` extension appended.
- Changed data output path option `option(voson.data = "my-data")` to now attempt to create the directory if it does
  not exist.

# vosonSML 0.32.8

## Bug Fixes
- Fixed two issues that arose from the introduction of tibbles and verbose messaging in `Collect.reddit()`.
- Fixed an error caused by unescaped regex parameters in hyperlinks processed by `Collect.web()` ([#49](https://github.com/vosonlab/vosonSML/issues/49)).

# vosonSML 0.32.7

## Major Changes
- Re-wrote and modified `vosonSML` `Twitter` functions to support major changes made in `rtweet` release version 1.0.2.
- Added an `endpoint` parameter to the `Twitter` `Collect` function. It is set to `search` by default, which is the
  usual collect behaviour, but can also now be set to `timeline` to collect user timelines instead. See
  `Collect.timeline.twitter()` for parameters.
- Changed output message system. `vosonSML` functions are now silent by default. Using the `verbose` parameter will
  again print function output.
- Changed output messages to use the `message()` function instead of the `cat()` function by default. Setting the global
  option `option(voson.msg = FALSE)` will again redirect output to `cat()`. The option can be removed by assigning a
  value of `NULL`.
- Added the `voson.data` option allowing a directory path to be set for `writeToFile` output files. Files are output to
  the current working directory by default, however a new directory can now be set with `option(voson.data = "my-data")`
  for example. The directory path can be relative or a full path, but must be created beforehand or already exist. If
  the path is invalid or does not exist it will continue with the default behaviour. This option can be removed by
  assigning a value of `NULL`.
  This will not effect other file write operations performed by the user.
- The `Twitter` `AddText()` and `AddUserData()` functions now work with most `Twitter` network types.
- `AddText()` now adds columns for embedded tweet text and has a `hashtags` parameter to add a list of tweet hashtags as
  a network attribute.
- `AddUserData()` now adds an additional dataframe for `missing_users`. It lists the ids and screen names of users that
  did not have metadata embedded in the collected data. Using the `lookupUsers` parameter will retrieve the metadata
  using the twitter API. Additonally passing the `refresh = TRUE` parameter will now retrieve and update the metadata
  for all users in the network.
- Twitter data collection now returns a named list of two dataframes containing `tweets` and `users`.
- Removed the `ImportData` function and replaced it with `ImportRtweet()` for `rtweet` version 1.0 format data.
- Added `Merge()` and `MergeFiles()` functions to support the merging of collected data from separate operations. These
  functions support input of multiple Collect objects or `.RDS` files, automatically detect the datasource type and
  support the `writeToFile` parameter for file output of merged data. 

## Minor Changes
- Re-wrote `YouTube` id extraction from url function to be more robust and added support for `YouTube` shorts urls.
- Removed stand-alone `GetYoutubeVideoIDs` function. The `YouTube` collect function parameter `videoIDs` will now accept
  video ids or video urls.
- Added wrappers and aliases for some functions. Twitter auth objects can now be created with simplified
  `auth_twitter_app()`, `auth_twitter_dev()` and `auth_twitter_user()` functions for each token type. The
  `collect_reddit_threads()` and `collect_web_hyperlinks()` functions skip the unecessary `Authenticate` step for
  `Reddit` and web data collection.

# vosonSML 0.31.1

## Bug Fixes
- Incorrectly ordered tweets by `status ID` to summarise collected tweet range. The `Min ID` and `Max ID` are not
  necessarily the earliest and latest tweet in the tweets collected and therefore not ideal for delimiting subsequent
  collections. Instead the two `Earliest Obs` and two `Latest Obs` tweets as returned by the `Twitter API` are now
  reported.

## Major Changes
- Added `enpoint` parameter to `Collect`, allowing `search` or `timeline` to be specified for a `twitter` data
  collection. If it is not specified the default is a twitter `search`.
- The `timeline` collection accepts a `users` vector of user names or ID's or a mixture of both, and will return up to
  3,200 of each users most recent tweets.
- Minimum required version of R has changed from 3.6 to 4.1.

## Minor Changes
- Updated standard package documentation, added citation, code of conduct and README.Rmd.
- Replaced magrittr pipes with native pipe operators.

# vosonSML 0.30.6

## Minor Changes
- Updated standard package documentation, added citation and README.Rmd.

# vosonSML 0.30.5

## Major Changes
- Re-implemented `Create.actor.twitter` and `Create.activity.twitter` to use `dplyr` and `data.table` techniques
  consistent with other package network creation functions. Both functions are significantly faster for large collection
  dataframes.

## Minor Changes
- `Create.actor.twitter` includes two new parameters for `mentions`, `inclMentions` that will process and include
  `mentions` edges in the network and `inclRtMentions` that will process and include mentions found in retweets.
  The `inclMentions` parameter is set to `TRUE` by default and `inclRtMentions` set to `FALSE`. The `inclRtMentions`
  parameter is a subset of mentions, therefore for it to be set to `TRUE`, `inclMentions` must also be `TRUE`.
- Re-implemented and simplified the `Create.activity.twitter` network creation. Added `author_id` and
  `author_screen_name` to nodes to assist with labels or re-creating tweet URLs from data.
- Added `rmEdgeTypes` parameter to `Create.activity.twitter` and `Create.actor.twitter`. These accept a list of edge
  types that can be filtered out of the network during network creation.
- Removed label attributes from igraph graphs generated by the `Graph` function.
- Tidied up and renamed many of the utils functions. Removed unused functions.
- Added last observation tweet to minimum and maximum status ID values reported for twitter collections. Usually the
  last observation and `Min ID` will be the same, but sometimes the `Min ID` is outside of the expected collection
  range. The last observation is a more reliable tweet to use as the starting point for subsequent search collections.
- Cleaned up package imports, suggests and added some interactive package checks to reduce the number of required
  imports.

# vosonSML 0.30.0

## Major Changes
- Added a web crawler `Collect` method with hyperlink network creation. The `Create` function with `activity` type
  parameter creates a network where nodes are `web pages` and edges the `hyperlinks` linking them (extracted from
  `a href` HTML tags). The `actor` network has page or `site domains` as the nodes and again the `hyperlinks` from
  linking pages between domains.

# vosonSML 0.29.14

## Minor Changes
- Prepending instead of appeneding S3 class names to `Collect` dataframes to avoid `dplyr` issues.
- Removed `retryOnRateLimit` set to `FALSE` if rate limit cannot be determined.
- `ImportData` will now accept a file path or a dataframe.

## Bug Fixes
- S3 class names were being added to `Collect` dataframes after `writeToFile`. Should no longer be required to manually
  add class names or use `ImportData` to load RDS files to use previously saved data with `Create` functions.

# vosonSML 0.29.13

## Minor Changes
- Minor documentation updates to `Create.semantic.twitter`, `Create.twomode.twitter` and the `Intro-to-vosonSML`
  vignette:
  - Specified the `tidyr`, `tidytext` and `stopwords` package requirements in descriptions and examples
  - Updated references to `twomode` networks as `2-mode` where possible

# vosonSML 0.29.12

## Bug Fixes
- Fixed an issue with custom classes assigned to dataframes causing an `vctrs` error when using `dplyr` functions. The
  classes are no longer needed post-method routing so they are simply removed.
- Replaced an instance of the deprecated `dplyr::funs` function that was generating a warning.

## Minor Changes
- Minor documentation updates.

# vosonSML 0.29.11

## Bug Fixes
- Fixed a reddit collect `bind_rows` error on joining dataframes with different types for the structure column. Column
  type was being set to integer instead of character in cases when every thread comment have no replies or depth (except
  the OP).

# vosonSML 0.29.10

## Minor Changes
- Reimplemented the `Create.semantic.twitter` and `Create.twomode.twitter` functions using the `tidytext` package. They
  now better support tokenization of tweet text and allows a range of stopword lists and sources to be used from the
  `stopwords` package. The semantic network function requires the `tidytext` and `tidyr` packages to be installed before
  use.
- New parameters have been added to `Create.semantic.twitter`: 
  - Numbers and urls can be removed or included from the term list using `removeNumbers` and `removeUrls`, default
    value is `TRUE`.
  - The `assoc` parameter has been added to choose which node associations or ties to include in the network. The
    default value is `"limited"` and includes only ties between most frequently occurring hashtags and terms in
    tweets. A value of `full` will also include ties between most frequently occurring hashtags and hashtags, and
    terms with terms creating a more densely connected network.
  - Parameters to specify `stopwords` language e.g `stopwordsLang = "en"` and source e.g `stopwordsSrc = "smart"` have
    been added. These correspond to the `language` and `source` parameters of the `tidytext::get_stopwords` function.
    The `stopwords` default value is `TRUE`.
- The network produced by the `Create.twomode.twitter` function is weighted by default but can be disabled by setting
  the new `weighted` parameter to `FALSE`.
- Renamed the `replies_from_text` parameter to `repliesFromText` and `at_replies_only` to `atRepliesOnly` in the
  `AddText.actor.youtube` function for consistency.
- Improved the usage examples in the README file.
- Removed `tm` package dependency.

# vosonSML 0.29.9

## Minor Changes
- Updated `Introduction to vosonSML` vignette `Merging Collected Data` examples.
- Added new hex sticker to package documentation.

## Bug Fixes
- Fixed a logic problem in `Collect.youtube` that was causing no video comments to be collected if there were no reply
  comments for any of the videos first `maxComments` number of top level comments. For example, if `maxComments` is set
  to 100 and the first 100 comments made to a video had no replies then no results would be returned.

# vosonSML 0.29.8

## Bug Fixes
- A recent intermittent problem with the Twitter API caused an issue with the `rtweet::rate_limit` function that
  resulted in an error when using the rtweet `retryonratelimit` search parameter. The `rate_limit` function was being
  called by `vosonSML` to check the twitter rate limit regardless of whether the search parameter was set or not, and so
  was failing `Collect` with an error. A fix was made so that `vosonSML` checks if `rtweet::rate_limit` succeeds, and if
  not automatically sets `retryonratelimit` to `FALSE` so that a twitter `Collect` can still be performed without error
  should this problem occur again.

## Minor Changes
- Added some links to the `pkgdown` site navbar.

# vosonSML 0.29.7

## Minor Changes
- Added some guidance for merging collected data to the `Introduction to vosonSML` vignette. 

# vosonSML 0.29.6

## Minor Changes
- Added `Introduction to vosonSML` vignette to the package.
- Minor changes and input checks added to `ImportData`.
- Added some unit testing for `Authenticate` and `ImportData`.

# vosonSML 0.29.5

## Minor Changes
- Reddit JSON is now retrieved using `jsonlite::fromJSON`.
- Reddit 'Continue' threads are now followed with additional thread requests. Many more comments are now collected for
  threads with large diameters or breadth. Continue threads also have a Reddit limit of 500 comments per thread request.
- Reddit comment ID's and timestamps are now extracted.
- Removed the `tictoc` package from dependency imports to suggested packages.
- Added some checks for whether the `rtweet` package is installed.
- Removed the `RedditExtractoR` package from imports.
- HTML decoded tweet text during network creation to replace '&', '<', and '>' HTML codes.
- Added node type attribute to `twomode` networks.

# vosonSML 0.29.4

## Minor Changes
- Renamed `bimodal` networks to `twomode`.

# vosonSML 0.29.3

## Minor Changes
- Added output messages from supplemental functions such as `AddText()` and `Graph()`. Also improved
  consistency of output messages from `Collect` and `Create` functions.

## Bug Fixes
- Added a fix `reddit` gsub locale error https://github.com/vosonlab/vosonSML/issues/21.
- Changed `bimodal` network hashtags to lowercase as filter terms when entered are converted to
  lowercase.
- Fixed errors thrown when removing terms from `bimodal` and `semantic` networks.
- Removed a duplicate `GetVideoData()` function call in `AddVideoData`.
- Fixed data type errors in `AddText` functions related to strict typing by `dplyr::if_else` function.

# vosonSML 0.29.2

## Minor Changes
- A feature was added to the youtube actor `AddText` function to redirect edges towards actors based
  on the presence of a `screen name` or `@screen name` that may be found at the beginning of
  a reply comment. Typically reply comments are directed towards a top-level comment, this
  instead captures when reply comments are directed to other commenters in the thread.

# vosonSML 0.29.1

## Minor Changes
- Changed youtube `actor` network identifiers to be their unique `Channel ID` instead of their
  `screen names`.
- Created the `AddVideoData` function to add collected video data to the youtube `actor` network. The
  main purpose of this function is to replace video identifiers with the `Channel ID` of the video
  publisher (actor) instead. To get the `Channel ID` of video publishers an additional API lookup for
  the videos in the network is required. Additional columns such as video `Title`, `Description` and
  `Published` time are also added to the network `$edges` dataframe as well as returned in their own
  dataframe called `$videos`.

# vosonSML 0.29.0

## Major Changes
- Created the `AddText` function to add collected text data to networks. This feature applies
  to `activity` and `actor` networks and will typically add a node attribute to activity networks
  and an edge attribute to actor networks. For example, this function will add the column
  `vosonTxt_tweets` containing tweet text to `$nodes` if passed an activity network, and to
  `$edges` if passed an actor network.
- Generation of `igraph` graph objects and subsequent writing to file has been removed from the
  `Create` function and placed in a new function `Graph`. This change abstracts the graph creation
  and makes it optional, but also allows supplemental network steps such as `AddText` to be
  performed prior to creating the final igraph object.

## Minor Changes
- Removed `writeToFile` parameter from `Create` functions and added it to `Graph`.
- Removed `weightEdges`, `textData` and `cleanText` parameters from `Create.actor.reddit`.
  `cleanText` is now a parameter of `AddText.activity.reddit` and `AddText.actor.reddit`.
- Replaced `AddTwitterUserData` with `AddUserData` function that works similarly to `AddText`.
  This function currently only applies to twitter actor networks and will add, or download
  add if missing, user profile information to actors as node attributes.

# vosonSML 0.28.1

## Minor Changes
- Added `activity` network type for reddit. In the reddit activity network nodes are the
  thread posts and comments, edges represent where comments are directed in the threads.
- Added github dev version badge to README.

# vosonSML 0.28.0

## Major Changes
- Added new `activity` network type for twitter and youtube `Create` function. In this network
  nodes are the items collected such as tweets returned from a twitter search and comments
  posted to youtube videos. Edges represent the platform relationship between the tweets or
  comments.

# vosonSML 0.27.3

## Minor Changes
- Added a new twitter actor network edge type `self-loop`. This aims to facilitate the later addition
  of tweet text to the network graph for user tweets that have no ties to other users.

# vosonSML 0.27.2

## Minor Changes
- Added twitter interactive web authorization of an app as provided by `rtweet::create_token`.
  Method is used when only twitter app name and consumer keys are passed to `Authenticate.twitter`
  as parameters. e.g `Authenticate("twitter", appName = "An App", apiKey = "xxxxxxxxxxxx",
  apiSecret = "xxxxxxxxxxxx")`. A browser tab will open asking the user to authorize the app to
  their twitter account to complete authentication. This is using twitters
  `Application-user authentication: OAuth 1a (access token for user context)` method.
- It is suspected that Reddit is rate-limiting some generic R UA strings. So a User-Agent string is
  now set for underlaying R Collect functions (e.g `file`) via the `HTTPUserAgent` option. It is
  temporarily set to package name and current version number for Collect e.g
  `vosonSML v.0.27.2 (R Package)`.
- Removed hex sticker (and favicons for pkgdown site).

# vosonSML 0.27.1

## Bug Fixes
- Fixed a bug in `Create.semantic.twitter` in which a sum operation calculating edge
  weights would set `NA` values for all edges due to `NA` values present in the hashtag fields.
  This occurs when there are tweets with no hashtags in the twitter collection and is now
  checked.
- Some UTF encoding issues in `Create.semantic.twitter` were also fixed.

## Minor Changes
- Added '#' to hashtags and '@' to mentions in twitter semantic network to differentiate between
  hashtags, mentions and common terms.

# vosonSML 0.27.0

## Bug Fixes
- Fixed a bug in `Collect.twitter` in which any additional `twitter API` parameters
  e.g `lang` or `until` were not being passed properly to `rtweet::search_tweets`. This
  resulted in the additional parameters being ignored.

## Major Changes
- Removed the `SaveCredential` and `LoadCredential` functions, as well as the `useCachedToken`
  parameter for `Authenticate.twitter`. These were simply calling the `saveRDS` and `readRDS`
  functions and not performing any additional processing. Using `saveRDS` and `readRDS` directly
  to save and load an `Authenticate` credential object to file is simpler.
- Changed the way that the `cleanText` parameter works in `Create.actor.reddit` so that it is
  more permissive. Addresses encoding issues with apostrophes and pound symbols and removes
  unicode characters not permitted by the XML 1.0 standard as used in `graphml` files. This is
  best effort and does not resolve all `reddit` text encoding issues.

## Minor Changes
- Added `Collect.twitter` summary information that includes the earliest (min) and latest (max)
  tweet `status_id` collected with timestamp. The `status_id` values can be used to frame
  subsequent collections as `since_id` or `max_id` parameter values. If the `until` date
  parameter was used the timestamp can also be used as a quick confirmation.
- Added elapsed time output to the `Collect` method.

# vosonSML 0.26.3

## Bug Fixes
- Fixed bugs in `Create.actor.reddit` that were incorrectly creating edges between
  top-level commentors and thread authors from different threads. These bugs were only
  observable in when collecting multiple reddit threads.

## Minor Changes
- Improved output for `reddit` collection. Removed the progress bar and added a table
  of results summarising the number of comments collected for each thread.
- Added to `twitter` collection output the users `twitter API` reset time.

# vosonSML 0.26.2

## Bug Fixes
- Fixed a bug in `Create.actor.twitter` and `Create.bimodal.twitter` in which the vertices
  dataframe provided to the `graph_from_data_frame` function as a contained duplicate names
  raising an error.

## Major Changes
- Revised and updated `roxygen` documentation and examples for all package functions.
- Updated all `Authenticate`, `Collect` and `Create` S3 methods to implement function routing
  based on object class names.

## Minor Changes
- Created a `pkgdown` web site for github hosted package documentation.
- Created a new hex sticker logo.

# vosonSML 0.25.0

## Major Changes
- Replaced the `twitteR` twitter collection implementation with the `rtweet` package.
- A users `twitter` authentication token can now be cached in the `.twitter_oauth_token` file and
  used for subsequent `twitter API` requests without re-authentication. A new authentication
  token can be cached by deleting this file and using the re-using the parameter
  `useCachedToken = TRUE`.
