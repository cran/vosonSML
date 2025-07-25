#' @title Create YouTube activity network
#'
#' @description Creates an activity network from collected YouTube video comment threads. Nodes are top-level comments,
#'   reply comments and videos. Edges are directed between the nodes and represent commenting activity.
#'
#' @param datasource Collected social media data with \code{"datasource"} and \code{"youtube"} class names.
#' @param type Character string. Type of network to be created, set to \code{"activity"}.
#' @param ... Additional parameters passed to function. Not used in this method.
#' @param writeToFile Logical. Write data to file. Default is \code{FALSE}.
#' @param verbose Logical. Output additional information. Default is \code{TRUE}.
#'
#' @return Network as a named list of two dataframes containing \code{$nodes} and \code{$edges}.
#'
#' @examples
#' \dontrun{
#' # create a YouTube activity network graph
#' activityNetwork <- youtubeData |> Create("activity")
#'
#' # network
#' # activityNetwork$nodes
#' # activityNetwork$edges
#' }
#'
#' @export
Create.activity.youtube <- function(datasource, type, ..., writeToFile = FALSE, verbose = TRUE) {
    msg("Generating youtube activity network...\n")

    df_stats <- network_stats(NULL, "collected YouTube comments", nrow(datasource))
    
    # edges
    df_relations <-
      datasource |> dplyr::select(.data$CommentID, .data$ParentID, .data$VideoID) |>
      dplyr::mutate(edge_type = dplyr::case_when((!is.na(.data$ParentID)) ~ "reply-comment", TRUE ~ "comment")) |>
      dplyr::mutate(
        to = dplyr::if_else(
          .data$edge_type == "reply-comment",
          .data$ParentID,
          dplyr::if_else(
            .data$edge_type == "comment",
            paste0("VIDEOID:", .data$VideoID),
            as.character(NA)
          )
        )
      ) |>
      dplyr::rename(from = .data$CommentID) |>
      dplyr::select(.data$from, .data$to, .data$edge_type)

    # nodes
    df_nodes <-
      datasource |> dplyr::select(
        .data$CommentID,
        .data$VideoID,
        .data$ParentID,
        .data$PublishedAt,
        .data$UpdatedAt,
        .data$AuthorChannelID,
        .data$AuthorDisplayName
      ) |>
      dplyr::mutate(node_type = dplyr::case_when((!is.na(.data$ParentID)) ~ "reply-comment", TRUE ~ "comment"))

    # add unique parent ids not already in node list
    parent_ids <-
      dplyr::distinct(df_nodes, .data$ParentID) |> dplyr::filter(!is.na(.data$ParentID)) |>
      dplyr::rename(CommentID = .data$ParentID) |>
      dplyr::mutate(node_type = "comment") # node type for parent ids are comment

    if (nrow(parent_ids)) {
      df_nodes <-
        dplyr::bind_rows(df_nodes,
                         dplyr::anti_join(parent_ids, df_nodes, by = "CommentID"))
    }

    # add unique video ids not already in node list
    video_ids <-
      dplyr::distinct(df_nodes, .data$VideoID) |> dplyr::rename(CommentID = .data$VideoID) |>
      dplyr::mutate(node_type = "video")
    video_ids$CommentID <- paste0("VIDEOID:", video_ids$CommentID)

    if (nrow(video_ids)) {
      df_nodes <-
        dplyr::bind_rows(df_nodes,
                         dplyr::anti_join(video_ids, df_nodes, by = "CommentID"))
    }

    df_nodes <-
      dplyr::select(
        df_nodes,
        .data$CommentID,
        .data$VideoID,
        .data$PublishedAt,
        .data$UpdatedAt,
        .data$AuthorChannelID,
        .data$AuthorDisplayName,
        .data$node_type
      ) |>
      dplyr::mutate_at(dplyr::vars(dplyr::contains("At")), as.character) |>
      dplyr::rename(
        id = .data$CommentID,
        video_id = .data$VideoID,
        published_at = .data$PublishedAt,
        updated_at = .data$UpdatedAt,
        author_id = .data$AuthorChannelID,
        screen_name = .data$AuthorDisplayName
      )

    node_summary <-
      df_nodes |> dplyr::group_by(.data$node_type) |>
      dplyr::summarise(num = dplyr::n())

    for (row in 1:nrow(node_summary)) {
      type <- node_summary[row, "node_type"]
      if (type == "comment")
        df_stats <-
          network_stats(df_stats, "top-level comments", node_summary[row, "num"])
      else if (type == "reply-comment")
        df_stats <-
          network_stats(df_stats, "reply comments", node_summary[row, "num"])
      else if (type == "video")
        df_stats <-
          network_stats(df_stats, "videos", node_summary[row, "num"])
    }
    df_stats <- network_stats(df_stats, "nodes", nrow(df_nodes))
    df_stats <- network_stats(df_stats, "edges", nrow(df_relations))

    # print stats
    msg(network_stats(df_stats, print = TRUE))

    net <- list("edges" = df_relations, "nodes" = df_nodes)
    class(net) <- append(class(net), c("network", "activity", "youtube"))
    
    if (writeToFile) write_output_file(net, "rds", "YoutubeActivityNet", verbose = verbose)
    
    msg("Done.\n")

    net
  }
