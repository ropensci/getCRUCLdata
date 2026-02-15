#' Create a data.table of CRU CL v. 2.0 climatology elements
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology data and
#' from either the CRU server or local files and creates a \CRANpkg{data.table}
#' of the data. If requested, minimum and maximum temperature may also be
#' calculated as described in the data
#' [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file and
#' returned.
#'
#' @section Nomenclature and Units:
#' \describe{
#' \item{pre}{precipitation (millimetres/month)}
#'   \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'   }
#' \item{rd0}{wet-days (number days with >0.1 millimetres rain per month)}
#' \item{tmp}{mean temperature (degrees Celsius)}
#' \item{dtr}{mean diurnal temperature range (degrees Celsius)}
#' \item{reh}{relative humidity (percent)}
#' \item{sunp}{sunshine (percent of maximum possible (percent of day length))}
#' \item{frs}{ground-frost (number of days with ground-frost per month)}
#' \item{wnd}{10 metre windspeed (metres/second)}
#' \item{elv}{elevation (automatically converted to metres from kilometres)}
#' }
#' For more information see the description of the data provided by
#' \acronym{CRU}, <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>
#'
#' @param pre Reads precipitation (millimetres/month) and returns in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param pre_cv Reads cv of precipitation (percent) and returns in the
#'  data.table, `TRUE`. Defaults to `FALSE`. NOTE. Setting this
#'  to `TRUE` will always results in `pre` being set to `TRUE` and
#'  returned as well.
#' @param rd0 Reads wet-days (number days with >0.1 millimetres rain per
#'  month) and returns in the data.table, `TRUE`. Defaults to `FALSE`.
#' @param dtr Reads mean diurnal temperature range (degrees Celsius)
#'  and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmp Reads temperature (degrees Celsius) and returns it in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param tmn Calculate minimum temperature values (degrees Celsius)
#'  and returns it in the data.table, `TRUE`. Defaults to `FALSE`.
#' @param tmx Calculate maximum temperature (degrees Celsius) and returns it in
#'  the data.table, `TRUE`. Defaults to `FALSE`.
#' @param reh Reads relative humidity and returns it in the data.table, `TRUE`.
#'  Defaults to `FALSE`.
#' @param sunp Reads sunshine, percent of maximum possible (percent of
#'  day length) and returns it in the data.table, `TRUE`. Defaults to `FALSE`.
#' @param frs Reads ground-frost records (number of days with ground-
#'  frost per month) and returns it in the data.table, `TRUE`. Defaults to
#'  `FALSE`.
#' @param wnd Load 10 m wind speed (metres/second) and returns it in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param elv Reads elevation (converted to metres) and returns it in the
#'  data.table, `TRUE`. Defaults to `FALSE`.
#' @param x An optional local file path where \acronym{CRU} \acronym{CL} v.2.0
#'  .dat.gz files are located.  If this is empty, the requested data will
#'  automatically be downloaded from the server.
#'
#' @examplesIf interactive()
#' # Create a data frame of temperature from locally available files in the
#' # tempdir() directory.
#' library(fs)
#'
#' f <- path(path_temp(), "grid_10min_tmp.dat.gz")
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = f
#' )
#'
#'
#' cru_tmp <- read_cru_dt(tmp = TRUE, x = f)
#'
#' cru_tmp
#'
#' # or downloading directly from the CRU server
#'
#' cru_tmp <- read_cru_dt(tmp = TRUE)
#'
#' cru_tmp
#'
#' @seealso [read_cru_rast].
#'
#' @returns A [data.table::data.table] object of \acronym{CRU} \acronym{CL} v.
#'  2.0 climatology elements.
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#'
#' @source
#' \describe{
#'  \item{pre}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz>}
#'  \item{rd0}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz>}
#'  \item{tmp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz>}
#'  \item{dtr}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz>}
#'  \item{reh}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz>}
#'  \item{sunp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz>}
#'  \item{frs}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz>}
#'  \item{wnd}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz>, areas originally including Antarctica are removed.}
#'  \item{elv}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz>, values are converted from kilometres to metres.}
#' }
#' This package crops all spatial outputs to an extent of ymin = -60, ymax = 85,
#' xmin = -180, xmax = 180.
#'
#' @references New, Mark, et al. "A high-resolution data set of surface climate
#'  over global land areas." Climate research 21.1 (2002): 1-25.
#'  <https://crudata.uea.ac.uk/cru/data/hrg/tmc/new_et_al_10minute_climate_CR.pdf>
#'
#' @export

read_cru_dt <- function(
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
  elv = FALSE,
  x = NULL
) {
  files <- .validate_filter_files(
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

  if (is.null(x)) {
    files <- .get_cru(files)
  } else {
    files <- .validate_x(x)

    # when we have a single file requested/provided, return it
    if (grepl("\\.gz$", x)) {
      return(files)
    }
    local_files <- fs::dir_ls(x, regexp = "\\.dat\\.gz$", recurse = FALSE)

    files <- local_files[local_files %in% files]

    if (length(files) == 0L) {
      cli::cli_abort(
        "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
      )
    }
    return(files)
  }

  return(.create_dt(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
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


#' Read Files from Disk Directory as a data.table
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
    cru_dt <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      cru_list
    )
  } else if (elv && length(cru_list) > 1L) {
    elv_dt <- cru_list[which(names(cru_list) == "elv")]
    cru_list[which(names(cru_list) == "elv")] <- NULL
    cru_dt <- Reduce(
      function(...) {
        merge(..., by = c("lat", "lon", "month"))
      },
      cru_list
    )

    cru_dt <- cru_dt[elv_dt$elv, on = c("lat", "lon")]
  } else if (elv) {
    cru_dt <- cru_list["elv"]
  }
  return(cru_dt[])
}


#' Read Files From Local Disk Using data.table
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
