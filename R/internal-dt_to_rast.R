#' Convert a tidy CRU data.table to a terra SpatRaster
#'
#' @param dt A tidy data.table with columns: lat, lon, month, value.
#' @param varname Character scalar: name of the variable (e.g., "tmp", "pre").
#'
#' @return A terra::rast with 12 layers (one per month).
#' @dev

.dt_to_rast <- function(dt, varname) {
  # Base raster template (CRU 10-minute grid)
  wrld <- terra::rast(
    nrows = 930,
    ncols = 2160,
    ymin = -65,
    ymax = 90,
    xmin = -180,
    xmax = 180
  )
  wrld[] <- NA_real_

  # Build 12 layers
  rast_list <- lapply(.cru_month_names, function(m) {
    dtm <- dt[month == m]

    r <- wrld
    xy <- cbind(dtm$lon, dtm$lat)
    cell <- terra::cellFromXY(r, xy)
    r[cell] <- dtm$value

    r
  })

  # Use varname here — this is the only place it matters
  names(rast_list) <- paste0(varname, "_", .cru_month_names)

  terra::rast(rast_list)
}
