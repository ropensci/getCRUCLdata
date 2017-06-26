#' @title Download and Create a Tidy Data Frame of CRU CL v. 2.0 Climatology Variables
#'
#'@description This function automates downloading and importing CRU CL v. 2.0
#'climatology data into R and creates a tidy data frame of the data.  If
#'requested, minimum and maximum temperature may also be automatically
#'calculated as described in the data readme.txt file.  Data may be cached for
#'later use by this function, saving time downloading files in future use of the
#'function.
#'
#'Nomenclature and units from readme.txt:
#'\describe{
#'\item{pre}{precipitation (millimetres/month)}
#'  \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'  }
#'\item{rd0}{wet-days (number days with >0.1mm rain per month)}
#'\item{tmp}{mean temperature (degrees Celsius)}
#'\item{dtr}{mean diurnal temperature range (degrees Celsius)}
#'\item{reh}{relative humidity (percent)}
#'\item{sunp}{sunshine (percent of maximum possible (percent of day length))}
#'\item{frs}{ground-frost (number of days with ground-frost per month)}
#'\item{wnd}{10 metre windspeed (metres/second)}
#'\item{elv}{elevation (automatically converted to metres)}
#'}
#'For more information see the description of the data provided by CRU,
#'\url{https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt}
#'
#' @param pre Logical.  Fetch precipitation (millimetres/month) from server and
#' return in the data frame?  Defaults to \code{FALSE}.
#' @param pre_cv Logical.  Fetch cv of precipitation (percent) from server and
#' return in the data frame?  Defaults to \code{FALSE}.  NOTE.  Setting this to
#' \code{TRUE} will always results in \strong{pre} being set to \code{TRUE} and
#' returned as well.
#' @param rd0 Logical.  Fetch wet-days (number days with >0.1millimetres rain
#' per month) and return in the data frame?  Defaults to \code{FALSE}.
#' @param dtr Logical.  Fetch mean diurnal temperature range (degrees Celsius)
#' and return it in the data frame?  Defaults to \code{FALSE}.
#' @param tmp Logical.  Fetch temperature (degrees Celsius) and return it in the
#' data frame?  Defaults to \code{FALSE}.
#' @param tmn Logical.  Calculate minimum temperature values (degrees Celsius)
#' and return it in the data frame?  Defaults to \code{FALSE}.
#' @param tmx Logical.  Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame?  Defaults to \code{FALSE}.
#' @param reh Logical.  Fetch relative humidity and return it in the data frame?
#' Defaults to FALSE.
#' @param sunp Logical.  Fetch sunshine, percent of maximum possible (percent of
#' day length) and return it in data frame?  Defaults to \code{FALSE}.
#' @param frs Logical.  Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in data frame?  Defaults to \code{FALSE}.
#' @param wnd Logical.  Fetch 10m wind speed (metres/second) and return it in the
#' data frame? Defaults to \code{FALSE}.
#' @param elv Logical.  Fetch elevation (converted to metres) and return it in
#' the data frame?  Defaults to \code{FALSE}.
#' @param cache Logical.  Store CRU CL v. 2.0 data files locally for later use?
#' If \code{FALSE}, the downloaded files are removed when R session is closed.
#' To take advantage of cached files in future sessions, use \code{cache = TRUE}
#' after the initial download and caching.  Defaults to \code{FALSE}.
#'
#' @examples
#' \dontrun{
#' # Download data and create a data frame of precipitation and temperature
#' # without caching the data files
#' CRU_pre_tmp <- get_CRU_df(pre = TRUE, tmp = TRUE)
#'
#' # Download temperature and calculate tmin and tmax, save the temperature file
#' # for later use by caching
#'
#' CRU_tmp <- get_CRU_df(tmp = TRUE, tmn = TRUE, tmx = TRUE, cache = TRUE)
#'}
#'
#' @seealso
#' \code{\link{create_CRU_stack}}
#' \code{\link{manage_CRU_cache}}
#'
#' @return A tidy data frame of CRU CL v. 2.0 climatology elements as a
#' \code{\link[tibble]{tibble}} object
#'
#' @author Adam H Sparks, \email{adamhsparks@gmail.com}
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
  if (!isTRUE(pre) & !isTRUE(pre_cv) & !isTRUE(rd0) & !isTRUE(tmp) &
      !isTRUE(dtr) & !isTRUE(reh) & !isTRUE(tmn) & !isTRUE(tmx) &
      !isTRUE(sunp) & !isTRUE(frs) & !isTRUE(wnd) & !isTRUE(elv)) {
    stop("You must select at least one element for download.")
  }

  cache_dir <- .set_cache(cache)

  files <- .get_CRU(pre,
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
                    cache_dir)

  message("\nCreating data frame now.\n")
  d <- create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)
  return(d)
}
