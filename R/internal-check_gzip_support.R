#' Ensure gzip support is available for reading .gz files
#'
#' Internal helper used by both .tidy_dt() and .create_rast().
#'
#' Aborts if .gz files are present and neither R.utils nor system gzip
#' is available.
#'
#' @param files Character vector of file paths.
#' @dev

.check_gzip_support <- function(files) {
  # Only relevant for character vectors containing .gz files
  if (!is.character(files) || !any(grepl("\\.gz$", files))) {
    return(invisible(TRUE))
  }

  # Check for either R.utils or system gzip
  if (
    !requireNamespace("R.utils", quietly = TRUE) &&
      Sys.which("gzip") == ""
  ) {
    cli::cli_abort(
      c(
        x = "Cannot read compressed `.gz` files.",
        i = "Package {.pkg R.utils} is not installed.",
        i = "System {.code gzip} command not found.",
        "Install {.pkg R.utils} with {.code install.packages('R.utils')}."
      )
    )
  }

  invisible(TRUE)
}
