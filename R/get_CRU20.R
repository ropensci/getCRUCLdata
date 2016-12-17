#' @title Download, and Create a Raster Stack Object of CRU CL2.0 Weather
#' Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'climate data into R and calculates TMIN and TMAX for use as a raster::stack
#'object
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
#' CRU_raster()
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
    xy <- NULL
    if (!isTRUE(pre) &
        !isTRUE(pre_cv) & !isTRUE(rd0) & !isTRUE(tmp) &
        !isTRUE(dtr) &
        !isTRUE(reh) & !isTRUE(tmn) & !isTRUE(tmn) & !isTRUE(tmx) &
        !isTRUE(sunp) &
        !isTRUE(frs) & !isTRUE(wnd) & !isTRUE(elv)) {
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

    # Create raster objects using cellFromXY and generate a raster stack
    # create.stack takes pre, tmp, tmn and tmx and creates a raster
    # object stack of 12 month data

    CRU_list <-
      .get_CRU(pre, rd0, tmp, dtr, reh, tmn, tmx, sunp, frs, wnd, elv)

    if (pre == TRUE) {
      pre_stack <- .create_stack(CRU_list$pre, xy, wrld, months)
    }

    if (tmn == TRUE) {
      tmn_stack <- .create_stack(CRU_list$tmn, xy, wrld, months)
    }

    if (tmx == TRUE) {
      tmx_stack <- .create_stack(CRU_list$tmx, xy, wrld, months)
    }

    if (tmp == TRUE) {
      tmp_stack <- .create_stack(CRU_list$tmp, xy, wrld, months)
    }
    # stack all object and return
    CRU_stack <-
      raster::stack(pre_stack, tmn_stack, tmx_stack, tmp_stack)
    return(CRU_stack)
  }

#' @title Download and Create a Data Frame Object of CRU CL2.0 Weather
#' Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'climate data into R and calculates minimum and maximum temperature for use
#'in an R session.
#'
#'For more information see the description of the data provided by CRU,
#'\url{http://www.cru.uea.ac.uk/cru/data/hrg/tmc/readme.txt}
#'
#'Nomenclature and units from readme.txt:
#'Nomenclature and Units
#'----------------------
#'pre	precipitation		mm/month
#'cv of precipitation 	percent
#'rd0	wet-days		no days with >0.1mm rain per month
#'tmp	mean temperature	Deg C
#'dtr	mean diurnal temperature range-Deg C (note tmx = tmp + 0.5 * dtr;
#'tmn = tmp - 0.5 * dtr)
#'reh	relative humidity	percent
#'sunp	sunshine		percent of maximum possible (percent of daylength)
#'frs	ground-frost		no days with ground-frost per month
#'wnd	10m windspeed		m/s
#'elv	elevation		km
#'
#' @details This function generates a data.frame object in R
#' @param pre Logical. Fetch precipitation (mm/month) from server and return in
#' the data frame? Defaults to FALSE.
#' @param pre_cv Logical. Fetch cv of precipitation (percent) from server and
#' return in the data frame? Defaults to FALSE.
#' @param rd0 Logical. Fetch wet-days (number days with >0.1mm rain per month)
#' and return in the data frame? Defaults to FALSE.
#' @param dtr Logical. Fetch mean diurnal temperature range (degrees C) and
#' return it in the data frame? Defaults to FALSE.
#' @param tmp Logical. Fetch temperature (degrees C) and return it in the data
#' frame? Defaults to FALSE.
#' @param tmn Logical. Create minimum temperature values (degrees C) and return
#' it in the data frame? Defaults to FALSE.
#' @param tmx Logical. Create maxium temperature (degrees C) and return it in
#' the data frame? Defaults to FALSE.
#' @param reh Logical. Fetch relative humidity and return it in the data frame?
#' Defaults to FALSE.
#' @param sunp Logical. Fetch sunshine, percent of maximum possible (percent of
#' daylength) and return it in data frame? Defaults to FALSE.
#' @param frs Logical. Fetch ground-frost records (number of days with ground-
#' frost per month) and return it in data frame? Defaults to FALSE.
#' @param wnd Logical. Fetch 10m windspeed (m/s) and return it in the data
#' frame? Defaults to FALSE.
#' @param elv Logical. Fetch elevation (converted to metres from kilometres) and
#' return it in the data frame? Defaults to FALSE.
#'
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' CRU_pre_tmp <- create_CRU_df(pre = TRUE, tmp = TRUE)
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

  CRU_list <-
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
             elv)

  CRU_df <- plyr::ldply(CRU_list, data.frame)
  return(CRU_df)
}
