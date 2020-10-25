#' Validates User Entered dsn value
#'
#' @param dsn User provided value for checking
#'
#' @noRd
.validate_dsn <- function(dsn) {
  if (is.null(dsn)) {
    stop(
      "\nYou must define the dsn where you have stored the local files\n",
      "for import. If you want to download files using R, use one of the\n",
      "'get_CRU_*()' functions provided.\n",
      call. = FALSE
    )
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

#' Creates a Data Frame from the CRU Data
#'
#' @param tmn Is tmn to be calculated? Boolean
#' @param tmn Is tmx to be calculated? Boolean
#' @param dtr Is dtr to be returned? Boolean
#' @param pre Is pre to be returned? Boolean
#' @param pre_cv Is pre_cv to be returned? Boolean
#' @param elv Is elv to be returned? Boolean
#' @param files File list to be used for creating data frame
#'
#' @return Data frame of all requested values
#'
#' @importFrom data.table :=
#' @noRd
.create_df <-
  function(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files) {
    month <- NULL

    CRU_df <-
      .tidy_df(pre_cv, elv, tmn, tmx, .files = files)

    if (isTRUE(tmx)) {
      CRU_df[, tmx := tmp + (0.5 * dtr)]
    }

    if (isTRUE(tmn)) {
      CRU_df[, tmn := tmp - (0.5 * dtr)]
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
      levels = c(
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

    data.table::setorder(CRU_df, month)

    return(CRU_df)
  }

#' Read Files from Disk Directory and Tidy Them
#' @noRd
.tidy_df <- function(pre_cv, elv, tmn, tmx, .files) {
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
      merge(..., by = c("lat", "lon", "month")), CRU_list)

  } else if (isTRUE(elv) & length(CRU_list) > 1) {
    elv_df <- CRU_list[which(names(CRU_list) %in% "elv")]
    CRU_list[which(names(CRU_list) %in% "elv")] <- NULL
    CRU_df <- Reduce(function(...)
      merge(..., by = c("lat", "lon", "month")), CRU_list)

    CRU_df <- CRU_df[elv_df$elv, on = c("lat", "lon")]

  } else if (isTRUE(elv)) {
    CRU_df <- CRU_list["elv"]
  }
  return(CRU_df)

  # cleanup before we go -----------------------------------------------------
  rm(c(CRU_list))
}

#' @noRd
.read_cache <- function(.files, .pre_cv) {
  pre_cv <- i.pre_cv <- elv <- NULL
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
    data.table::fread(cmd = paste0("gzip -dc ", .files),
                      header = FALSE)

  if (ncol(x) == 14) {
    data.table::setnames(x, c("lat", "lon", month_names))
    x_df <-
      data.table::melt(
        data = x,
        measure.vars = month_names,
        variable.name = "month"
      )
    data.table::setnames(x_df, c("lat", "lon", "month", "wvar"))

  } else if (ncol(x) == 26) {
    if (isTRUE(.pre_cv)) {
      x_df <- x[, c(1:14)]
      data.table::setnames(x_df, c("lat", "lon", month_names))
      x_df <- data.table::melt(
        data = x_df,
        id.vars = c("lat", "lon"),
        measure.vars = month_names,
        variable.name = "month"
      )
      data.table::setnames(x_df, c("lat", "lon", "month", "pre"))

      x_df2 <- x[, c(1:2, 15:26)]
      data.table::setnames(x_df2, c("lat", "lon", month_names))

      x_df2 <- data.table::melt(
        data = x_df2,
        measure.vars = month_names,
        variable.name = "month"
      )
      data.table::setnames(x_df2, c("lat", "lon", "month", "pre_cv"))

      keycols <- c("lat", "lon", "month")
      data.table::setkeyv(x_df, cols = keycols)
      data.table::setkeyv(x_df2, cols = keycols)
      x_df[x_df2, on = c("lat", "lon", "month"), pre_cv := i.pre_cv]

    } else {
      x_df <- x[, c(1:14)]
      names(x_df) <- c("lat", "lon", month_names)
      x_df <- data.table::melt(
        data = x_df,
        id.vars = c("lat", "lon"),
        measure.vars = month_names,
        variable.name = "month"
      )
      data.table::setnames(x_df, c("lat", "lon", "month", "pre"))
    }
  } else  if (ncol(x) == 3) {
    x_df <- x
    data.table::setnames(x_df, c("lat", "lon", "elv"))
    x_df[, elv := (elv * 1000)]
  }
  return(x_df)
}

#' @noRd
#'
.create_stacks <- function(tmn, tmx, tmp, dtr, pre, pre_cv, files) {
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
    lapply(
      X = files,
      FUN = .create_stack,
      wrld = wrld,
      month_names = month_names,
      pre = pre,
      pre_cv = pre_cv
    )

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
    data.frame(data.table::fread(cmd = paste0("gzip -dc ", files[[1]]),
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

#' @noRd
.get_local <- function(pre,
                       pre_cv,
                       rd0,
                       tmp,
                       dtr,
                       reh,
                       tmn,
                       tmx,
                       sunp,
                       frs,
                       wnd,
                       elv,
                       cache_dir) {
  # check if pre_cv or tmx/tmn (derived) are true, make sure proper ----------
  # parameters set TRUE
  if (isTRUE(pre_cv)) {
    pre <- TRUE
  }

  if (isTRUE(tmn) | isTRUE(tmx)) {
    dtr <- tmp <- TRUE
  }

  dtr_file <- "grid_10min_dtr.dat.gz"
  tmp_file <- "grid_10min_tmp.dat.gz"
  reh_file <- "grid_10min_reh.dat.gz"
  elv_file <- "grid_10min_elv.dat.gz"
  pre_file <- "grid_10min_pre.dat.gz"
  sun_file <- "grid_10min_sunp.dat.gz"
  wnd_file <- "grid_10min_wnd.dat.gz"
  frs_file <- "grid_10min_frs.dat.gz"
  rd0_file <- "grid_10min_rd0.dat.gz"

  object_list <- c(dtr, tmp, reh, elv, pre, sunp, wnd, frs, rd0)

  files <-
    c(
      dtr_file,
      tmp_file,
      reh_file,
      elv_file,
      pre_file,
      sun_file,
      wnd_file,
      frs_file,
      rd0_file
    )
  names(files) <-
    names(object_list) <-
    c(
      "dtr_file",
      "tmp_file",
      "reh_file",
      "elv_file",
      "pre_file",
      "sun_file",
      "wnd_file",
      "frs_file",
      "rd0_file"
    )

  # filter files -------------------------------------------------------------
  # which files are being requested?
  files <- files[object_list %in% !isTRUE(files)]

  # filter files from cache directory in case there are local files for which
  # we do not want data
  cache_dir_contents <- as.list(list.files(cache_dir,
                                           pattern = ".dat.gz$"))

  files <- cache_dir_contents[cache_dir_contents %in% files]

  if (length(files) < 0) {
    stop("\nThere are no CRU CL v. 2.0 data files available in this directory.\n",
         call. = FALSE)
  }

  # add full file path to the files
  files <- file.path(cache_dir, files)

  # fill the space with a "\" for R, if one exists
  files <- gsub(" ", "\\ ", files, fixed = TRUE)

  return(files)
}
