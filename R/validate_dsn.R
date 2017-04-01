#' @noRd
.validate_dsn <- function(dsn) {
  if (is.null(dsn)) {
    stop("You must define the dsn where you have stored the local files
         for import. If you want to download files using R, use one of the
         'get_CRU_*()' functions provided.")
  } else {
    dsn <- trimws(dsn)
    if (substr(dsn, nchar(dsn) - 1, nchar(dsn)) == "//") {
      p <- substr(dsn, 1, nchar(dsn) - 2)
    } else if (substr(dsn, nchar(dsn), nchar(dsn)) == "/" |
               substr(dsn, nchar(dsn), nchar(dsn)) == "\\") {
      p <- substr(dsn, 1, nchar(dsn) - 1)
    } else {
      p <- dsn
    }
    if (!file.exists(p) & !file.exists(dsn)) {
      stop("\nFile directory does not exist: ", dsn, ".\n")
    }
  }
}
