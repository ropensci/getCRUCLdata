#' Manage locally cached CRU CL v. 2.0 files
#'
#' Manage cached \pkg{getCRUCLdata} files with \CRANpkg{hoardr}.
#'
#' @export
#' @name manage_cache
#'
#' @details The default cache directory is
#' `tools::R_user_dir(package = "getCRUCLdata")`, but you can set your own path
#' using `manage_cache$cache_path_set()`.
#'
#' `manage_cache$cache_delete` only accepts one file name, while
#' `manage_cache$cache_delete_all`
#' does not accept any names, but deletes all files. For deleting many specific
#' files, use `manage_cache$cache_delete` in an [base::lapply] type call.
#'
#' @section Useful user functions:
#' \describe{
#'  \item{`manage_cache$cache_path_get()`}{get cache path}
#'  \item{`manage_cache$cache_path_set()`}{set cache path}
#'  \item{`manage_cache$list()`}{returns a character vector of full
#'  path file names}
#'  \item{`manage_cache$files()`}{returns file objects with metadata}
#'  \item{`manage_cache$details()`}{returns files with details}
#'  \item{`manage_cache$delete()`}{delete specific files}
#'  \item{`manage_cache$delete_all()`}{delete all files, returns
#'  nothing}
#' }
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @examples \dontrun{
#'
#' # list files in cache
#' manage_cache$list()
#'
#' # delete certain database files
#' manage_cache$delete("file path")
#' manage_cache$list()
#'
#' # delete all files in cache
#' manage_cache$delete_all()
#' manage_cache$list()
#'
#' # set a different cache path from the default
#' manage_cache$cache_path_set("~/tmp")
#' }
NULL
