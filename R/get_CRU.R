#' @noRd
.get_CRU <-
  function(pre,
           rd0,
           tmp,
           dtr,
           reh,
           tmn,
           tmx,
           sunp,
           frs,
           wnd,
           elv) {

    CRU_list <- NULL
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

    if (dtr == TRUE | tmn == TRUE | tmx == TRUE) {
      dtr <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (tmp == TRUE | tmn == TRUE | tmx == TRUE) {
      tmp <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (pre == TRUE) {
      pre <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz",
        col_names = c("lat", "lon", month_names, paste0(month_names, "_cv"))
      )
    }

    if (reh == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (elv == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (sunp == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (wnd == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (frs == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    if (rd0 == TRUE) {
      reh <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz",
        col_names = c("lat", "lon", month_names)
      )
    }

    # calculate tmax and tmin from tmp and dtr
    tmx <- tmp[, c(3:14)] + (0.5 * dtr[, c(3:14)])
    tmx <- dplyr::bind_cols(tmp[, 1:2], tmx)
    tmn <- tmp[, c(3:14)] - (0.5 * dtr[, c(3:14)])
    tmn <- dplyr::bind_cols(tmp[, c(1:2)], tmn)

    # convert elevation to metres
    elv <- elv / 1000

    CRU_list <-
      list(dtr, pre, reh, tmn, tmp, tmx, rd0, elv, frs, wnd, sunp)
    return(CRU_list)
  }

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
