#' Check that at least one element is requested
#'
#' @param pre Fetches precipitation (millimetres/month) from server and
#' returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param pre_cv Fetches cv of precipitation (percent) from server and
#' returns it in the data frame, `TRUE`. Defaults to `FALSE`.  Note, setting
#' this to `TRUE` will always result in **pre** being set to `TRUE` and returned
#' as well.
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
#' # passes, all are TRUE
#' .check_vars(
#'   pre = TRUE,
#'   pre_cv = TRUE,
#'   rd0 = TRUE,
#'   tmp = TRUE,
#'   dtr = TRUE,
#'   reh = TRUE,
#'   tmn = TRUE,
#'   tmx = TRUE,
#'   sunp = TRUE,
#'   frs = TRUE,
#'   wnd = TRUE,
#'   elv = TRUE
#' )
#'
#' @returns Called for its side effect of throwing an error if no vars are
#'  selected. Returns an invisible `NULL`.
#' @dev

.check_vars <- function(
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
  return(invisible(NULL))
}

#' Validates user entered file path value
#'
#' @param x User provided value for checking.
#' @returns An fs::path_abs object of a validated dsn.
#' @dev
.validate_x <- function(x) {
  if (missing(x)) {
    cli::cli_abort(
      "You must define the directory ({.var dsn}) where you have stored the
      local files for import. If you want to download files using R, use one of
      the {.fn get_cru} functions provided.",
      call = rlang::caller_env()
    )
    return(invisible(NULL))
  }

  # Trim whitespace
  x <- trimws(x)

  # Normalize path and remove trailing slashes
  x <- fs::path_norm(x)

  # Check if path exists and is a directory
  if (!fs::dir_exists(x)) {
    cli::cli_abort(
      "File directory does not exist: {.var x}.",
      call = rlang::caller_env()
    )
  }

  return(fs::path_abs(x))
}


#' Creates a data.table from the CRU data
#'
#' @param tmn Is tmn to be calculated? Boolean.
#' @param tmn Is tmx to be calculated? Boolean.
#' @param dtr Is dtr to be returned? Boolean.
#' @param pre Is pre to be returned? Boolean.
#' @param pre_cv Is pre_cv to be returned? Boolean.
#' @param elv Is elv to be returned? Boolean.
#' @param files File list to be used for creating data frame. List.
#'
#' @returns A \CRANpkg{data.table} of all requested values.
#' @autoglobal
#' @dev
.create_dt <-
  function(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files) {
    cru_dt <-
      .tidy_dt(pre_cv, elv, tmn, tmx, .files = files)

    if (tmx) {
      cru_dt[, tmx := tmp + (0.5 * dtr)]
    }

    if (tmn) {
      cru_dt[, tmn := tmp - (0.5 * dtr)]
    }

    # Remove tmp/dtr if they aren't specified (necessary for tmn/tmx)
    if (any(tmx, tmn) && isFALSE(tmp)) {
      cru_dt[, tmp := NULL]

      # if dtr is not requested, drop from the data.table
      if (isFALSE(dtr)) {
        cru_dt[, dtr := NULL]
      }
    }

    cru_dt[, month := factor(cru_dt$month)]

    data.table::setorder(cru_dt, month)

    return(cru_dt[])
  }

#' Read Files from Disk Directory and Tidy Them
#' @dev

.tidy_dt <- function(pre_cv, elv, tmn, tmx, .files) {
  # create list of tidied data frames ----------------------------------------
  cru_list <-
    lapply(
      X = .files,
      FUN = .read_local_files,
      .pre_cv = pre_cv
    )

  # name the items in the list for the data that they contain ----------------
  names(cru_list) <- substr(fs::path_file(.files), 12L, 14L)

  # rename the columns in the data frames within the list --------------------
  for (i in seq_along(cru_list)) {
    wvars <- as.list(substr(fs::path_file(.files), 12L, 14L))
    names(cru_list[[i]])[names(cru_list[[i]]) == "wvar"] <- wvars[[i]]
  }

  # lastly merge the data frames into one tidy (large) data frame --------------

  if (isFALSE(elv)) {
    cru_df <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      cru_list
    )
  } else if (elv && length(cru_list) > 1L) {
    elv_df <- cru_list[which(names(cru_list) == "elv")]
    cru_list[which(names(cru_list) == "elv")] <- NULL
    cru_df <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      cru_list
    )

    cru_df <- cru_df[elv_df$elv, on = c("lat", "lon")]
  } else if (elv) {
    cru_df <- cru_list["elv"]
  }
  return(cru_df[])
}

#' Read Files From Local Disk
#'
#' @param .files a list of CRU CL2.0 files in `tempdir()`.
#' @param .pre_cv Boolean flag to return pre_cv in the data.
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
      .files,
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
