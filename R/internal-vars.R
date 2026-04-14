#' Check that at least one variable is requested
#'
#' @param vars Named logical vector of CRU variable selections.
#'
#' @returns Invisible NULL.
#' @dev

.check_vars <- function(vars) {
  if (is.null(vars) || !is.logical(vars)) {
    cli::cli_abort("Internal error: vars must be a logical vector.")
  }

  if (!any(vars)) {
    cli::cli_abort(
      "You must select at least one element for download or import."
    )
  }

  invisible(TRUE)
}

#' Normalize dependent CRU variable selections
#'
#' @param vars Named logical vector.
#'
#' @returns Normalized logical vector.
#' @dev

.normalize_vars <- function(vars) {
  # pre_cv implies pre
  vars["pre"] <- vars["pre"] || vars["pre_cv"]

  # tmn/tmx imply tmp + dtr
  need_temp <- vars["tmn"] || vars["tmx"]
  vars["tmp"] <- vars["tmp"] || need_temp
  vars["dtr"] <- vars["dtr"] || need_temp

  vars
}
