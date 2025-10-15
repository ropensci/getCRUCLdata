#' Check that at least one element is requested
#' @param pre Fetches precipitation (millimetres/month) from server and
#' returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param pre_cv Fetches cv of precipitation (percent) from server and
#' returns it in the data frame, `TRUE`. Defaults to `FALSE`.  Note, setting
#' this to `TRUE` will always results in **pre** being set to `TRUE` and
#' returned as well.
#' @param rd0 Fetches wet-days (number days with >0.1 millimetres rain per
#' month) and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param dtr Fetches mean diurnal temperature range (degrees Celsius)
#' and returns it in the data frame, `TRUE`.  Defaults to `FALSE`.
#' @param tmp Fetches temperature (degrees Celsius) and returns it in the
#' data frame, `TRUE`.  Defaults to `FALSE`.
#' @param tmn Calculates minimum temperature values (degrees Celsius)
#' and returns it in the data frame. Defaults to `FALSE`.
#' @param tmx Boolean. Calculates maximum temperature (degrees Celsius) and
#' returns it in the data frame, `TRUE`.  Defaults to `FALSE`.
#' @param reh Fetches relative humidity and returns it in the data frame,
#' `TRUE`. Defaults to `FALSE`.
#' @param sunp Fetches sunshine, percent of maximum possible (percent of
#' day length), and returns it in the data frame, `TRUE`.  Defaults to `FALSE`.
#' @param frs Boolean. Fetches ground-frost records (number of days with
#' ground-frost per month) and returns it in data frame, `TRUE`.  Defaults to
#' `FALSE`.
#' @param wnd Fetches 10m wind speed (metres/second) and returns it in the data
#' frame, `TRUE`. Defaults to `FALSE`.
#' @param elv Fetches elevation (converted to metres) and returns it in the
#' data frame, `TRUE`. Defaults to `FALSE`.
#'
#' @examples
#' .check_vars_FALSE(
#'   pre,
#'   pre_cv,
#'   rd0,
#'   tmp,
#'   dtr,
#'   reh,
#'   tmn,
#'   tmx,
#'   sunp,
#'   frs,
#'   wnd,
#'   elv
#' )
#' @dev

.check_vars_FALSE <- function(
  pre,
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
  elv
) {
  if (!any(pre, pre_cv, rd0, tmp, dtr, reh, tmn, tmx, sunp, frs, wnd, elv)) {
    cli::cli_abort(
      "You must select at least one element for download or import.",
      call = rlang::caller_env()
    )
  }
}

#' Validates user entered dsn value
#'
#' @param dsn User provided value for checking.

#' @dev
.validate_dsn <- function(dsn) {
  if (missing(dsn)) {
    cli::cli_abort(
      "You must define the dsn where you have stored the local files
      for import. If you want to download files using R, use one of the
      {.fn get_CRU} functions provided.",
      call = rlang::caller_env()
    )
  } else {
    dsn <- trimws(dsn)
    if (substr(dsn, nchar(dsn) - 1, nchar(dsn)) == "//") {
      p <- substr(dsn, 1L, nchar(dsn) - 2L)
    } else if (
      substr(dsn, nchar(dsn), nchar(dsn)) == "/" |
        substr(dsn, nchar(dsn), nchar(dsn)) == "\\"
    ) {
      p <- substr(dsn, 1L, nchar(dsn) - 1L)
    } else {
      p <- dsn
    }
    if (!file.exists(p) || !file.exists(dsn)) {
      cli::cli_abort(
        "File directory does not exist: {.var dsn}.",
        call = rlang::caller_env()
      )
    }
  }
}

