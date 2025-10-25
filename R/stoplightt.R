

#' Tidy version of stop_if_not which respects grouping variables
#' @param .data a data frame
#' @param ... arguments passed to \link{stopifnot}
#' @description
#' \code{stoplight} allows you to do assertive programming in a tidy manner
#' @example inst/stoplight-example.R
#' @export
stoplight <- function(.data, ...){

  statements <- rlang::quos(...)

  dplyr::mutate(.data, stopifnot(!!!statements))

  return(.data)
}
