
#' @noRd
.validate_dsn <- function(dsn) {
  if (is.null(dsn)) {
    stop("\nYou must define the dsn where you have stored the local files\n",
         "for import. If you want to download files using R, use one of the\n",
         "'get_CRU_*()' functions provided.\n",
         call. = FALSE)
  } else {
    dsn <- trimws(dsn)
    if (substr(dsn, nchar(dsn) - 1, nchar(dsn)) == "//") {
      p <- substr(dsn, 1, nchar(dsn) - 2)
    } else if (substr(dsn, nchar(dsn), nchar(dsn)) == "/" |
               substr(dsn, nchar(dsn), nchar(dsn)) == "\\") {
      p <- substr(dsn, 1, nchar(dsn) - 1)
    } else {
      p <- dsn
    }
    if (!file.exists(p) & !file.exists(dsn)) {
      stop("\nFile directory does not exist: ", dsn, ".\n",
           call. = FALSE)
    }
  }
}


#' @noRd
.create_df <- function(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files) {
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

#' @noRd
#'
.create_stacks <- function(tmn, tmx, tmp, dtr, pre, pre_cv, files) {
  message("\nCreating raster stack now.\n")
  wrld <-
    raster::raster(
      nrows = 930,
      ncols = 2160,
      ymn = -65,
      ymx = 90,
      xmn = -180,
      xmx = 180
    )

  wrld[] <- NA

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

  # Create raster objects using cellFromXY and generate a raster stack
  # create.stack takes pre, tmp, tmn and tmx and creates a raster
  # object stack of 12 month data

  CRU_stack_list <-
    lapply(X = files,
           FUN = .create_stack,
           wrld = wrld,
           month_names = month_names,
           pre = pre,
           pre_cv = pre_cv)

  names(CRU_stack_list) <- substr(basename(files), 12, 14)

  # cacluate tmn -------------------------------------------------------------
  if (isTRUE(tmn)) {
    CRU_stack_list$tmn <-
      CRU_stack_list$tmp - (0.5 * CRU_stack_list$dtr)
  }
  # cacluate tmx -------------------------------------------------------------
  if (isTRUE(tmx)) {
    CRU_stack_list$tmx <-
      CRU_stack_list$tmp + (0.5 * CRU_stack_list$dtr)
  }

  # cleanup if tmn/tmx specified but tmp/dtr not -----------------------------
  if (any(c(isTRUE(tmx), isTRUE(tmn))) & !isTRUE(dtr)) {
    CRU_stack_list[which(names(CRU_stack_list) %in% "dtr")] <- NULL
  }
  if (any(c(isTRUE(tmx), isTRUE(tmn))) & !isTRUE(tmp)) {
    CRU_stack_list[which(names(CRU_stack_list) %in% "tmp")] <- NULL
  }
  return(CRU_stack_list)
}

#' @noRd
.create_stack <- function(files,
                          wrld,
                          month_names,
                          pre,
                          pre_cv) {
  wvar <-
    data.frame(data.table::fread(paste0("gzip -dc ", files[[1]]),
                                 header = FALSE))
  cells <- raster::cellFromXY(wrld, wvar[, c(2, 1)])
  if (ncol(wvar) == 14) {
    for (j in 3:14) {
      wrld[cells] <- wvar[, j]
      if (j == 3) {
        y <- wrld
      } else
        y <- raster::stack(y, wrld)
    }
    names(y) <- month_names
  } else if (ncol(wvar) == 26) {
    if (isTRUE(pre) & isTRUE(pre_cv)) {
      for (k in 3:26) {
        wrld[cells] <- wvar[, k]
        if (k == 3) {
          y <- wrld
        } else
          y <- raster::stack(y, wrld)
      }
      names(y) <- c(month_names, paste0("pre_cv_", month_names))
    } else if (isTRUE(pre)) {
      for (k in 3:14) {
        wrld[cells] <- wvar[, k]
        if (k == 3) {
          y <- wrld
        } else
          y <- raster::stack(y, wrld)
      }
      names(y) <- month_names
    } else if (isTRUE(pre_cv)) {
      for (k in 15:26) {
        wrld[cells] <- wvar[, k]
        if (k == 15) {
          y <- wrld
        } else
          y <- raster::stack(y, wrld)
      }
      names(y) <- paste0("pre_cv_", month_names)
    }

  } else if (ncol(wvar) == 3) {
    wrld[cells] <- wvar[, 3] * 1000
    y <- wrld
    names(y) <- "elv"
  }

  y <- raster::crop(y, raster::extent(-180,
                                      180,
                                      -60,
                                      85))
  return(y)
}

.set_cache <- function(cache) {
  if (isTRUE(cache)) {
    if (!dir.exists(manage_cache$cache_path_get())) {
      manage_cache$mkdir()
    }
    cache_dir <- manage_cache$cache_path_get()
  } else {
    cache_dir <- tempdir()
  }
  return(cache_dir)
}