#' Creates a data.table from the CRU data
#'
#' @param tmn Is tmn to be calculated? Boolean.
#' @param tmn Is tmx to be calculated? Boolean.
#' @param dtr Is dtr to be returned? Boolean.
#' @param pre Is pre to be returned? Boolean.
#' @param pre_cv Is pre_cv to be returned? Boolean.
#' @param elv Is elv to be returned? Boolean.
#' @param files File list to be used for creating data frame.
#'
#' @returns A \CRANpkg{data.table} of all requested values.
#' @autoglobal
#' @dev
.create_df <-
  function(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files) {
    CRU_df <-
      .tidy_df(pre_cv, elv, tmn, tmx, .files = files)

    if (tmx) {
      CRU_df[, tmx := tmp + (0.5 * dtr)]
    }

    if (tmn) {
      CRU_df[, tmn := tmp - (0.5 * dtr)]
    }

    # Remove tmp/dtr if they aren't specified (necessary for tmn/tmx)
    if (any(tmx, tmn) && isFALSE(tmp)) {
      CRU_df[, tmp := NULL]

      # if dtr is not requested, drop from the data.table
      if (isFALSE(dtr)) {
        CRU_df[, dtr := NULL]
      }
    }

    CRU_df[, month := factor(CRU_df$month)]

    data.table::setorder(CRU_df, month)

    return(CRU_df[])
  }

#' Read Files from Disk Directory and Tidy Them
#' @dev

.tidy_df <- function(pre_cv, elv, tmn, tmx, .files) {
  # create list of tidied data frames ----------------------------------------
  CRU_list <-
    lapply(
      X = .files,
      FUN = .read_local_files,
      .pre_cv = pre_cv
    )

  # name the items in the list for the data that they contain ----------------
  names(CRU_list) <- substr(basename(.files), 12L, 14L)

  # rename the columns in the data frames within the list --------------------
  for (i in seq_along(CRU_list)) {
    wvars <- as.list(substr(basename(.files), 12L, 14L))
    names(CRU_list[[i]])[names(CRU_list[[i]]) == "wvar"] <-
      wvars[[i]]
  }

  # lastly merge the data frames into one tidy (large) data frame --------------

  if (isFALSE(elv)) {
    CRU_df <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      CRU_list
    )
  } else if (elv && length(CRU_list) > 1L) {
    elv_df <- CRU_list[which(names(CRU_list) == "elv")]
    CRU_list[which(names(CRU_list) == "elv")] <- NULL
    CRU_df <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      CRU_list
    )

    CRU_df <- CRU_df[elv_df$elv, on = c("lat", "lon")]
  } else if (elv) {
    CRU_df <- CRU_list["elv"]
  }
  return(CRU_df[])
}

