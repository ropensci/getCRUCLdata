#' @title Manage cached CRU CL 2.0 files
#'
#' @description The user is given an option when downloading the CRU CL2.0 data
#' to cache or not to cache the data for later use. If \code{cache == TRUE},
#' then the CRU CL2.0 data files are saved in a directory in the users' home
#' filespace. These functions provide facilities for interacing and managing
#' these files.
#'
#' @export
#' @name manage_CRU_cache
#' @param files Character. One or more complete file names
#' @param force Logical. Should files be force deleted? Defaults to :
#' \code{TRUE}
#'
#' @details \code{cache_delete} only accepts one file name, while
#' \code{cache_delete_all} doesn't accept any names, but deletes all files.
#' For deleting many specific files, use \code{cache_delete} in a
#' \code{\link{lapply}} type call.
#'
#' We files cache using \code{\link[rappdirs]{user_cache_dir}}, find your
#' cache folder by executing \code{rappdirs::user_cache_dir("getCRUCLdata")}
#'
#' @section Functions:
#' \itemize{
#'  \item \code{CRU_cache_list()} returns a character vector of full path file
#'  names
#'  \item \code{CRU_cache_delete()} deletes one or more files, returns nothing
#'  \item \code{CRU_cache_delete_all()} delete all files, returns nothing
#'  \item \code{CRU_cache_details()} prints file name and file size for each
#'  file, supply with one or more files, or no files (and get details for
#'  all available)
#' }
#'
#' @examples \dontrun{
#' # List files in cache
#' CRU_cache_list()
#'
#' # List info for single files
#' CRU_cache_details(files = CRU_cache_list()[1])
#' CRU_cache_details(files = CRU_cache_list()[2])
#'
#' # List info for all files
#' CRU_cache_details()
#'
#' # Delete files by name in cache
#' CRU_cache_delete(files = CRU_cache_list()[1])
#'
#' # Delete all files in cache
#' CRU_cache_delete_all()
#' }

#' @export
#' @rdname manage_CRU_cache
CRU_cache_list <- function() {
  cache_dir <- rappdirs::user_config_dir("getCRUdata")
  list.files(cache_dir, ignore.case = TRUE, include.dirs = TRUE,
             recursive = TRUE, full.names = TRUE)
}

#' @export
#' @rdname manage_CRU_cache
CRU_cache_delete <- function(files, force = TRUE) {
  if (!all(file.exists(files))) {
    stop("These files don't exist or can't be found: \n",
         strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
  }
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname manage_CRU_cache
CRU_cache_delete_all <- function(force = TRUE) {
  cache_dir <- rappdirs::user_config_dir("getCRUdata")
  files <- list.files(cache_dir, ignore.case = TRUE, include.dirs = TRUE,
                      full.names = TRUE, recursive = TRUE)
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname manage_CRU_cache
CRU_cache_details <- function(files = NULL) {
  cache_dir <- rappdirs::user_config_dir("getCRUdata")
  if (is.null(files)) {
    files <- list.files(cache_dir, ignore.case = TRUE, include.dirs = TRUE,
                        full.names = TRUE, recursive = TRUE)
    structure(lapply(files, file_info_), class = "CRU_cache_info")
  } else {
    structure(lapply(files, file_info_), class = "CRU_cache_info")
  }
}

file_info_ <- function(x) {
  if (file.exists(x)) {
    fs <- file.size(x)
  } else {
    fs <- type <- NA
    x <- paste0(x, " - does not exist")
  }
  list(file = x,
       type = "tif",
       size = if (!is.na(fs)) getsize(fs) else NA
  )
}

getsize <- function(x) {
  round(x/10 ^ 6, 3)
}

#' @export
print.CRU_cache_info <- function(x, ...) {
  cache_dir <- rappdirs::user_config_dir("getCRUdata")
  cat("<CRU CL2.0 cached files>", sep = "\n")
  cat(sprintf("  directory: %s\n", cache_dir), sep = "\n")
  for (i in seq_along(x)) {
    cat(paste0("  file: ", sub(cache_dir, "", x[[i]]$file)), sep = "\n")
    cat(paste0("  size: ", x[[i]]$size, if (is.na(x[[i]]$size)) "" else " mb"),
        sep = "\n")
    cat("\n")
  }
}
