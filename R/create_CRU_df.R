#' @title Download and Create a Tidy Data Frame of CRU CL2.0 Climatology Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'climatology data into R and creates a tidy data frame of the data.  If
#'requested, minimum and maximum temperature may also be automatically
#'calculated as described in the data readme.txt file.
#'
#'Nomenclature and units from readme.txt:
#'\describe{
#'\item{pre}{precipitation (millimetres/month)}
#'  \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'  }
#'\item{rd0}{wet-days (no days with >0.1mm rain per month)}
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
#' @details This function generates a data.frame object in R with the following
#' possible fields as specified by the user:
#' @param pre Logical. Fetch precipitation (millimetres/month) from server and
#'  return in the data frame? Defaults to FALSE.
#' @param pre_cv Logical. Fetch cv of precipitation (percent) from server and
#' return in the data frame? Defaults to FALSE. NOTE. Setting this to TRUE
#' will always results in \strong{pre} being set to TRUE and returned as well.
#' @param rd0 Logical. Fetch wet-days (number days with >0.1millimetres rain per
#' month) and return in the data frame? Defaults to FALSE.
#' @param dtr Logical. Fetch mean diurnal temperature range (degrees Celsius)
#' and return it in the data frame? Defaults to FALSE.
#' @param tmp Logical. Fetch temperature (degrees Celsius) and return it in the
#' data frame? Defaults to FALSE.
#' @param tmn Logical. Calculate minimum temperature values (degrees Celsius)
#' and return it in the data frame? Defaults to FALSE.
#' @param tmx Logical. Calculate maximum temperature (degrees Celsius) and
#' return it in the data frame? Defaults to FALSE.
#' @param reh Logical. Fetch relative humidity and return it in the data frame?
#' Defaults to FALSE.
#' @param sunp Logical. Fetch sunshine, percent of maximum possible (percent of
#' day length) and return it in data frame? Defaults to FALSE.
#' @param frs Logical. Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in data frame? Defaults to FALSE.
#' @param wnd Logical. Fetch 10m wind speed (metres/second) and return it in the
#' data frame? Defaults to FALSE.
#' @param elv Logical. Fetch elevation (converted to metres) and return it in
#' the data frame? Defaults to FALSE.
#'
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' \dontrun{
#' CRU_pre_tmp <- create_CRU_df(pre = TRUE, tmp = TRUE)
#'}
#'
#' @seealso
#' \code{\link{create_CRU_stack}}
#'
#' @note
#' This package automatically converts elevation values from kilometres to
#' metres.
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
                          elv = FALSE) {
  if (!isTRUE(pre) & !isTRUE(pre_cv) & !isTRUE(rd0) & !isTRUE(tmp) &
      !isTRUE(dtr) & !isTRUE(reh) & !isTRUE(tmn) & !isTRUE(tmx) &
      !isTRUE(sunp) & !isTRUE(frs) & !isTRUE(wnd) & !isTRUE(elv)) {
    stop("You must select at least one parameter for download.")
  }

  cache_dir <- tempdir()

  .get_CRU(pre,
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

  CRU_df <-
    .tidy_df(pre_cv, tmn, tmx, cache_dir)

  if (isTRUE(tmx)) {
    tmx_df <- .calculate_tmx(CRU_df[, "tmp"], CRU_df[, "dtr"])
    CRU_df <- data.frame(CRU_df, tmx_df)
    names(CRU_df)[names(CRU_df) == "tmx_df"] <- "tmx"
  }

  if (isTRUE(tmn)) {
    tmn_df <- .calculate_tmn(CRU_df[, "tmp"], CRU_df[, "dtr"])
    CRU_df <- data.frame(CRU_df, tmn_df)
    names(CRU_df)[names(CRU_df) == "tmn_df"] <- "tmn"
  }

  # Remove tmp/dtr if they aren't specified (necessary for tmn/tmx)
  if (isTRUE(tmx) | isTRUE(tmn)) {
    if (!isTRUE(tmp)) {
      CRU_df <- subset(CRU_df, select = -tmp)
    }

    if (!isTRUE(dtr)) {
      CRU_df <- subset(CRU_df, select = -dtr)
    }
  }
  return(CRU_df)
}
