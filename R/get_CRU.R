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
        col_names = FALSE)
      dtr_df <-
        dtr_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (tmp == TRUE | tmn == TRUE | tmx == TRUE) {
      tmp_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
        col_names = FALSE)
      tmp_df <-
        tmp_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
        }

    if (pre == TRUE) {
      pre_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz",
        col_names = FALSE)
      pre_df1 <- pre_df[, c(1:14)]
      pre_df2 <- pre_df[, c(1:2, 15:26)]
      names(pre_df1) <- names(pre_df2) <- c("lat", "lon", month_names)
      pre_df1 <-
        pre_df1 %>%
        tidyr::gather(key = "month", value = "pre", dplyr::everything(), -c(lat, lon))
      pre_df2 <-
        pre_df2 %>%
        tidyr::gather(key = "month", value = "pre_cv", dplyr::everything(), -c(lat, lon))
      pre_df <- dplyr::bind_cols(pre_df1, pre_df2[, 4])
    }

    if (reh == TRUE) {
      reh_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz",
        col_names = FALSE)

      reh_df <-
        reh_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (elv == TRUE) {
      elv_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz",
        col_names = FALSE)

      elv_df <-
        elv_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (sunp == TRUE) {
      sunp_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz",
        col_names = FALSE)

      sunp_df <-
        sunp_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (wnd == TRUE) {
      wnd_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz",
        col_names = FALSE)

      wnd_df <-
        wnd_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (frs == TRUE) {
      frs_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz",
        col_names = FALSE)

      frs_df <-
        frs_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (rd0 == TRUE) {
      rd0_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz",
        col_names = FALSE)

      rd0_df <-
        rd0_df %>%
        tidyr::gather(key = "month", value = "tmp", dplyr::everything(), -c(lat, lon))
    }

    if (isTRUE(tmx)) {
      # calculate tmax and tmin from tmp and dtr
      tmx <- tmp[, c(3:14)] + (0.5 * dtr[, c(3:14)])
      tmx <- dplyr::bind_cols(tmp[, 1:2], tmx)
    }

    if (isTRUE(tmn)) {
      tmn <- tmp[, c(3:14)] - (0.5 * dtr[, c(3:14)])
      tmn <- dplyr::bind_cols(tmp[, c(1:2)], tmn)
    }

    if (isTRUE(elv)) {
      # convert elevation to metres
      elv <- elv / 1000
    }

    CRU_list <-
      list(dtr_df, pre_df, reh_df, tmn_df, tmp_df, tmx_df, rd0_df, elv_df,
           frs_df, wnd_df, sunp_df)
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
