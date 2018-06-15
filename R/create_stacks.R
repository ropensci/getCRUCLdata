#' @noRd
#'
create_stacks <- function(tmn, tmx, tmp, dtr, pre, pre_cv, files) {
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
