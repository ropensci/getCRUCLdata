#' Download and create a data.table of CRU CL v. 2.0 climatology elements
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @examplesIf interactive()
#' # Download data and create a data frame of precipitation and temperature
#' cru_pre_tmp <- get_cru_df(pre = TRUE, tmp = TRUE)
#'
#' @keywords internal

get_cru_df <- function(
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

  files <- .get_cru(
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

  return(.create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
}
