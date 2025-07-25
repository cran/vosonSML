#' @title Create an igraph graph from network
#'
#' @param net A named list of dataframes \code{nodes} and \code{edges} generated by \code{Create}.
#' @param directed Logical. Create a directed graph. Default is \code{TRUE}.
#' @param ... Additional parameters passed to function. Not used in this method.
#' @param writeToFile Logical. Save graph to a file in the current working directory. Default is \code{FALSE}.
#' @param verbose Logical. Output additional information. Default is \code{TRUE}.
#'
#' @return An igraph object.
#'
#' @aliases Graph
#' @name Graph
#' @export
Graph <- function(net,
                  directed = TRUE,
                  ...,
                  writeToFile = FALSE,
                  verbose = TRUE) {
  
  prompt_and_stop("igraph", "Graph")

  type <- get_media_cls(class(net))
  
  g <- igraph::graph_from_data_frame(d = net$edges, directed = directed, vertices = net$nodes)
  g <- igraph::set_graph_attr(g, "type", type)
  
  graphOutputFile(g, "graphml", writeToFile, paste0(stringr::str_to_title(type), "Activity"), verbose = verbose)
  
  g
}

# set output file name
# if wtof is logical use def as file name
# if character use wtof as file name
graphOutputFile <- function(g, type, wtof, def, verbose = TRUE) {

  if (is.logical(wtof) && wtof) {
    write_output_file(g, "graphml", def, verbose = verbose)

  } else if (is.character(wtof)) {
    write_output_file(g, "graphml", wtof, verbose = verbose)
  }
}

get_media_cls <- function(x) {
  if ("mastodon" %in% x) return("mastodon")
  if ("reddit" %in% x) return("reddit")
  if ("youtube" %in% x) return("youtube")
  if ("web" %in% x) return("web")
  "default"
}
