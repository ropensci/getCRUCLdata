#' Create a data.table of CRU CL v. 2.0 climatology elements from local disk files
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{data.table} of the data. If requested, minimum
#' and maximum temperature may also be automatically calculated as described in
#' the data [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt)
#' file. Data may be cached for later use by this function, saving time
#' downloading files in future using this function.  This function can be useful
#' if you have network connection issues that mean automated downloading of the
#' files using \R does not work properly.
#'
#' @inheritSection get_CRU_df Nomenclature and Units
#'
#' @param pre Loads precipitation (millimetres/month) from server and
#'  returns in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param pre_cv Loads cv of precipitation (percent) from server and
#' returns in the data frame, `TRUE`. Defaults to `FALSE`. NOTE. Setting this
#' to `TRUE` will always results in **pre** being set to `TRUE` and
#' returned as well.
#' @param rd0 Loads wet-days (number days with >0.1 millimetres rain per
#' month) and returns in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param dtr Loads mean diurnal temperature range (degrees Celsius)
#' and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmp Loads temperature (degrees Celsius) and returns it in the
#' data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmn Calculate minimum temperature values (degrees Celsius)
#' and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmx Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param reh Loads relative humidity and returns it in the data frame, `TRUE`.
#' Defaults to `FALSE`.
#' @param sunp Loads sunshine, percent of maximum possible (percent of
#' day length) and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param frs Loads ground-frost records (number of days with ground-
#' frost per month) and returns it in the data frame, `TRUE`. Defaults to
#' `FALSE`.
#' @param wnd Load 10 m wind speed (metres/second) and returns it in the
#' data frame, `TRUE`. Defaults to `FALSE`.
#' @param elv Loads elevation (converted to metres) and returns it in
#' the data frame, `TRUE`. Defaults to `FALSE`.
#' @param dsn Local file path where \acronym{CRU} \acronym{CL} v.2.0 .dat.gz
#' files are located.
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
#' CRU_tmp
#'
#' @seealso
#' [get_CRU_df].
#'
#' @returns A [data.table::data.table] object of \acronym{CRU} \acronym{CL} v.
#'  2.0 climatology elements.
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
#' @references New, Mark, et al. "A high-resolution data set of surface climate
#'  over global land areas." Climate research 21.1 (2002): 1-25.
#'  <https://crudata.uea.ac.uk/cru/data/hrg/tmc/new_et_al_10minute_climate_CR.pdf>
#'
#' @export

create_CRU_df <- function(pre = FALSE,
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

  return(.create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
}

#' @export
#' @rdname create_CRU_df
create_cru_df <- create_CRU_df
