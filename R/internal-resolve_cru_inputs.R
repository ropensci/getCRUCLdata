#' Resolve CRU variable flags and input file paths
#'
#' Internal helper used by higher-level CRU readers to convert user-facing
#' arguments (e.g., `pre = TRUE`, `tmp = TRUE`, `x = <dir>`) into a standardised
#' structure containing:
#'
#' * a named logical vector of requested CRU variables (`vars`)
#' * a character vector of file paths (`files`)
#'
#' If `x` is a directory, all matching CRU files (`grid_10min_*.dat.gz`) inside
#' that directory are returned.
#' If `x` is one or more file paths, they are returned unchanged.
#'
#' This function does **not** read or validate file contents; it only resolves
#' which files should be processed downstream.
#'
#' @param pre Logical. Whether precipitation (`pre`) is requested.
#' @param tmp Logical. Whether temperature (`tmp`) is requested.
#' @param x Character. Either a directory containing CRU files or one or more
#'   CRU `.dat.gz` file paths.
#' @param ... Ignored. Allows future expansion.
#'
#' @return A list with two elements:
#' \describe{
#'   \item{vars}{Named logical vector of CRU variable flags.}
#'   \item{files}{Character vector of resolved CRU file paths.}
#' }
#'
#' @dev

.resolve_cru_inputs <- function(pre = FALSE, tmp = FALSE, x = NULL, ...) {
  vars <- c(
    pre = pre,
    tmp = tmp,
    dtr = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    pre_cv = FALSE,
    reh = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  # If x is a directory → list files
  files <- c(
    fs::dir_ls(x[fs::is_dir(x)], regexp = "grid_10min_.*\\.dat\\.gz$"),
    x[!fs::is_dir(x)]
  )

  return(list(vars = vars, files = files))
}
