#' Download and create a list of terra rast objects of CRU CL v. 2.0 climatology elements
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @examplesIf interactive()
#'
#' # Download data and create a list of {terra} `rast` objects of precipitation
#' # and temperature without caching the data files
#' cru_pre_tmp <- get_cru_rast(pre = TRUE, tmp = TRUE)
#'
#' cru_pre_tmp
#'
#' @keywords internal

get_cru_rast <-
  function(
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

    if (pre_cv) {
      pre <- TRUE
    }

    return(.create_rasts(tmn, tmx, tmp, dtr, pre, pre_cv, files))
  }
