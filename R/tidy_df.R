#' @importFrom dplyr %>%
#' @noRd
.tidy_df <- function(dtr, tmp, tmn, tmx, pre, pre_cv, reh, elv, sunp, wnd, frs,
                     rd0, cache_dir){

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
  if (isTRUE(dtr) | isTRUE(tmn) | isTRUE(tmx)) {
    dtr_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_dtr.dat.gz"),
                        col_names = FALSE)
    names(dtr_df) <- c("lat", "lon", month_names)
    dtr_df <-
      dtr_df %>%
      tidyr::gather(key = "month",
                    value = "dtr",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # tmp ----------------------------------------------------------------------
  if (isTRUE(tmp) | isTRUE(tmn) | isTRUE(tmx)) {
    tmp_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_tmp.dat.gz"),
                        col_names = FALSE)
    names(tmp_df) <- c("lat", "lon", month_names)
    tmp_df <-
      tmp_df %>%
      tidyr::gather(key = "month",
                    value = "tmp",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # pre ----------------------------------------------------------------------
  if (isTRUE(pre)) {
    pre_df <- readr::read_table(paste0(cache_dir, "/grid_10min_pre.dat.gz"),
                                col_names = FALSE)
    # split the data frame into two, otherwise we get errors on C stack usage
    pre_df1 <- pre_df[, c(1:14)]

    names(pre_df1) <- c("lat", "lon", month_names)
    pre_df1 <-
      pre_df1 %>%
      tidyr::gather(key = "month",
                    value = "pre",
                    dplyr::everything(),
                    -c(lat, lon))
    if (isTRUE(pre_cv)) {
      pre_df2 <- pre_df[, c(1:2, 15:26)]
      names(pre_df1) <- c("lat", "lon", month_names)
      pre_df2 <-
        pre_df2 %>%
        tidyr::gather(key = "month",
                      value = "pre_cv",
                      dplyr::everything(),
                      -c(lat, lon))
      pre_df <- dplyr::bind_cols(pre_df1, pre_df2[, 4])
    } else {
      (pre_df <- pre_df1)
    }
  }
  # reh ----------------------------------------------------------------------
  if (isTRUE(reh)) {
    reh_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_reh.dat.gz"),
                        col_names = FALSE)
    names(reh_df) <- c("lat", "lon", month_names)
    reh_df <-
      reh_df %>%
      tidyr::gather(key = "month",
                    value = "reh",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # elv ----------------------------------------------------------------------
  if (isTRUE(elv)) {
    elv_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_elv.dat.gz"),
                        col_names = FALSE)
    names(elv_df) <- c("lat", "lon", "elv_m")
    elv_df[, 3] <- elv_df[, 3] * 1000
  }
  # sunp ----------------------------------------------------------------------
  if (isTRUE(sunp)) {
    sunp_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_sunp.dat.gz"),
                        col_names = FALSE)
    names(sunp_df) <- c("lat", "lon", month_names)
    sunp_df <-
      sunp_df %>%
      tidyr::gather(key = "month",
                    value = "sunp",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # wnd ----------------------------------------------------------------------
  if (isTRUE(wnd)) {
    wnd_df <- readr::read_table(paste0("/grid_10min_wnd.dat.gz"),
                                col_names = FALSE)
    names(wnd_df) <- c("lat", "lon", month_names)
    wnd_df <-
      wnd_df %>%
      tidyr::gather(key = "month",
                    value = "wnd",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # frs ----------------------------------------------------------------------
  if (isTRUE(frs)) {
    frs_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_frs.dat.gz"),
                        col_names = FALSE)
    names(frs_df) <- c("lat", "lon", month_names)
    frs_df <-
      frs_df %>%
      tidyr::gather(key = "month",
                    value = "frs",
                    dplyr::everything(),
                    -c(lat, lon))
  }
  # rd0 ----------------------------------------------------------------------
  if (isTRUE(rd0)) {
    rd0_df <-
      readr::read_table(paste0(cache_dir, "/grid_10min_rd0.dat.gz"),
                        col_names = FALSE)
    names(rd0_df) <- c("lat", "lon", month_names)
    rd0_df <-
      rd0_df %>%
      tidyr::gather(key = "month",
                    value = "rd0",
                    dplyr::everything(),
                    -c(lat, lon))
  }

  # calculate tmn/tmx
  if (isTRUE(tmx)) {
    tmx_df <- .calculate_tmx(tmp_df, dtr_df)
  }
  if (isTRUE(tmn)) {
    tmn_df <- .calculate_tmn(tmp_df, dtr_df)
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

  CRU_df <- plyr::ldply(CRU_list, data.frame)
  return(CRU_df)
}
