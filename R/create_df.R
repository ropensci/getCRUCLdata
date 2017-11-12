
#' @noRd

create_df <- function(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files) {
  month <- NULL

  CRU_df <-
    .tidy_df(pre_cv, elv, tmn, tmx, .files = files)

  if (isTRUE(tmx)) {
    CRU_df <- dplyr::mutate(CRU_df, tmx =  tmp + (0.5 * dtr))
  }

  if (isTRUE(tmn)) {
    CRU_df <- dplyr::mutate(CRU_df, tmn =  tmp - (0.5 * dtr))
  }

  # Remove tmp/dtr if they aren't specified (necessary for tmn/tmx)
  if (isTRUE(tmx) | isTRUE(tmn)) {
    if (!isTRUE(tmp)) {
      CRU_df <- subset(CRU_df, select = -tmp)
    }

    if (!isTRUE(dtr)) {
      CRU_df <- subset(CRU_df, select = -dtr)
    }
  }
  CRU_df$month <- factor(
    CRU_df$month,
    levels <-  c(
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
  )

  CRU_df <- dplyr::arrange(CRU_df, month)

  return(tibble::as_tibble(CRU_df))
}

#' @noRd
.tidy_df <- function(pre_cv, elv, tmn, tmx, .files) {
  # internal function to read files from cache directory and tidy them -------

  # create list of tidied data frames ----------------------------------------
  CRU_list <-
    lapply(X = .files,
           FUN = .read_cache,
           .pre_cv = pre_cv)

  # name the items in the list for the data that they contain ----------------
  names(CRU_list) <- substr(basename(.files), 12, 14)

  # rename the columns in the data frames within the list --------------------
  for (i in seq_along(CRU_list)) {
    wvars <- as.list(substr(basename(.files), 12, 14))
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
  rm(c(CRU_list))
}

#' @noRd
.read_cache <- function(.files, .pre_cv) {
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
    tibble::as_tibble(data.table::fread(paste0("gzip -dc ", .files),
                                        header = FALSE))

  if (ncol(x) == 14) {
    names(x) <- c("lat", "lon", month_names)
    x_df <-
      tidyr::gather(x,
                    key = "month",
                    value = "wvar",
                    dplyr::everything(),
                    -c(lat, lon))
  } else if (ncol(x) == 26) {
    if (isTRUE(.pre_cv)) {
      x_df1 <- x[, c(1:14)]
      names(x_df1) <- c("lat", "lon", month_names)
      x_df1 <- tidyr::gather(x_df1,
                             key = "month",
                             value = "pre",
                             dplyr::everything(),
                             -c(lat, lon))
      x_df2 <- x[, c(1:2, 15:26)]
      names(x_df2) <- c("lat", "lon", month_names)

      x_df2 <- tidyr::gather(x_df2,
                             key = "month",
                             value = "pre_cv",
                             dplyr::everything(),
                             -c(lat, lon))
      x_df <-
        dplyr::left_join(x_df1, x_df2, by = c("lat", "lon", "month"))
    } else {
      x_df <- x[, c(1:14)]
      names(x_df) <- c("lat", "lon", month_names)
      x_df <-
        tidyr::gather(x_df,
                      key = "month",
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
