
#' @title Create a Tidy Data Frame From CRU CL v.2.0 Climatology Variables on Local Disk
#'
#'@description Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a tidy data frame of the data.  If requested, minimum and
#' maximum temperature may also be automatically calculated as described in the
#' data readme.txt file.  This function can be useful if you have network
#' connection issues that mean automated downloading of the files using \pkg{R}
#' does not work properly.  In this instance it is recommended to use an
#' \acronym{FTP} client (\emph{e.g.}, FileZilla), web browser or command line
#' command (\emph{e.g.}, wget or curl) to download the files, save locally and
#' use this function to import the data into \pkg{R}.
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
#'For more information see the description of the data provided by
#' \acronym{CRU}, \url{https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt}
#'
#' @param pre Logical. Fetch precipitation (millimetres/month) from server and
#'  return in the data frame? Defaults to \code{FALSE}.
#' @param pre_cv Logical. Fetch cv of precipitation (percent) from server and
#' return in the data frame? Defaults to \code{FALSE}. NOTE. Setting this to
#' \code{TRUE} will always results in \strong{pre} being set to \code{TRUE} and
#' returned as well.
#' @param rd0 Logical. Fetch wet-days (number days with >0.1millimetres rain per
#' month) and return in the data frame? Defaults to \code{FALSE}.
#' @param dtr Logical. Fetch mean diurnal temperature range (degrees Celsius)
#' and return it in the data frame? Defaults to \code{FALSE}.
#' @param tmp Logical. Fetch temperature (degrees Celsius) and return it in the
#' data frame? Defaults to \code{FALSE}.
#' @param tmn Logical. Calculate minimum temperature values (degrees Celsius)
#' and return it in the data frame? Defaults to \code{FALSE}.
#' @param tmx Logical. Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame? Defaults to \code{FALSE}.
#' @param reh Logical. Fetch relative humidity and return it in the data frame?
#' Defaults to \code{FALSE}.
#' @param sunp Logical. Fetch sunshine, percent of maximum possible (percent of
#' day length) and return it in data frame? Defaults to \code{FALSE}.
#' @param frs Logical. Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in data frame? Defaults to \code{FALSE}.
#' @param wnd Logical. Fetch 10m wind speed (metres/second) and return it in the
#' data frame? Defaults to \code{FALSE}.
#' @param elv Logical. Fetch elevation (converted to metres) and return it in
#' the data frame? Defaults to \code{FALSE}.
#' @param dsn Local file path where \acronym{CRU} \acronym{CL} v.2.0 .dat.gz
#' files are located.
#'
#' @examples
#' \donttest{
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
#'}
#'
#' @seealso
#' \code{\link{get_CRU_df}}
#'
#' @return A tidy data frame of \acronym{CRU} \acronym{CL} v. 2.0 climatology
#' elements as a \code{\link[tibble]{tibble}} object
#'
#' @author Adam H Sparks, \email{adamhsparks@@gmail.com}
#'
#' @note
#' This package automatically converts elevation values from kilometres to
#' metres.
#' @export create_CRU_df

create_CRU_df <-   function(pre = FALSE,
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
                            dsn = "") {
  if (!isTRUE(pre) & !isTRUE(pre_cv) & !isTRUE(rd0) & !isTRUE(tmp) &
      !isTRUE(dtr) & !isTRUE(reh) & !isTRUE(tmn) & !isTRUE(tmx) &
      !isTRUE(sunp) & !isTRUE(frs) & !isTRUE(wnd) & !isTRUE(elv)) {
    stop("\nYou must select at least one element for importing.\n",
        call. = FALSE)
  }

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
                      cache_dir = dsn)

  if (length(files) == 0) {
    stop(
      "\nNo CRU CL 2.0 data files were found in ",
      dsn,
      ". ",
      "Please check that you have the proper file location.\n"
    )
  }

  d <- .create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)
  return(tibble::as_tibble(d))
}
