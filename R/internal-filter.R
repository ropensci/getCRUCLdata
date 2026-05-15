#' Filter CRU file names based on selected variables
#'
#' @param vars Named logical vector.
#'
#' @returns Character vector of file names.
#' @autoglobal
#' @dev

.filter_files <- function(vars) {
  vars <- .normalize_vars(vars)

  file_vars <- intersect(names(vars)[vars], names(.cru_files))
  .cru_files[file_vars]
}

#' Validate and filter CRU file selections
#'
#' @param vars Named logical vector.
#' @param x Optional path.
#'
#' @returns Character vector of file names.
#' @dev
.validate_filter_files <- function(vars, x) {
  .check_vars(vars)
  .filter_files(vars) # just names, no paths
}
