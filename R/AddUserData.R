#' @title Add columns of user information as node attributes to network dataframes
#'
#' @description Network is supplemented with additional downloaded social media user information applied as node
#'   attributes.
#'
#' @note Only supports twitter actor networks. Refer to \code{\link{AddUserData.actor.twitter}}.
#'
#' @param net A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.
#' @param data A dataframe generated by \code{Collect}.
#' @param ... Additional parameters passed to function.
#'
#' @return Network as a named list of three dataframes containing \code{$nodes}, \code{$edges}. Nodes include columns
#'   for additional user profile data and metrics. Referenced users for which no data was found are returned in
#'   \code{missing_users}.
#'
#' @aliases AddUserData
#' @name AddUserData
#' @export
AddUserData <- function(net, data, ...) {
  msg <- f_verbose(check_dots("verbose", ...))
  msg("Adding user data to network...")

  if ("voson.user" %in% class(net)) {
    stop("Network already has user attribute.")
  }

  # searches the class list of net for matching method
  UseMethod("AddUserData", net)
}

#' @noRd
#' @export
AddUserData.default <- function(net, ...) {
  stop("Unknown network type passed to AddUserData.", call. = FALSE)
}

#' @noRd
#' @method AddUserData actor
#' @export
AddUserData.actor <- function(net, ...) {
  UseMethod("AddUserData.actor", net)
}

#' @noRd
#' @export
AddUserData.actor.default <- function(net, ...) {
  stop("Unknown social media type passed to AddUserData.", call. = FALSE)
}

#' @title Supplement twitter actor network by adding user profile attributes to nodes
#'
#' @description Network is supplemented with additional downloaded user information applied as 2mode node attributes.
#'
#' @note Using the standard twitter API this function is limited to collecting profiles of 90000 users per 15 mins
#'   before hitting the rate limit.
#'
#' @param net A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.
#' @param data A dataframe generated by \code{Collect}.
#' @param lookupUsers Logical. Lookup user profile metadata using the twitter API for any users data missing from the
#'   collect data set. For example fetches profile information for users that became nodes during network creation
#'   because they were mentioned in a tweet but did not author any tweets themselves. Default is \code{FALSE}.
#' @param twitterAuth A twitter authentication object from \code{Authenticate}.
#' @param retryOnRateLimit Logical. When the API rate-limit is reached should the collection wait and resume when it
#'   resets. Default is \code{TRUE}.
#' @param refresh Logical. Lookup and replace all available user metadata. Default is \code{FALSE}.
#' @param rmMisc Logical. Remove miscellaneous user data columns such as user profile colors and other visual elements.
#'   Default is \code{TRUE}.
#' @param verbose Logical. Output additional information. Default is \code{FALSE}.
#' @param ... Additional parameters passed to function. Not used in this method.
#'
#' @examples
#' \dontrun{
#' # add user info to a twitter actor network
#' net_actor <- data_collect |>
#'   Create("actor") |>
#'   AddUserData(data_collect)
#' }
#'
#' @return Network as a named list of three dataframes containing \code{$nodes}, \code{$edges}. Nodes include columns
#'   for additional user profile data and metrics. Referenced users for which no data was found are returned in
#'   \code{missing_users}.
#'
#' @aliases AddUserData.actor.twitter
#' @name AddUserData.actor.twitter
#' @export
AddUserData.actor.twitter <-
  function(net,
           data,
           lookupUsers = FALSE,
           twitterAuth = NULL,
           retryOnRateLimit = TRUE,
           refresh = FALSE,
           rmMisc = TRUE,
           verbose = FALSE,
           ...) {

    res <- add_twitter_users(net$nodes, data, rmMisc)
    net$nodes <- res$objs
    net$missing_users <- res$missing_users

    if (lookupUsers) {
      if (refresh) {
        user_ids <- net$nodes$user_id
      } else {
        user_ids <- net$missing_users$user_id
      }

      df_users <- lookup_users(
        user_ids,
        auth = twitterAuth,
        retryonratelimit = retryOnRateLimit,
        ...
      ) |>
      dplyr::rename(user_id = .data$id_str)

      net$lookup_users <- df_users

      df_users_mod <- twitter_user_transforms(df_users, rm_misc = rmMisc) |>
        dplyr::distinct(.data$u.user_id, .keep_all = TRUE) |>
        dplyr::rename(user_id = .data$u.user_id)

      net$nodes <- net$nodes |>
        dplyr::rows_update(df_users_mod,
                           by = "user_id",
                           unmatched = "ignore")
    }

    class(net) <- union(class(net), c("voson.user"))
    msg("Done.\n")

    net
  }

