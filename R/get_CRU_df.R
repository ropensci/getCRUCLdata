#' Download and Dreate a data.table of Climatology Parameters
#'
#' This function automates downloading and importing \acronym{CRU}
#' \acronym{CL} v. 2.0 climatology data and creates a \CRANpkg{data.table} of
#'  the data.  If requested, minimum and maximum temperature may also be
#'  automatically calculated as described in the data readme.txt file.  Data may
#'  be cached for later use by this function, saving time downloading files in
#'  future use of this function.
#'
#' @section Nomenclature and Units:
#' \describe{
#' \item{pre}{precipitation (millimetres/month)}
#'   \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'   }
#' \item{rd0}{wet-days (number days with >0.1mm rain per month)}
#' \item{tmp}{mean temperature (degrees Celsius)}
#' \item{dtr}{mean diurnal temperature range (degrees Celsius)}
#' \item{reh}{relative humidity (percent)}
#' \item{sunp}{sunshine (percent of maximum possible (percent of day length))}
#' \item{frs}{ground-frost (number of days with ground-frost per month)}
#' \item{wnd}{10 metre windspeed (metres/second)}
#' \item{elv}{elevation (automatically converted to metres)}
#' }
#' For more information see the description of the data provided by
#' \acronym{CRU}, <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>
#'
#' @param pre Boolean.  Fetch precipitation (millimetres/month) from server and
#' return in the data frame?  Defaults to `FALSE`.
#' @param pre_cv Boolean.  Fetch cv of precipitation (percent) from server and
#' return in the data frame?  Defaults to `FALSE`.  NOTE.  Setting this to
#' `TRUE` will always results in **pre** being set to `TRUE` and
#' returned as well.
#' @param rd0 Boolean.  Fetch wet-days (number days with >0.1 millimetres rain
#' per month) and return in the data frame?  Defaults to `FALSE`.
#' @param dtr Boolean.  Fetch mean diurnal temperature range (degrees Celsius)
#' and return it in the data frame?  Defaults to `FALSE`.
#' @param tmp Boolean.  Fetch temperature (degrees Celsius) and return it in the
#' data frame?  Defaults to `FALSE`.
#' @param tmn Boolean.  Calculate minimum temperature values (degrees Celsius)
#' and return it in the data frame?  Defaults to `FALSE`.
#' @param tmx Boolean.  Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame?  Defaults to `FALSE`.
#' @param reh Boolean.  Fetch relative humidity and return it in the data frame?
#' Defaults to FALSE.
#' @param sunp Boolean.  Fetch sunshine, percent of maximum possible (percent of
#' day length) and return it in the data frame?  Defaults to `FALSE`.
#' @param frs Boolean.  Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in the data frame?  Defaults to `FALSE`.
#' @param wnd Boolean.  Fetch 10m wind speed (metres/second) and return it in the
#' data frame? Defaults to `FALSE`.
#' @param elv Boolean.  Fetch elevation (converted to metres) and return it in
#' the data frame?  Defaults to `FALSE`.
#' @param cache Boolean.  Store CRU CL v. 2.0 data files locally for later use?
#' If `FALSE`, the downloaded files are removed when R session is closed.
#' To take advantage of cached files in future sessions, use `cache = TRUE`
#' after the initial download and caching.  Defaults to `FALSE`.
#'
#' @examplesIf interactive()
#' # Download data and create a data frame of precipitation and temperature
#' # without caching the data files
#' CRU_pre_tmp <- get_CRU_df(pre = TRUE, tmp = TRUE)
#'
#' head(CRU_pre_tmp)
#' CRU_pre_tmp
#'
#' @seealso
#' [create_CRU_stack()]
#' [manage_cache()]
#'
#' @return A \CRANpkg{data.table} object of \acronym{CRU} \acronym{CL} v. 2.0
#'  climatology elements
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @note
#' This package automatically converts elevation values from kilometres to
#' metres.
#'
#' @export

get_CRU_df <- function(pre = FALSE,
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
                       cache = FALSE) {
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

  cache_dir <- .set_cache(cache)

  files <- .get_CRU(
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
    elv,
    cache_dir
  )

  return(.create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
}
