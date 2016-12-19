#' @title Download and Create a List of Raster Stack Objects From CRU CL2.0
#'Weather Variables
#'
#'
#'@description This function automates downloading and importing CRU CL2.0
#'climate data into R and creates a list of raster stacks of the data. If
#'requested, minimum and maximum temperature may also be automatically
#'calculated as described in the data readme.txt file.
#'
#'Nomenclature and units from readme.txt:
#'\describe{
#'\item{pre}{precipitation (milimetres/month)}
#'  \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'  }
#'\item{rd0}{wet-days (no days with >0.1mm rain per month)}
#'\item{tmp}{mean temperature (Degrees Celsius)}
#'\item{dtr}{mean diurnal temperature range (Degrees Celsius)}
#'\item{reh}{relative humidity (percent)}
#'\item{sunp}{sunshine (percent of maximum possible (percent of daylength))}
#'\item{frs}{ground-frost (number of days with ground-frost per month)}
#'\item{wnd}{10 metre windspeed (metres/second)}
#'\item{elv}{elevation (kilometres)}
#'}
#'For more information see the description of the data provided by CRU,
#'\url{http://www.cru.uea.ac.uk/cru/data/hrg/tmc/readme.txt}
#'
#' @details This function generates a data.frame object in R with the following
#' possible fields as specified by the user:
#' @param pre Logical. Fetch precipitation (milimetres/month) from server and
#' return in a raster stack? Defaults to FALSE.
#' @param pre_cv Logical. Fetch cv of precipitation (percent) from server and
#' return in a raster stack? Defaults to FALSE.
#' @param rd0 Logical. Fetch wet-days (number days with >0.1milimetres rain per
#' month) and return in a raster stack? Defaults to FALSE.
#' @param dtr Logical. Fetch mean diurnal temperature range (degrees Celsius)
#' and return it in a raster stack? Defaults to FALSE.
#' @param tmp Logical. Fetch temperature (degrees Celsius) and return it in the
#' raster stack? Defaults to FALSE.
#' @param tmn Logical. Create minimum temperature values (degrees Celsius) and
#' return it in a raster stack? Defaults to FALSE.
#' @param tmx Logical. Create maxium temperature (degrees Celsius) and return it
#' in a raster stack? Defaults to FALSE.
#' @param reh Logical. Fetch relative humidity and return it in a raster stack?
#' Defaults to FALSE.
#' @param sunp Logical. Fetch sunshine, percent of maximum possible (percent of
#' daylength) and return it in raster stack? Defaults to FALSE.
#' @param frs Logical. Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in raster stack? Defaults to FALSE.
#' @param wnd Logical. Fetch 10m windspeed (metres/second) and return it in the
#' raster stack? Defaults to FALSE.
#' @param elv Logical. Fetch elevation (converted to metres from kilometres) and
#' return it in a raster stack? Defaults to FALSE.
#'
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' \dontrun{
#' CRU_pre_tmp <- create_CRU_stack(pre = TRUE, tmp = TRUE)
#'}
#' @export
create_CRU_stack <-
  function(pre = FALSE,
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
    cache_dir <- tempdir()

    if (!isTRUE(pre) & !isTRUE(pre_cv) & !isTRUE(rd0) & !isTRUE(tmp) &
        !isTRUE(dtr) & !isTRUE(reh) & !isTRUE(tmn) & !isTRUE(tmx) &
        !isTRUE(sunp) & !isTRUE(frs) & !isTRUE(wnd) & !isTRUE(elv)) {
      stop("You must select at least one parameter for download.")
    }

    wrld <-
      raster::raster(
        nrows = 900,
        ncols = 2160,
        ymn = -60,
        ymx = 90,
        xmn = -180,
        xmx = 180
      )

    month_names <-
      c("jan",
        "feb",
        "mar",
        "apr",
        "may",
        "jun",
        "jul",
        "aug",
        "sep",
        "oct",
        "nov",
        "dec")

    # Create raster objects using cellFromXY and generate a raster stack
    # create.stack takes pre, tmp, tmn and tmx and creates a raster
    # object stack of 12 month data

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

    files <-
      list.files(cache_dir, pattern = ".dat.gz$", full.names = TRUE)

    CRU_stack_list <-
      plyr::llply(.fun = .create_stack,
                  files,
                  wrld,
                  month_names,
                  pre_cv,
                  .progress = "text")
    return(CRU_stack_list)
  }

.create_stack <- function(i, wrld, month_names, pre_cv){
  wvar <- utils::read.table(i, header = FALSE, colClasses = "numeric")
  cells <- raster::cellFromXY(wrld, wvar[, c(2, 1)])
  for (j in 3:14) {
    wrld[cells] <- wvar[, j]
    if (j == 3) {
      y <- wrld
      } else
        y <- raster::stack(y, wrld)
  }
  if (ncol(wvar == 26) & pre_cv == TRUE)
    for (k in 15:26) {
      wrld[cells] <- wvar[, k]
      if (k == 15) {
        y <- wrld
        } else
          y <- raster::stack(y, wrld)
    }
  names(y) <- month_names
  return(y)
}
