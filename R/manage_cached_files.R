
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
#'  \item \code{CRU_cachecache_path_get()} - get cache path
#'  \item \code{CRU_cachecache_path_set()} - set cache path
#'  \item \code{CRU_cachelist()} - returns a character vector of full
#'  path file names
#'  \item \code{CRU_cachefiles()} - returns file objects with metadata
#'  \item \code{CRU_cachedetails()} - returns files with details
#'  \item \code{CRU_cachedelete()} - delete specific files
#'  \item \code{CRU_cachedelete_all()} - delete all files, returns
#'  nothing
#' }
#'
#' @examples \dontrun{
#' CRU_cache
#'
#' # list files in cache
#' CRU_cachelist()
#'
#' # delete certain database files
#' # CRU_cachedelete("file path")
#' # CRU_cachelist()
#'
#' # delete all files in cache
#' # CRU_cachedelete_all()
#' # CRU_cachelist()
#'
#' # set a different cache path from the default
#' }
NULL
