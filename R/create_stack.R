#' @noRd
.create_stack <- function(wvar, xy, wrld, months) {
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
