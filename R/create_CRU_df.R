#' Create a data.table of Climatology Variables From Local Disk Files
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{data.table} of the data.  If requested, minimum
#' and maximum temperature may also be automatically calculated as described in
#' the data readme.txt file.  This function can be useful if you have network
#' connection issues that mean automated downloading of the files using \R
#' does not work properly.
#'
#' @inheritSection get_CRU_df Nomenclature and Units
#'
#' @param pre Boolean. Load precipitation (millimetres/month) from server and
#'  return in the data frame? Defaults to `FALSE`.
#' @param pre_cv Boolean. Load cv of precipitation (percent) from server and
#' return in the data frame? Defaults to `FALSE`. NOTE. Setting this to
#' `TRUE` will always results in **pre** being set to `TRUE` and
#' returned as well.
#' @param rd0 Boolean. Load wet-days (number days with >0.1millimetres rain per
#' month) and return in the data frame? Defaults to `FALSE`.
#' @param dtr Boolean. Load mean diurnal temperature range (degrees Celsius)
#' and return it in the data frame? Defaults to `FALSE`.
#' @param tmp Boolean. Load temperature (degrees Celsius) and return it in the
#' data frame? Defaults to `FALSE`.
#' @param tmn Boolean. Calculate minimum temperature values (degrees Celsius)
#' and return it in the data frame? Defaults to `FALSE`.
#' @param tmx Boolean. Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame? Defaults to `FALSE`.
#' @param reh Boolean. Load relative humidity and return it in the data frame?
#' Defaults to `FALSE`.
#' @param sunp Boolean. Load sunshine, percent of maximum possible (percent of
#' day length) and return it in the data frame? Defaults to `FALSE`.
#' @param frs Boolean. Load ground-frost records (number of days with ground-
#' frost per month) and return it in the data frame? Defaults to `FALSE`.
#' @param wnd Boolean. Load 10m wind speed (metres/second) and return it in the
#' data frame? Defaults to `FALSE`.
#' @param elv Boolean. Load elevation (converted to metres) and return it in
#' the data frame? Defaults to `FALSE`.
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
#' [get_CRU_df()]
#'
#' @return A \CRANpkg{data.table} object of \acronym{CRU} \acronym{CL} v. 2.0
#'  climatology elements
#'
#' @author Adam H Sparks, \email{adamhsparks@@gmail.com}
#'
#' @note
#' This package automatically converts elevation values from kilometres to
#' metres.
#' @export create_CRU_df

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
