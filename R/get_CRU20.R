#' @title Download, and Create a Raster Stack of CRU CL2.0 Weather Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'weather data into R and calculates TMIN and TMAX for use as a raster::stack
#'object
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
#'dtr	mean diurnal temperature range-Deg C (note tmx = tmp + 0.5*  dtr;
#'tmn = tmp - 0.5 * dtr)
#'reh	relative humidity	percent
#'sunp	sunshine		percent of maximum possible (percent of daylength)
#'frs	ground-frost		no days with ground-frost per month
#'wnd	10m windspeed		m/s
#'elv	elevation		km
#'
#' @details This function generates a raster::stack object in R
#' @param precipitation = pre,
#' mean diurnal temprature range = drt,
#' minimum temperature = tmn,
#' maximum temperature = tmx,
#' temperature = tmp,
#' relative humidity = reh.
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' CRU_raster()
#'
#' @export
create_CRU_raster <- function(pre = TRUE, tmp = TRUE, dtr = TRUE, reh = TRUE,
                              tmn = TRUE, tmx = TRUE) {
  xy <- NULL

  wrld <- raster::raster(nrows = 900, ncols = 2160, ymn = -60,
                         ymx = 90, xmn = -180, xmx = 180)

  months <- c("jan", "feb", "mar", "apr", "may", "jun",
              "jul", "aug", "sep", "oct", "nov", "dec")

  # Create raster objects using cellFromXY and generate a raster stack
  # create.stack takes pre, tmp, tmn and tmx and creates a raster
  # object stack of 12 month data

  CRU_list <- .get_CRU()

  if (pre == TRUE) {
    pre_stack <- .create_stack(CRU_list$pre, xy, wrld, months)
  } else if (tmn == TRUE) {
    tmn_stack <- .create_stack(CRU_list$tmn, xy, wrld, months)
  } else if (tmx == TRUE) {
    tmx_stack <- .create_stack(CRU_list$tmx, xy, wrld, months)
  } else if (tmp == TRUE) {
    tmp_stack <- .create_stack(CRU_list$tmp, xy, wrld, months)
  }
}

#' @title Download, and Create a Data Frame of CRU CL2.0 Weather Variables
#'
#'@description This function automates downloading and importing CRU CL2.0
#'weather data into R and calculates minimum and maximum temperature for use
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
#' @param
#' precipitation = pre,
#' mean diurnal temprature range = drt,
#' minimum temperature = tmn,
#' maximum temperature = tmx,
#' temperature = tmp,
#' relative humidity = reh.
#' @examples
#' # Download data and create a raster stack of precipitation and temperature
#' create_CRU_df()
#'
#' @export
create_CRU_df <- function(pre = NULL, tmp = NULL, dtr = NULL, reh = NULL,
                          tmn = NULL, tmx = NULL){
  CRU_df <- as.data.frame(
    data.table::rbindlist(.get_CRU))
  names(CRU_df) <- c("dtr_C", "pre_mm", "pre_cv_%", "reh_%", "tmn_C", "tmp_C",
                     "tmx_C")
}

#' @noRd
.get_CRU <- function(){
  tf <- tempfile()

  CRU_list <- NULL

  if (dtr == TRUE) {
    utils::download.file(
      "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz", tf,
      mode = "wb")

    dtr <- data.table::data.table(utils::read.table(tf, header = FALSE,
                                                    colClasses = "numeric",
                                                    nrows = 566262))
  }

  if (tmp == TRUE) {
    utils::download.file(
      "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz", tf,
      mode = "wb")
    tmp <- data.table::data.table(utils::read.table(tf, header = FALSE,
                                                    colClasses = "numeric",
                                                    nrows = 566262))
  }

  if (pre == TRUE) {
    utils::download.file(
      "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz", tf,
      mode = "wb")
    pre <- data.table::data.table(utils::read.table(tf, header = FALSE,
                                                    colClasses = "numeric",
                                                    nrows = 566268))
  }

  if (reh == TRUE) {
    utils::download.file(
      "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz", tf,
      mode = "wb")
    reh <- data.table::data.table(utils::read.table(tf, header = FALSE,
                                                    colClasses = "numeric",
                                                    nrows = 566262))
  }

  # calculate tmax and tmin from tmp and dtr,
  tmx <- tmp[, c(3:14)] + (0.5 * dtr[, c(3:14)])
  tmx <- data.table::data.table(dplyr::bind_cols(tmp[, 1:2], tmx))
  tmn <- tmp[, c(3:14)] - (0.5 * dtr[, c(3:14)])
  tmn <- data.table::data.table(dplyr::bind_cols(tmp[, c(1:2)], tmn))

  CRU_list <- list(dtr, pre, reh, tmn, tmp, tmx)
  return(CRU_list)
}

#' @noRd
.create_stack <- function(wvar, xy, wrld, months){
  x <- wrld
  cells <- raster::cellFromXY(x, wvar[, c(2, 1)])
  for (i in 3:14){
    x[cells] <- wvar[, i]
    if (i == 3){
      y <- x
    } else
      y <- raster::stack(y, x)
  }
  names(y) <- months
  return(y)
  rm(x)
}