#' @noRd
#' @method AddUserData twomode
#' @export
AddUserData.twomode <- function(net, ...) {
  UseMethod("AddUserData.twomode", net)
}

#' @noRd
#' @export
AddUserData.twomode.default <- function(net, ...) {
  stop("Unknown social media type passed to AddUserData.", call. = FALSE)
}

#' @title Supplement twitter 2mode network by adding user profile attributes to nodes
#'
#' @description Network is supplemented with additional downloaded user information applied as 2mode node attributes.
#'
#' @note Using the standard twitter API this function is limited to collecting profiles of 90000 users per 15 mins
#'   before hitting the rate limit.
#'
#' @param net A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.
#' @param data A dataframe generated by \code{Collect}.
#' @param lookupUsers Logical. Lookup user profile metadata using the twitter API for any users data missing from the
#'   collect data set. For example fetches profile information for users that became nodes during network creation
#'   because they were mentioned in a tweet but did not author any tweets themselves. Default is \code{FALSE}.
#' @param twitterAuth A twitter authentication object from \code{Authenticate}.
#' @param retryOnRateLimit Logical. When the API rate-limit is reached should the collection wait and resume when it
#'   resets. Default is \code{TRUE}.
#' @param refresh Logical. Lookup and replace all available user metadata. Default is \code{FALSE}.
#' @param rmMisc Logical. Remove miscellaneous user data columns such as user profile colors and other visual elements.
#'   Default is \code{TRUE}.
#' @param verbose Logical. Output additional information. Default is \code{FALSE}.
#' @param ... Additional parameters passed to function. Not used in this method.
#'
#' @examples
#' \dontrun{
#' # add user info to a twitter 2mode network
#' net_2mode <- data_collect |>
#'   Create("twomode") |>
#'   AddUserData(data_collect)
#' }
#'
#' @return Network as a named list of three dataframes containing \code{$nodes}, \code{$edges}. Nodes include columns
#'   for additional user profile data and metrics. Referenced users for which no data was found are returned in
#'   \code{missing_users}.
#'
#' @aliases AddUserData.twomode.twitter
#' @name AddUserData.twomode.twitter
#' @export
AddUserData.twomode.twitter <-
  function(net,
           data,
           lookupUsers = FALSE,
           twitterAuth = NULL,
           retryOnRateLimit = TRUE,
           refresh = FALSE,
           rmMisc = TRUE,
           verbose = FALSE,
           ...) {

    res <- add_twitter_users(net$nodes, data, rmMisc, by = "screen_name")
    net$nodes <- res$objs

    net$missing_users <- res$missing_users

    if (lookupUsers) {
      if (refresh) {
        user_ids <- net$nodes$screen_name
      } else {
        user_ids <- net$missing_users$screen_name
      }

      df_users <- lookup_users(
        user_ids,
        auth = twitterAuth,
        retryonratelimit = retryOnRateLimit,
        ...) |>
      dplyr::rename(user_id = .data$id_str)

      net$lookup_users <- df_users

      df_users_mod <- twitter_user_transforms(df_users, rm_misc = rmMisc) |>
        dplyr::distinct(.data$u.user_id, .keep_all = TRUE) |>
        dplyr::rename(user_id = .data$u.user_id) |>
        dplyr::mutate(screen_name = tolower(.data$u.screen_name), u.screen_name = NULL)

      # if screen_name
      net$nodes <- net$nodes |>
        dplyr::rows_update(df_users_mod,
                           by = "screen_name",
                           unmatched = "ignore")
    }

    class(net) <- union(class(net), c("voson.user"))
    msg("Done.\n")

    net
  }