#' Read Files From Local Disk
#'
#' @param .files a list of CRU CL2.0 files in local storage.
#' @param .pre_cv `Boolean` return pre_cv in the data.
#'
#' @autoglobal
#' @dev
.read_local_files <- function(.files, .pre_cv) {
  month_names <-
    c(
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

  x <-
    data.table::fread(
      cmd = paste0("gzip -dc ", .files),
      header = FALSE
    )

  if (ncol(x) == 14L) {
    data.table::setnames(x, c("lat", "lon", month_names))
    x_df <-
      data.table::melt(
        data = x,
        measure.vars = month_names,
        variable.name = "month"
      )
    data.table::setnames(x_df, c("lat", "lon", "month", "wvar"))
  } else if (ncol(x) == 26L) {
    if (.pre_cv) {
      x_df <- x[, 1L:14L]
      data.table::setnames(x_df, c("lat", "lon", month_names))
      x_df <- data.table::melt(
        data = x_df,
        id.vars = c("lat", "lon"),
        measure.vars = month_names,
        variable.name = "month"
      )
      data.table::setnames(x_df, c("lat", "lon", "month", "pre"))

      x_df2 <- x[, c(1L:2L, 15L:26L)]
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
      x_df <- x[, 1L:14L]
      names(x_df) <- c("lat", "lon", month_names)
      x_df <- data.table::melt(
        data = x_df,
        id.vars = c("lat", "lon"),
        measure.vars = month_names,
        variable.name = "month"
      )
      data.table::setnames(x_df, c("lat", "lon", "month", "pre"))
    }
  } else if (ncol(x) == 3L) {
    x_df <- x
    data.table::setnames(x_df, c("lat", "lon", "elv"))
    x_df[, elv := (elv * 1000L)]
  }
  return(x_df[])
}


#' Create terra rast objects
#'
#' @param pre Return precipitation in the `rast`, Boolean.
#' @param pre_cv Return cv of precipitation (percent) in the `rast`, Boolean.
#' @param dtr Return mean diurnal temperature range (degrees Celsius)
#'  in the `rast`, Boolean.
#' @param tmp Return temperature (degrees Celsius) in the `rast`, Boolean.
#' @param tmn Return minimum temperature values (degrees Celsius)
#'  in the `rast`, Boolean.
#' @param tmx Return maximum temperature (degrees Celsius) in the
#'  `rast`, Boolean.
#' @param files List. Files that are to be used in creating the `rast` object.
#'
#' @autoglobal
#' @dev
#'
.create_stacks <- function(tmn, tmx, tmp, dtr, pre, pre_cv, files) {
  wrld <-
    terra::rast(
      nrows = 930L,
      ncols = 2160L,
      ymin = -65L,
      ymax = 90L,
      xmin = -180L,
      xmax = 180L
    )

  wrld[] <- NA

  month_names <-
    c(
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

  # Create terra objects using cellFromXY() and generate a terra rast
  # create.stack takes pre, tmp, tmn and tmx and creates a terra rast
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

  names(CRU_stack_list) <- substr(basename(files), 12L, 14L)

  # calculate tmn -------------------------------------------------------------
  if (tmn) {
    CRU_stack_list$tmn <-
      CRU_stack_list$tmp - (0.5 * CRU_stack_list$dtr)
  }
  # calculate tmx -------------------------------------------------------------
  if (tmx) {
    CRU_stack_list$tmx <-
      CRU_stack_list$tmp + (0.5 * CRU_stack_list$dtr)
  }

  # cleanup if tmn/tmx specified but tmp/dtr not -----------------------------
  if (any(tmx, tmn) && isFALSE(dtr)) {
    CRU_stack_list[which(names(CRU_stack_list) == "dtr")] <- NULL
  }
  if (any(tmx, tmn) && isFALSE(tmp)) {
    CRU_stack_list[which(names(CRU_stack_list) == "tmp")] <- NULL
  }
  return(CRU_stack_list)
}

#' Helper Function Used in .create_stacks()
#'
#' @param files A list of files to use in creating `rast` objects.
#' @param wrld An empty [terra::rast] object for filling with values.
#' @param month_names A vector of month names from jan -- dec.
#' @param pre `Boolean` include precipitation.
#' @param pre_cv `Boolean` include precipitation cv.
#'
#' @autoglobal
#' @dev
.create_stack <- function(files, wrld, month_names, pre, pre_cv) {
  wvar <-
    data.frame(data.table::fread(
      cmd = paste0("gzip -dc ", files[[1L]]),
      header = FALSE
    ))
  cells <- terra::cellFromXY(wrld, wvar[, c(2L, 1L)])
  if (ncol(wvar) == 14L) {
    for (j in 3L:14L) {
      wrld[cells] <- wvar[, j]
      if (j == 3L) {
        y <- wrld
      } else {
        y <- c(y, wrld)
      }
    }
    names(y) <- month_names
  } else if (ncol(wvar) == 26L) {
    if (pre && pre_cv) {
      for (k in 3L:26L) {
        wrld[cells] <- wvar[, k]
        if (k == 3L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- c(month_names, paste0("pre_cv_", month_names))
    } else if (pre) {
      for (k in 3L:14L) {
        wrld[cells] <- wvar[, k]
        if (k == 3L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- month_names
    } else if (pre_cv) {
      for (k in 15L:26L) {
        wrld[cells] <- wvar[, k]
        if (k == 15L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- paste0("pre_cv_", month_names)
    }
  } else if (ncol(wvar) == 3L) {
    wrld[cells] <- wvar[, 3L] * 1000L
    y <- wrld
    names(y) <- "elv"
  }

  y <- terra::crop(
    y,
    terra::ext(
      -180L,
      180L,
      -60L,
      85L
    )
  )
  return(y)
}
