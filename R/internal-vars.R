#' Check that at least one variable is requested
#'
#' @param vars Named logical vector of CRU variable selections.
#'
#' @returns Invisible NULL.
#' @dev

.check_vars <- function(vars) {
  if (!is.logical(vars) || is.null(vars)) {
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
  if (vars["pre_cv"]) {
    vars["pre"] <- TRUE
  }
  if (vars["tmn"] || vars["tmx"]) {
    vars[c("tmp", "dtr")] <- TRUE
  }
  vars
}
