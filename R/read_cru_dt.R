#' Create a data.table of CRU CL v. 2.0 climatology elements
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology data and
#' from either the CRU server or local files and creates a \CRANpkg{data.table}
#' of the data. If requested, minimum and maximum temperature may also be
#' calculated as described in the data
#' [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file and
#' returned.
#'
#' @section Nomenclature and Units:
#' \describe{
#' \item{pre}{precipitation (millimetres/month)}
#'   \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'   }
#' \item{rd0}{wet-days (number days with >0.1 millimetres rain per month)}
#' \item{tmp}{mean temperature (degrees Celsius)}
#' \item{dtr}{mean diurnal temperature range (degrees Celsius)}
#' \item{reh}{relative humidity (percent)}
#' \item{sunp}{sunshine (percent of maximum possible (percent of day length))}
#' \item{frs}{ground-frost (number of days with ground-frost per month)}
#' \item{wnd}{10 metre windspeed (metres/second)}
#' \item{elv}{elevation (automatically converted to metres from kilometres)}
#' }
#' For more information see the description of the data provided by
#' \acronym{CRU}, <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>
#'
#' @param pre Loads precipitation (millimetres/month) from server and
#'  returns in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param pre_cv Loads cv of precipitation (percent) from server and
#'  returns in the data.table, `TRUE`. Defaults to `FALSE`. NOTE. Setting this
#'  to `TRUE` will always results in `pre` being set to `TRUE` and
#'  returned as well.
#' @param rd0 Loads wet-days (number days with >0.1 millimetres rain per
#'  month) and returns in the data.table, `TRUE`. Defaults to `FALSE`.
#' @param dtr Loads mean diurnal temperature range (degrees Celsius)
#'  and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmp Loads temperature (degrees Celsius) and returns it in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param tmn Calculate minimum temperature values (degrees Celsius)
#'  and returns it in the data.table, `TRUE`. Defaults to `FALSE`.
#' @param tmx Calculate maximum temperature (degrees Celsius) and
#'  return it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param reh Loads relative humidity and returns it in the data.table, `TRUE`.
#'  Defaults to `FALSE`.
#' @param sunp Loads sunshine, percent of maximum possible (percent of
#'  day length) and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param frs Loads ground-frost records (number of days with ground-
#'  frost per month) and returns it in the data frame, `TRUE`. Defaults to
#'  `FALSE`.
#' @param wnd Load 10 m wind speed (metres/second) and returns it in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param elv Loads elevation (converted to metres) and returns it in
#'  the data.table, `TRUE`. Defaults to `FALSE`.
#' @param x An optional local file path where \acronym{CRU} \acronym{CL} v.2.0
#'  .dat.gz files are located.  If this is empty, the requested data will
#'  automatically be downloaded from the server.
#'
#' @examplesIf interactive()
#' # Create a data frame of temperature from locally available files in the
#' # tempdir() directory.
#' library(fs)
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' f <- path(path_temp(), "grid_10min_tmp.dat.gz")
#'
#' cru_tmp <- read_cru_dt(tmp = TRUE, x = f)
#'
#' cru_tmp
#'
#' @seealso [read_cru_rast].
#'
#' @seealso
#' [read_cru_rast].
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

read_cru_dt <- function(
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
  elv = FALSE,
  x
) {
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

  if (is.null(x)) {} else {
    .validate_x(x)

    files <- fs::dir_ls(x, regexp = "\\.dat\\.gz$", recurse = FALSE)

    if (length(files) == 0L) {
      cli::cli_abort(
        "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
      )

      return(.create_dt(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
    }
  }
}
