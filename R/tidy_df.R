#' @importFrom dplyr %>%
#' @noRd
.tidy_df <- function(pre_cv, elv, tmn, tmx, cache_dir) {
  files <-
    list.files(cache_dir, pattern = ".dat.gz$", full.names = TRUE)

  # internal function to read files from cache directory and tidy them -------

  # create list of tidied data frames ----------------------------------------
  CRU_list <-
    plyr::llply(
      .data = files,
      .fun = .read_cache,
      .pre_cv = pre_cv,
      .progress = "text"
    )

  # name the items in the list for the data that they contain ----------------
  names(CRU_list) <- substr(basename(files), 12, 14)

  # rename the columns in the data frames within the list --------------------
  for (i in seq_along(CRU_list)) {
    wvars <- as.list(substr(basename(files), 12, 14))
    names(CRU_list[[i]])[names(CRU_list[[i]]) == "wvar"] <-
      wvars[[i]]
  }

  # lastly merge the data frames into one tidy (large) data frame --------------
  if (!isTRUE(elv)) {
    CRU_df <- Reduce(function(...)
      dplyr::full_join(..., by = c("lat", "lon", "month")), CRU_list)
  } else if (isTRUE(elv) & length(CRU_list) > 1) {
    elv_df <- as.data.frame(CRU_list["elv"])
    names(elv_df) <- c("lat", "lon", "elv")
    CRU_list[which(names(CRU_list) %in% c("elv"))] <- NULL
    CRU_df <- Reduce(function(...)
      dplyr::full_join(..., by = c("lat", "lon", "month")), CRU_list)
    CRU_df <- dplyr::left_join(CRU_df, elv_df, by = c("lat", "lon"))
  } else if (isTRUE(elv)) {
    CRU_df <- as.data.frame(CRU_list["elv"])
    names(CRU_df) <- c("lat", "lon", "elv")
  }
  return(CRU_df)

  # cleanup before we go -----------------------------------------------------
  rm(c(CRU_list, files))
}

#' @noRd
.read_cache <- function(files, .pre_cv) {
  lat <- NULL
  lon <- NULL
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

  x <-
    utils::read.table(files, header = FALSE, colClasses = "numeric")

  if (ncol(x) == 14) {
    names(x) <- c("lat", "lon", month_names)
    x_df <-
      x %>%
      tidyr::gather(key = "month",
                    value = "wvar",
                    dplyr::everything(),
                    -c(lat, lon))
  } else if (ncol(x) == 26) {
    if (isTRUE(.pre_cv)) {
      x_df1 <- x[, c(1:14)]
      names(x_df1) <- c("lat", "lon", month_names)
      x_df1 <-
        x_df1 %>%
        tidyr::gather(key = "month",
                      value = "pre",
                      dplyr::everything(),
                      -c(lat, lon))
      x_df2 <- x[, c(1:2, 15:26)]
      names(x_df2) <- c("lat", "lon", month_names)
      x_df2 <-
        x_df2 %>%
        tidyr::gather(key = "month",
                      value = "pre_cv",
                      dplyr::everything(),
                      -c(lat, lon))
      x_df <-
        dplyr::left_join(x_df1, x_df2, by = c("lat", "lon", "month"))
    } else {
      x_df <- x[, c(1:14)]
      names(x_df) <- c("lat", "lon", month_names)
      x_df <-
        x_df %>%
        tidyr::gather(key = "month",
                      value = "pre",
                      dplyr::everything(),
                      -c(lat, lon))
    }
  }
  else if (ncol(x) == 3) {
    x_df <- data.frame(x[, c(1, 2)], x[, 3] * 1000)
  }
  return(x_df)
}
