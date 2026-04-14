#' Validate user-supplied file or directory path
#'
#' @param x Path.
#' @param files Expected CRU files.
#'
#' @returns Absolute validated path.
#' @dev

.validate_x <- function(x, files) {
  x <- fs::path_abs(fs::path_norm(trimws(x)))

  # Case 1: directory
  if (fs::is_dir(x)) {
    return(x)
  }

  # Case 2: must be a single .gz file
  if (fs::path_ext(x) != "gz") {
    cli::cli_abort(
      "{.var x} must be either a directory or a .gz file.",
      call = rlang::caller_env()
    )
  }

  dir <- fs::path_dir(x)

  # Directory must exist
  if (!fs::dir_exists(dir)) {
    cli::cli_abort(
      "The directory for {.var x} does not exist: {dir}.",
      call = rlang::caller_env()
    )
  }

  # If multiple variables requested → treat x as directory
  if (length(files) > 1L) {
    cli::cli_warn(
      c(
        "You supplied a single file {.var x} but requested multiple variables.",
        "Interpreting the path at the directory level instead.",
        "All matching files in {dir} will be considered."
      ),
      call = rlang::caller_env()
    )
    return(dir)
  }

  # Valid single .gz file
  return(x)
}
