#' Create a list of terra rast objects of CRU CL v. 2.0 climatology elements from local disk files
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{terra} [terra::rast] object of the
#' data.  If requested, minimum and maximum temperature may also be
#' automatically calculated as described in the data
#' [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file.
#' Data may be cached for later use by this function, saving time downloading
#' files in future using this function.  This function can be useful if you
#' have network connection issues that mean automated downloading of the files
#' using \R does not work properly or you have cached the files locally for
#' your own future use.
#'
#' @inheritSection get_CRU_df Nomenclature and Units
#' @inheritParams create_CRU_df
#' @inherit create_CRU_df author
#' @inherit create_CRU_df source
#' @inherit create_CRU_df references
#' @inherit create_CRU_stack return
#'
#' @examplesIf interactive()
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' CRU_tmp <- create_CRU_stack(tmp = TRUE, dsn = tempdir())
#'
#' CRU_tmp
#'
#' @seealso
#' [get_CRU_stack].
#'
#' @returns A [base::list] of [terra::rast] objects of \acronym{CRU}
#' \acronym{CL} v. 2.0 climatology elements.
#'
#' @export

create_CRU_stack <- function(pre = FALSE,
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
                             elv = FALSE,
                             dsn) {
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

  .validate_dsn(dsn)

  files <- .get_local(pre,
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
    elv,
    cache_dir = dsn
  )

  if (length(files) == 0) {
    cli::cli_abort(
      "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
    )
  }

  return(.create_stacks(tmn, tmx, tmp, dtr, pre, pre_cv, files))
}

#' @export
#' @rdname create_CRU_stack
create_cru_stack <- create_CRU_stack
