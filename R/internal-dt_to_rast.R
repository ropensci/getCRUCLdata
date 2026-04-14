#' Convert a tidy CRU data.table to a terra SpatRaster
#'
#' @param dt A tidy data.table with columns: lat, lon, month, value.
#' @param varname Character scalar: name of the variable (e.g., "tmp", "pre").
#'
#' @return A terra::rast with 12 layers (one per month).
#' @dev

.dt_to_rast <- function(dt, varname) {
  # Ensure required columns exist
  required <- c("lat", "lon", "month", "value")
  if (!all(required %in% names(dt))) {
    cli::cli_abort("`.dt_to_rast()` requires columns: {required}.")
  }

  # Base raster template (CRU 10-minute grid)
  wrld <- terra::rast(
    nrows = 930L,
    ncols = 2160L,
    ymin = -65L,
    ymax = 90L,
    xmin = -180L,
    xmax = 180L
  )
  wrld[] <- NA_real_

  # Month order
  month_names <- c(
    "jan",
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
    "dec"
  )

  # Build 12 layers
  rast_list <- lapply(month_names, function(m) {
    dtm <- dt[month == m]

    r <- wrld
    xy <- cbind(dtm$lon, dtm$lat)
    cell <- terra::cellFromXY(r, xy)
    r[cell] <- dtm$value

    r
  })

  # Use varname here — this is the only place it matters
  names(rast_list) <- paste0(varname, "_", month_names)

  terra::rast(rast_list)
}
