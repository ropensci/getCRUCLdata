#' Create a list of terra rast objects of CRU CL v. 2.0 climatology elements from local disk files
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{terra} [terra::rast] object of the
#' data.  If requested, minimum and maximum temperature may also be
#' automatically calculated as described in the data readme.txt file.  This
#' function can be useful if you have network connection issues that mean
#' automated downloading of the files using \R does not work properly.
#'
#' @inheritSection get_CRU_df Nomenclature and Units
#' @inheritParams create_CRU_df
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
#' @return A [base::list] of [terra::rast] objects of \acronym{CRU} \acronym{CL}
#'  v. 2.0 climatology elements.
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @source
#' \describe{
#'  \item{pre}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz>}
#'  \item{rd0}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz>}
#'  \item{tmp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz>}
#'  \item{dtr}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz>}
#'  \item{reh}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz>}
#'  \item{sunp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz>}
#'  \item{frs}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz>}
#'  \item{wnd}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz>, areas originally including Antarctica are removed.}
#'  \item{elv}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz>, values are converted from kilometres to metres.}
#' }
#' This package crops all spatial outputs to an extent of ymin = -60, ymax = 85,
#' xmin = -180, xmax = 180.
#'
#' @references <https://crudata.uea.ac.uk/cru/data/hrg/tmc/new_et_al_10minute_climate_CR.pdf>
#'
#' @export create_CRU_stack

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
