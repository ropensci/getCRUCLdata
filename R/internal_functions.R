#' Preprocess to Determine which CRU CL v. 2.0 Data Files to Import
#'
#' @param pre Load preciptation (millimetres/month)? Boolean.
#' @param pre_cv Load cv of precipitation (percent)? Boolean. Note, setting
#' this to `TRUE` will always result in `pre` being set to `TRUE` and returned
#' as well.
#' @param rd0 Load wet-days (number days with >0.1 millimetres rain per
#' month)? Boolean.
#' @param dtr Load mean diurnal temperature range (degrees Celsius)? Boolean.
#' @param tmp Load temperature (degrees Celsius)? Boolean.
#' @param tmn Calculate minimum temperature values (degrees Celsius)? Boolean.
#' @param tmx Calculate maximum temperature values (degrees Celsius)? Boolean.
#' @param reh Load relative humidity? Boolean.
#' @param sunp Load sunshine, percent of maximum possible (percent of
#' day length)? Boolean.
#' @param frs Load ground-frost records (number of days with ground-frost per
#'  month)? Boolean.
#' @param wnd Load 10m wind speed (metres/second)? Boolean.
#' @param elv Load elevation (converted to metres)? Boolean.
#'
#' @returns A vector of file names to load from local storage or download.
#'
#' @dev
.validate_filter_files <- function(
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
  elv,
  x
) {
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

  files <- .filter_files(
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
  return(files)
}


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

#' Filter Vectors to Provide Only Requested Files to End User
#' @param pre Boolean. If `TRUE`, provides precipitation data.
#' @param pre_cv Boolean. If `TRUE`, provides precipitation data.
#' @param rd0 Boolean. If `TRUE`, provides runoff data.
#' @param tmp Boolean. If `TRUE`, provides temperature data.
#' @param dtr Boolean. If `TRUE`, provides diurnal temperature range data.
#' @param reh Boolean. If `TRUE`, provides relative humidity data.
#' @param tmn Boolean. If `TRUE`, provides minimum temperature data.
#' @param tmx Boolean. If `TRUE`, provides maximum temperature data.
#' @param sunp Boolean. If `TRUE`, provides downloads sunshine data.
#' @param frs Boolean. If `TRUE`, provides frost day frequency data.
#' @param wnd Boolean. If `TRUE`, provides wind speed data.
#' @param elv Boolean. If `TRUE`, provides elevation data.
#' @dev
.filter_files <- function(
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
  file_name_vec <- c(
    pre = "grid_10min_pre.dat.gz",
    rd0 = "grid_10min_rd0.dat.gz",
    tmp = "grid_10min_tmp.dat.gz",
    dtr = "grid_10min_dtr.dat.gz",
    reh = "grid_10min_reh.dat.gz",
    sunp = "grid_10min_sunp.dat.gz",
    frs = "grid_10min_frs.dat.gz",
    wnd = "grid_10min_wnd.dat.gz",
    elv = "grid_10min_elv.dat.gz"
  )

  # check if pre_cv or tmx/tmn (derived) are true, make sure proper ---------
  # parameters set TRUE
  if (pre_cv) {
    pre <- TRUE
  }

  if (any(tmn, tmx)) {
    dtr <- tmp <- TRUE
  }
  # create object list to filter downloads ----------------------------------
  request_files_vec <- c(pre, rd0, tmp, dtr, reh, sunp, frs, wnd, elv)

  return(file_name_vec[which(request_files_vec)])
}

#' Validates user entered file path value
#'
#' @param x User provided value for checking.
#' @param files Validated filanemes to check for agreement with `x` as a dir or
#'  file path.
#' @returns An fs::path_abs object of a validated dsn.
#' @dev
.validate_x <- function(x, files) {
  x <- trimws(x)

  # Normalize path and remove trailing slashes
  x <- fs::path_norm(x)

  # Check if path exists and is a directory
  if (!fs::dir_exists(fs::path_dir(x))) {
    cli::cli_abort(
      "File directory does not exist: {x}.",
      call = rlang::caller_env()
    )
  }

  # Check if user supplied a single .gz file but requested >1 var
  if ((fs::path_ext(x) == ".gz") && (length(files) > 1)) {
    x <- fs::path_dir(x)
    cli::cli_warn(
      "You have supplied a single file {.var x} but have requested multiple
      variables. The file path has been modified to point to the directory level
      and will return all requested parameters, not only the file for which the 
      path was provided, {x}.",
      call = rlang::caller_env()
    )
  }

  return(fs::path_abs(x))
}
