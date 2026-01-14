# This file will be deleted in a future release.
# Please use `read_cru_dt()` instead.

#' Download and create a data.table of CRU CL v. 2.0 climatology elements
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @examplesIf interactive()
#' # Download data and create a data frame of precipitation and temperature
#' cru_pre_tmp <- get_cru_df(pre = TRUE, tmp = TRUE)
#'
#' @keywords internal

get_cru_df <- function(
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

  return(.create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
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
      FUN = .read_cache,
      .pre_cv = pre_cv
    )

  # name the items in the list for the data that they contain ----------------
  names(CRU_list) <- substr(basename(.files), 12, 14)

  # rename the columns in the data frames within the list --------------------
  for (i in seq_along(CRU_list)) {
    wvars <- as.list(substr(basename(.files), 12, 14))
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
  } else if (elv && length(CRU_list) > 1) {
    elv_df <- CRU_list[which(names(CRU_list) %in% "elv")]
    CRU_list[which(names(CRU_list) %in% "elv")] <- NULL
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
  return(CRU_df)
}

#' Read Files From Local cache
#'
#' @param .files a list of CRU CL2.0 files in local storage.
#' @param .pre_cv `Boolean` return pre_cv in the data.
#'
#' @autoglobal
#' @dev

.read_cache <- function(.files, .pre_cv) {
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
    if (.pre_cv) {
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
  } else if (ncol(x) == 3) {
    x_df <- x
    data.table::setnames(x_df, c("lat", "lon", "elv"))
    x_df[, elv := (elv * 1000)]
  }
  return(x_df)
}
