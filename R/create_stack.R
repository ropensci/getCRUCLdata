#' @noRd
.create_stack <- function(wvar) {
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
  x <- wrld
  cells <- raster::cellFromXY(x, wvar[, c(2, 1)])

  for (i in 3:14) {
    x[cells] <- wvar[, i]
    if (i == 3) {
      y <- x
    } else
      y <- raster::stack(y, x)
  }
  names(y) <- month_names
  return(y)
  rm(x)
}
