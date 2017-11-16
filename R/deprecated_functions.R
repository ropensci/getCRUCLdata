
#' Deprecated function(s) in the getCRUCLdata package
#'
#' These functions are now deprecated in \pkg{getCRUCLdata}.
#'
#' @docType package
#' @section Details:
#' \tabular{rl}{
#'   \code{CRU_cache_list} \tab now superceded by \code{manage_cache$list}\cr
#'   \code{CRU_cache_details} \tab now superceded by \code{manage_cache$details}\cr
#'   \code{CRU_cache_delete} \tab now superceded by \code{manage_cache$delete}\cr
#'   \code{CRU_cache_delete_all} \tab now superceded by \code{manage_cache$delete_all }\cr
#' }
#'
#' @rdname getCRUCLdata-deprecated
#' @name getCRUCLdata-deprecated
#' @export
CRU_cache_list <- function() {
  .Deprecated("manage_cache$list", package = "getCRUCLdata")
}

#' @rdname getCRUCLdata-deprecated
#' @name getCRUCLdata-deprecated
#' @export
CRU_cache_details <- function() {
  .Deprecated("manage_cache$details", package = "getCRUCLdata")
}

#' @rdname getCRUCLdata-deprecated
#' @name getCRUCLdata-deprecated
#' @export
CRU_cache_delete <- function() {
  .Deprecated("manage_cache$delete", package = "getCRUCLdata")
}

#' @rdname getCRUCLdata-deprecated
#' @name getCRUCLdata-deprecated
#' @export
CRU_cache_delete_all <- function() {
  .Deprecated("manage_cache$delete_all", package = "getCRUCLdata")
}

NULL
