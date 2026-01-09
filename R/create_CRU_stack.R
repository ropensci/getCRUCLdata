#' Create a list of terra rast objects of CRU CL v. 2.0 climatology elements from local disk files
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @examplesIf interactive()
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' cru_tmp <- create_CRU_stack(dsn = tempdir(), tmp = TRUE)
#'
#' # ->
#'
#' f <- fs::path(fs::temp_path(), "grid_10min_tmp.dat.gz")
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE, x = f)
#' @keywords internal

create_CRU_rast <- function(
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
  lifecycle::deprecate_warn("2.0.0", "create_CRU_rast()", "read_cru_rast()")
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

  files <- .read_local_files(
    .files = c(pre, rd0, tmp, dtr, reh, tmn, tmx, sunp, frs, wnd, elv),
    .pre_cv = pre_cv
  )

  if (length(files) == 0) {
    cli::cli_abort(
      "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
    )
  }

  return(.create_rasts(tmn, tmx, tmp, dtr, pre, pre_cv, files))
}
