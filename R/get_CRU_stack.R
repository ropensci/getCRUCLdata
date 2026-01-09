#' Download and create a list of terra rast objects of CRU CL v. 2.0 climatology elements
#'
#' This function automates downloading and importing CRU CL v. 2.0
#' climatology data into \R and creates a list of \CRANpkg{terra}
#'  [terra::rast] objects of the data.  If requested, minimum and maximum
#'  temperature may also be automatically calculated as described in the data
#'  [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file.
#'
#' @inheritSection get_CRU_df Nomenclature and Units
#' @inheritParams get_CRU_df
#' @inherit create_CRU_df author
#' @inherit create_CRU_df source
#' @inherit create_CRU_df references
#' @inherit create_CRU_stack return
#'
#' @examplesIf interactive()
#'
#' # Download data and create a list of {terra} `rast` objects of precipitation
#' # and temperature without caching the data files
#' CRU_pre_tmp <- get_CRU_stack(pre = TRUE, tmp = TRUE)
#'
#' CRU_pre_tmp
#'
#' @seealso
#' [create_CRU_stack].
#'
#' @export

get_CRU_stack <-
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
    .check_vars_FALSE(
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

#' @export
#' @rdname get_CRU_stack
get_cru_stack <- get_CRU_stack
