#' @importFrom dplyr %>%
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
    lat <- lon <- dtr_df <- pre_df <- reh_df <- tmn_df <- tmp_df <- tmx_df <-
      rd0_df <- elv_df <- frs_df <- wnd_df <- sunp_df <- CRU_list <- NULL
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
    # dtr -------------------------------------------------------------------------
    if (dtr == TRUE | tmn == TRUE | tmx == TRUE) {
      dtr_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz",
        col_names = FALSE
      )
      names(dtr_df) <- c("lat", "lon", month_names)
      dtr_df <-
        dtr_df %>%
        tidyr::gather(key = "month",
                      value = "dtr",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # tmp ----------------------------------------------------------------------
    if (tmp == TRUE | tmn == TRUE | tmx == TRUE) {
      tmp_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
        col_names = FALSE
      )
      names(tmp_df) <- c("lat", "lon", month_names)
      tmp_df <-
        tmp_df %>%
        tidyr::gather(key = "month",
                      value = "tmp",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # pre ----------------------------------------------------------------------
    if (pre == TRUE) {
      pre_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz",
        col_names = FALSE
      )
      # split the data frame into two, otherwise we get errors on C stack usage
      pre_df1 <- pre_df[, c(1:14)]
      pre_df2 <- pre_df[, c(1:2, 15:26)]
      names(pre_df1) <-
        names(pre_df2) <- c("lat", "lon", month_names)
      pre_df1 <-
        pre_df1 %>%
        tidyr::gather(key = "month",
                      value = "pre",
                      dplyr::everything(),
                      -c(lat, lon))
      pre_df2 <-
        pre_df2 %>%
        tidyr::gather(key = "month",
                      value = "pre_cv",
                      dplyr::everything(),
                      -c(lat, lon))
      pre_df <- dplyr::bind_cols(pre_df1, pre_df2[, 4])
    }
    # reh ----------------------------------------------------------------------
    if (reh == TRUE) {
      reh_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz",
        col_names = FALSE
      )
      names(reh_df) <- c("lat", "lon", month_names)
      reh_df <-
        reh_df %>%
        tidyr::gather(key = "month",
                      value = "reh",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # elv ----------------------------------------------------------------------
    if (elv == TRUE) {
      elv_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz",
        col_names = FALSE
      )
      names(elv_df) <- c("lat", "lon", "elv_m")
      elv_df[, 3] <- elv_df[, 3] * 1000
    }
    # sunp ----------------------------------------------------------------------
    if (sunp == TRUE) {
      sunp_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz",
        col_names = FALSE
      )
      names(sunp_df) <- c("lat", "lon", month_names)
      sunp_df <-
        sunp_df %>%
        tidyr::gather(key = "month",
                      value = "sunp",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # wnd ----------------------------------------------------------------------
    if (wnd == TRUE) {
      wnd_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz",
        col_names = FALSE
      )
      names(wnd_df) <- c("lat", "lon", month_names)
      wnd_df <-
        wnd_df %>%
        tidyr::gather(key = "month",
                      value = "wnd",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # frs ----------------------------------------------------------------------
    if (frs == TRUE) {
      frs_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz",
        col_names = FALSE
      )
      names(frs_df) <- c("lat", "lon", month_names)
      frs_df <-
        frs_df %>%
        tidyr::gather(key = "month",
                      value = "frs",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # rd0 ----------------------------------------------------------------------
    if (rd0 == TRUE) {
      rd0_df <- readr::read_table(
        "http://www.cru.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz",
        col_names = FALSE
      )
      names(rd0_df) <- c("lat", "lon", month_names)
      rd0_df <-
        rd0_df %>%
        tidyr::gather(key = "month",
                      value = "rd0",
                      dplyr::everything(),
                      -c(lat, lon))
    }
    # calculate tmx ------------------------------------------------------------
    if (isTRUE(tmx)) {
      # calculate tmax and tmin from tmp and dtr
      tmx_df <- tmp_df[, c(3:14)] + (0.5 * dtr_df[, c(3:14)])
      tmx_df <- dplyr::bind_cols(tmp_df[, 1:2], tmx_df)
    }
    # calculate tmn ------------------------------------------------------------
    if (isTRUE(tmn)) {
      tmn_df <- tmp_df[, c(3:14)] - (0.5 * dtr_df[, c(3:14)])
      tmn_df <- dplyr::bind_cols(tmp_df[, c(1:2)], tmn_df)
    }
    # create data frame of all variables ---------------------------------------
    CRU_list <-
      list(
        dtr_df,
        pre_df,
        reh_df,
        tmn_df,
        tmp_df,
        tmx_df,
        rd0_df,
        elv_df,
        frs_df,
        wnd_df,
        sunp_df
      )
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
