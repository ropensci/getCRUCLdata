
#' @title Manage locally cached CRU CL v. 2.0 files
#'
#' @description Manage cached `getCRUCLdata` files with \pkg{hoardr}
#'
#' @export
#' @name CRU_cache
#'
#' @details The default cache directory is
#' \code{file.path(rappdirs::user_cache_dir(), "R/getCRUCLdata")}, but you can
#' set your own path using \code{cache_path_set()}
#'
#' \code{cache_delete} only accepts one file name, while \code{cache_delete_all}
#' does not accept any names, but deletes all files. For deleting many specific
#' files, use \code{cache_delete} in an \code{\link[base]{lapply}()} type call.
#'
#' @section Useful user functions:
#' \itemize{
#'  \item \code{CRU_cache$cache_path_get()} - get cache path
#'  \item \code{CRU_cache$cache_path_set()} - set cache path
#'  \item \code{CRU_cache$list()} - returns a character vector of full
#'  path file names
#'  \item \code{CRU_cache$files()} - returns file objects with metadata
#'  \item \code{CRU_cache$details()} - returns files with details
#'  \item \code{CRU_cache$delete()} - delete specific files
#'  \item \code{CRU_cache$delete_all()} - delete all files, returns
#'  nothing
#' }
#'
#' @examples \dontrun{
#'
#' # list files in cache
#' CRU_cache$list()
#'
#' # delete certain database files
#' CRU_cache$delete("file path")
#' CRU_cache$list()
#'
#' # delete all files in cache
#' CRU_cache$delete_all()
#' CRU_cache$list()
#'
#' # set a different cache path from the default
#' CRU_cache$cache_path_set("~/tmp")
#' }
NULL
