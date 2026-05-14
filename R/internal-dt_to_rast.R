#' For `elv`: produces a single-layer raster with bad coordinates masked to NA.
#' For all other variables: produces 12 layers (one per month), named
#' `<varname>_<month>`.
#'
#' @param dt      A tidy data.table with columns: lat, lon, value, and (for
#'                non-elv variables) month.
#' @param varname Character scalar: variable identifier (e.g. "tmp", "pre",
#'                "elv").
#'
#' @return A terra::rast - one layer for elv, 12 layers for all others.
#' @autoglobal
#' @dev

.dt_to_rast <- function(dt, varname) {
  wrld <- .cru_template_rast()

  # --- elevation: single layer, bad coordinates masked ----------------------
  if (varname == "elv") {
    value_col <- if ("elv" %in% names(dt)) "elv" else "value"
    xy <- cbind(dt$lon, dt$lat)
    cell <- terra::cellFromXY(wrld, xy)
    wrld[cell] <- dt[[value_col]]
    wrld <- .remove_bad_cells_rast(wrld)
    names(wrld) <- "elv"
    return(wrld)
  }

  # --- all other variables: 12 monthly layers -------------------------------
  value_col <- if ("value" %in% names(dt)) "value" else varname

  rast_list <- lapply(.cru_month_names, function(m) {
    r <- wrld
    dtm <- dt[month == m]
    cells <- terra::cellFromXY(r, cbind(dtm$lon, dtm$lat))
    r[cells] <- dtm[[value_col]]
    r
  })

  names(rast_list) <- sprintf("%s_%s", varname, .cru_month_names)
  terra::rast(rast_list)
}


#' Mask bad cells in a SpatRaster
#'
#' Sets the package-level `.bad_coords` cells to NA. Used exclusively for the
#' elevation layer.
#'
#' @param r A terra::rast to modify.
#'
#' @return The modified terra::rast.
#' @autoglobal
#' @dev
.remove_bad_cells_rast <- function(r) {
  cells <- terra::cellFromXY(r, as.matrix(.bad_coords[, list(lon, lat)]))
  cells <- unique(stats::na.omit(cells))
  r[cells] <- NA
  r
}