# add twitter users to dataframe
add_twitter_users <- function(objs, data, rm, by = "user_id") {
  if (check_df_n(data$users) < 1) {
    stop("No user data found.", call. = FALSE)
  }

  users <- data$users |>
    twitter_user_transforms(rm_misc = rm)

  qs_users <- extract_nested_twitter_users(data$tweets, "qs") |>
    twitter_user_transforms(rm_misc = rm)

  rts_users <- extract_nested_twitter_users(data$tweets, "rts") |>
    twitter_user_transforms(rm_misc = rm)

  all_users <- dplyr::bind_rows(users, qs_users, rts_users) |>
    dplyr::distinct(.data$u.user_id, .keep_all = TRUE)

  actor_ids <- objs |>
    dplyr::select(.data$user_id, .data$screen_name) |>
    dplyr::filter(!is.na(.data$user_id) | !is.na(.data$screen_name))

  if (by == "screen_name") {
    actor_ids <- actor_ids |> dplyr::mutate(screen_name = tolower(.data$screen_name))

    missing_user_data <-
      dplyr::anti_join(
        actor_ids,
        all_users |>
          dplyr::select(.data$u.user_id, .data$u.screen_name) |>
          dplyr::mutate(u.screen_name = tolower(.data$u.screen_name)),
        by = c("screen_name" = "u.screen_name")
      )

    objs <- objs |>
      dplyr::mutate(screen_name = tolower(.data$screen_name)) |>
      dplyr::left_join(
        all_users |> dplyr::mutate(u.screen_name = tolower(.data$u.screen_name)),
        by = c("screen_name" = "u.screen_name"),
        na_matches = "never",
        keep = TRUE
      )
  } else {
    missing_user_data <-
      dplyr::anti_join(
        actor_ids,
        all_users |> dplyr::select(.data$u.user_id),
        by = c("user_id" = "u.user_id")
      )

    objs <- objs |>
      dplyr::left_join(all_users, by = c("user_id" = "u.user_id"), na_matches = "never", keep = TRUE)
  }

  list(objs = objs, missing_users = missing_user_data)
}

# extract users from nested tweet fields
extract_nested_twitter_users <- function(x, var) {
  x <- x |>
    dplyr::select({{ var }}) |>
    tidyr::unnest(cols = c({{ var }}))

  if (!"user" %in% names(x)) {
    return(NULL)
  }

  x <- x |>
    dplyr::select(.data$user) |>
    tidyr::unnest(cols = c(.data$user)) |>
    dplyr::filter(!is.na(.data$id_str)) |>
    dplyr::rename(user_id = .data$id_str)

  x
}

# transform tweet user data
twitter_user_transforms <- function(x, rm_misc = TRUE) {
  if (is.null(x)) return(x)

  if (!"user_id" %in% names(x)) {
    x <- x |> dplyr::rename(user_id = .data$id_str)
  }

  # drop the following columns
  if (rm_misc) {
    x <- x |>
      dplyr::select(
        -.data$id,
        -.data$entities,
        -dplyr::starts_with(
          c(
            "contributors_enabled",
            "follow_request_sent",
            "following",
            # "geo_enabled",
            # "has_extended_profile",
            "is_translation_enabled",
            "is_translator",
            # "lang",
            "notifications",
            "profile_background_color",
            "profile_background_image_url",
            "profile_background_image_url_https",
            "profile_background_tile",
            "profile_image_url",
            "profile_link_color",
            "profile_sidebar_border_color",
            "profile_sidebar_fill_color",
            "profile_text_color",
            "profile_use_background_image",
            # "time_zone",
            "translator_type"
            # "utc_offset"
          )
      ))
  } else {
    x$entities <- list(x$entities)
  }

  api_dt_fmt <- twitter_api_dt_fmt()

  x <- x |>
    dplyr::mutate(
      created_at = ifelse(
        is.na(.data$created_at),
        NA_character_,
        as.character(as.POSIXct(.data$created_at, format = api_dt_fmt, tz = "UTC"))
      )
    ) |>
    dplyr::mutate_at(dplyr::vars("created_at"), lubridate::as_datetime, tz = "UTC") |>
    dplyr::rename_with(function(x) paste0("u.", x))

  x
}

# rtweet user lookup
lookup_users <- function(x, auth, retryonratelimit = TRUE, ...) {
  prompt_and_stop("rtweet", "lookupUsers")

  df_lookup_data <-
    rtweet::lookup_users(
      x,
      parse = TRUE,
      token = auth$auth,
      retryonratelimit = retryonratelimit,
      ...
    )

  df_lookup_data
}
