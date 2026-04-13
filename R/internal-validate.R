#' Validate user-supplied file or directory path
#'
#' @param x Path.
#' @param files Expected CRU files.
#'
#' @returns Absolute validated path.
#' @dev

.validate_x <- function(x, files) {
  x <- fs::path_abs(fs::path_norm(trimws(x)))

  # Case 1: x is a directory
  if (fs::is_dir(x)) {
    return(x)
  }

  # Case 2: x is a single .gz file
  ext <- fs::path_ext(x)

  if (ext == "gz") {
    dir <- fs::path_dir(x)

    if (!fs::dir_exists(dir)) {
      cli::cli_abort(
        "The directory for {.var x} does not exist: {dir}.",
        call = rlang::caller_env()
      )
    }

    if (length(files) > 1L) {
      cli::cli_warn(
        c(
          "You supplied a single file {.var x} but requested multiple 
          variables.",
          "The path will be interpreted at the directory level instead.",
          "All matching files in {dir} will be considered."
        ),
        call = rlang::caller_env()
      )
      return(dir)
    }

    return(x)
  }

  cli::cli_abort(
    "{.var x} must be either a directory or a .gz file.",
    call = rlang::caller_env()
  )
}
