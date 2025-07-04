#' @title Create web actor network
#'
#' @description Creates a web page domain network from pages. Nodes are site domains.
#'
#' @param datasource Collected social media data with \code{"datasource"} and \code{"web"} class names.
#' @param type Character string. Type of network to be created, set to \code{"activity"}.
#' @param ... Additional parameters passed to function. Not used in this method.
#' @param writeToFile Logical. Write data to file. Default is \code{FALSE}.
#' @param verbose Logical. Output additional information. Default is \code{TRUE}.
#'
#' @return Network as a named list of two dataframes containing \code{$nodes} and \code{$edges}.
#'
#' @examples
#' \dontrun{
#' # create a web actor network graph
#' net_activity <- data_collect |> Create("actor")
#'
#' # network
#' # net_activity$nodes
#' # net_activity$edges
#' }
#'
#' @export
Create.actor.web <- function(datasource, type, ..., writeToFile = FALSE, verbose = TRUE) {
  msg("Generating web actor network...")

  edges <- datasource |>
    dplyr::mutate(from = urltools::domain(tolower(.data$page)), to = tolower(.data$parse$domain)) |>
    dplyr::select(.data$from, .data$to)

  nodes <- tibble::tibble(id = unique(c(edges$from, edges$to)))
  nodes <- nodes |> dplyr::arrange(.data$id)

  net <- list("nodes" = nodes, "edges" = edges)
  class(net) <- append(class(net), c("network", "actor", "web"))
  
  if (writeToFile) write_output_file(net, "rds", "WebActorNet", verbose = verbose)
  
  msg("Done.\n")

  net
}
