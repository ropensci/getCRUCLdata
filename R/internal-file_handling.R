#' Resolve CRU file handling for local or remote sources
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file names.
#' @param x Optional path.
#'
#' @returns List with vars and files.
#' @dev
#'

.file_handling <- function(vars, files, x) {
  vars <- .normalize_vars(vars)

  # remote case: x is NULL → build URLs and download
  if (is.null(x)) {
    base <- "https://crudata.uea.ac.uk/cru/data/hrg/tmc"
    urls <- fs::path(base, files)
    dest <- fs::path_temp(fs::path_file(files))

    mapply(
      FUN = .retry_download,
      url = urls,
      dest = dest,
      SIMPLIFY = TRUE,
      USE.NAMES = FALSE
    )

    return(list(vars = vars, files = dest))
  }

  # local case: x is a directory or a single file
  x <- fs::path_abs(fs::path_norm(trimws(x)))

  if (fs::is_dir(x)) {
    # expect files inside directory x
    expected <- fs::path(x, files)
    existing <- expected[fs::file_exists(expected)]

    if (!length(existing)) {
      cli::cli_abort(
        "No CRU CL 2.0 data files were found in {.var x} = {x}.",
        call = rlang::caller_env()
      )
    }

    return(list(vars = vars, files = existing))
  }

  # x is a single .gz file
  if (fs::path_ext(x) == "gz") {
    if (!fs::file_exists(x)) {
      cli::cli_abort(
        "The file {.var x} does not exist: {x}.",
        call = rlang::caller_env()
      )
    }

    return(list(vars = vars, files = x))
  }

  cli::cli_abort(
    "{.var x} must be either a directory or a .gz file.",
    call = rlang::caller_env()
  )
}
