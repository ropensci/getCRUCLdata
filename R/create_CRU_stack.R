#' @title Download, and Create a Raster Stack Object of CRU CL2.0 Weather
#' Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'climate data into R and can calculate TMIN and TMAX. Data are returned as a
#'list of raster stack objects with stack layers being the monthly
#'data
#'
#'For more information see the description of the data provided by CRU,
#'\url{http://www.cru.uea.ac.uk/cru/data/hrg/tmc/readme.txt}
#'
#'Nomenclature and Units
#'----------------------
#'pre	precipitation		mm/month
#'cv of precipitation 	percent
#'rd0	wet-days		no days with >0.1mm rain per month
#'tmp	mean temperature	Deg C
#'dtr	mean diurnal temperature range-Deg C (note tmx = tmp + 0.5*  dtr;
#'tmn = tmp - 0.5 * dtr)
#'reh	relative humidity	percent
#'sunp	sunshine		percent of maximum possible (percent of daylength)
#'frs	ground-frost		no days with ground-frost per month
#'wnd	10m windspeed		m/s
#'elv	elevation		km
#'
#' @details This function generates a raster::stack object in R
#' @param pre Logical. Fetch precipitation (mm/month) from server and return in
#' the raster stack? Defaults to FALSE.
#' @param pre_cv Logical. Fetch cv of precipitation (percent) from server and
#' return in the raster stack? Defaults to FALSE.
#' @param rd0 Logical. Fetch wet-days (number days with >0.1mm rain per month)
#' and return in the raster stack? Defaults to FALSE.
#' @param dtr Logical. Fetch mean diurnal temperature range (degrees C) and
#' return it in the raster stack? Defaults to FALSE.
#' @param tmp Logical. Fetch temperature (degrees C) and return it in the data
#' frame? Defaults to FALSE.
#' @param tmn Logical. Create minimum temperature values (degrees C) and return
#' it in the raster stack? Defaults to FALSE.
#' @param tmx Logical. Create maxium temperature (degrees C) and return it in
#' the raster stack? Defaults to FALSE.
#' @param reh Logical. Fetch relative humidity and return it in the raster stack?
#' Defaults to FALSE.
#' @param sunp Logical. Fetch sunshine, percent of maximum possible (percent of
#' daylength) and return it in raster stack? Defaults to FALSE.
#' @param frs Logical. Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in raster stack? Defaults to FALSE.
#' @param wnd Logical. Fetch 10m windspeed (m/s) and return it in the data
#' frame? Defaults to FALSE.
#' @param elv Logical. Fetch elevation (converted to metres from kilometres) and
#' return it in the raster stack? Defaults to FALSE.
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' \dontrun{
#' create_CRU_stack(pre = TRUE, tmn = TRUE, tmx = TRUE)
#' }
#'
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
                  .progress = "text")
    return(CRU_stack_list)
  }

.create_stack <- function(i, wrld, month_names, pre_cv){
  wvar <- read.table(i, header = FALSE, colClasses = "numeric")
  cells <- raster::cellFromXY(wrld, wvar[, c(2, 1)])
  for (j in 3:14) {
    wrld[cells] <- wvar[, j]
    if (j == 3) {
      y <- wrld
      } else
        y <- raster::stack(y, wrld)
  }
  if (ncol(wvar == 26 & pre_cv == TRUE))
    for (j in 15:26) {
      wrld[cells] <- wvar[, j]
      if (j == 3) {
        y <- wrld
        } else
          y <- raster::stack(y, wrld)
    }
  names(y) <- month_names
  return(y)
}
