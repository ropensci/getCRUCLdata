#' Create a data.table of CRU CL v. 2.0 climatology elements from local disk files
#'
#' @description
#' `r lifecycle::badge('deprecated')`
#'
#' This function has been deprecated in version 2.0.0 to simplify the
#'  functionality. Please use `read_cru_dt()`.
#'
#' @examplesIf interactive()
#' # Create a data frame of temperature from locally available files in the
#' # tempdir() directory.
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' CRU_tmp <- create_CRU_df(tmp = TRUE, dsn = tempdir())
#'
#' # ->
#' library(fs)
#' f <- path(temp_path(), "grid_10min_tmp.dat.gz")
#'
#' cru_tmp <- read_cru_dt(tmp = TRUE, x = f)
#'
#' @export
create_CRU_df <- function(
  dsn,
  pre = FALSE,
  pre_cv = FALSE,
  rd0 = FALSE,
  tmp = FALSE,
  dtr = FALSE,
  reh = FALSE,
  tmn = FALSE,
  tmx = FALSE,
  sunp = FALSE,
  frs = FALSE,
  wnd = FALSE,
  elv = FALSE
) {
  lifecycle::deprecate_warn("2.0.0", "create_CRU_df()", "read_cru_dt()")
  .check_vars(
    pre,
    pre_cv,
    rd0,
    tmp,
    dtr,
    reh,
    tmn,
    tmx,
    sunp,
    frs,
    wnd,
    elv
  )

  .validate_x(dsn)

  files <- fs::dir_ls(dsn, regexp = "\\.dat\\.gz$", recurse = FALSE)

  if (length(files) == 0L) {
    cli::cli_abort(
      "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
    )
  }

  return(.create_dt(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
}
