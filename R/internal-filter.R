#' Filter CRU file names based on selected variables
#'
#' @param vars Named logical vector.
#'
#' @returns Character vector of file names.
#' @dev

.filter_files <- function(vars) {
  CRU_FILES <- c(
    pre = "grid_10min_pre.dat.gz",
    rd0 = "grid_10min_rd0.dat.gz",
    tmp = "grid_10min_tmp.dat.gz",
    dtr = "grid_10min_dtr.dat.gz",
    reh = "grid_10min_reh.dat.gz",
    sunp = "grid_10min_sunp.dat.gz",
    frs = "grid_10min_frs.dat.gz",
    wnd = "grid_10min_wnd.dat.gz",
    elv = "grid_10min_elv.dat.gz"
  )

  vars <- .normalize_vars(vars)

  file_vars <- intersect(names(vars)[vars], names(CRU_FILES))
  CRU_FILES[file_vars]
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
