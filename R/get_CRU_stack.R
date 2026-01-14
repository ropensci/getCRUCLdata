# This file will be deleted in a future release.
# Please use `read_cru_rast()` instead.

#' Download and create a list of terra rast objects of CRU CL v. 2.0 climatology elements
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @examplesIf interactive()
#'
#' # Download data and create a list of {terra} `rast` objects of precipitation
#' # and temperature without caching the data files
#' cru_pre_tmp <- get_cru_rast(pre = TRUE, tmp = TRUE)
#'
#' cru_pre_tmp
#'
#' @keywords internal

get_CRU_stack <-
  function(
    pre = FALSE,
    pre_cv = FALSE,
    rd0 = FALSE,
    tmp = FALSE,
    dtr = FALSE,
    reh = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  ) {
    lifecycle::deprecate_warn("2.0.0", "create_CRU_df()", "read_cru_dt()")
    .check_vars(
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
    )

    files <- .get_CRU(
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
    )

    if (pre_cv) {
      pre <- TRUE
    }

    return(.create_stacks(tmn, tmx, tmp, dtr, pre, pre_cv, files))
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
      nrows = 930,
      ncols = 2160,
      ymin = -65,
      ymax = 90,
      xmin = -180,
      xmax = 180
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

  names(CRU_stack_list) <- substr(basename(files), 12, 14)

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
    CRU_stack_list[which(names(CRU_stack_list) %in% "dtr")] <- NULL
  }
  if (any(tmx, tmn) && isFALSE(tmp)) {
    CRU_stack_list[which(names(CRU_stack_list) %in% "tmp")] <- NULL
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
      cmd = paste0("gzip -dc ", files[[1]]),
      header = FALSE
    ))
  cells <- terra::cellFromXY(wrld, wvar[, c(2, 1)])
  if (ncol(wvar) == 14) {
    for (j in 3:14) {
      wrld[cells] <- wvar[, j]
      if (j == 3) {
        y <- wrld
      } else {
        y <- c(y, wrld)
      }
    }
    names(y) <- month_names
  } else if (ncol(wvar) == 26) {
    if (pre && pre_cv) {
      for (k in 3:26) {
        wrld[cells] <- wvar[, k]
        if (k == 3) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- c(month_names, paste0("pre_cv_", month_names))
    } else if (pre) {
      for (k in 3:14) {
        wrld[cells] <- wvar[, k]
        if (k == 3) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- month_names
    } else if (pre_cv) {
      for (k in 15:26) {
        wrld[cells] <- wvar[, k]
        if (k == 15) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- paste0("pre_cv_", month_names)
    }
  } else if (ncol(wvar) == 3) {
    wrld[cells] <- wvar[, 3] * 1000
    y <- wrld
    names(y) <- "elv"
  }

  y <- terra::crop(
    y,
    terra::ext(
      -180,
      180,
      -60,
      85
    )
  )
  return(y)
}
