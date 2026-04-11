#' Create a terra rast object of CRU CL v. 2.0 climatology elements
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{terra} [terra::rast] object of the
#' data.  If requested, minimum and maximum temperature may also be
#' automatically calculated as described in the data
#' [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file.
#' Data may be cached for later use by this function, saving time downloading
#' files in future using this function.  This function can be useful if you
#' have network connection issues that mean automated downloading of the files
#' using \R does not work properly or you have cached the files locally for
#' your own future use.
#'
#' @inheritSection read_cru_dt Nomenclature and Units
#' @inheritParams read_cru_dt
#' @inherit read_cru_dt author
#' @inherit read_cru_dt source
#' @inherit read_cru_dt references
#'
#' @examplesIf interactive()
#'
#' # Downloading directly from the CRU server
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE)
#'
#' # Using a local file, downloaded to tempdir() for this example
#' library(fs)
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' f <- path(path_temp(), "grid_10min_tmp.dat.gz")
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE, x = f)
#'
#' cru_tmp
#'
#' # or download from the CRU server automatically
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE)
#'
#' cru_tmp
#'
#' @seealso [read_cru_dt].
#'
#' @returns A [terra::rast] object of \acronym{CRU} \acronym{CL} v. 2.0
#'  climatology elements.
#'
#' @export

read_cru_rast <- function(
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
  #TODO: be sure that pre_cv is handled correctly in the rast creation

  if (is.null(x)) {
    files <- .get_cru(files)
  } else {
    .validate_x(x)

    local_files <- fs::dir_ls(x, regexp = "\\.dat\\.gz$", recurse = FALSE)

    files <- local_files[basename(local_files) %in% files]
    if (length(files) == 0L) {
      cli::cli_abort(
        "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
      )
    }
  }

  files <- fs::path(fs::path_temp(), files)
  return(.create_rast(tmn, tmx, tmp, dtr, pre, pre_cv, files))
}


#' Create terra rast objects
#'
#' @param tmn Return minimum temperature values (degrees Celsius)
#' @param tmx Return maximum temperature (degrees Celsius) in the
#'  `rast`? Boolean.
#' @param tmp Return temperature (degrees Celsius) in the `rast`, Boolean.
#'  in the `rast`? Boolean.
#' @param dtr Return mean diurnal temperature range (degrees Celsius)
#'  in the `rast`? Boolean.
#' @param pre Return precipitation in the `rast`? Boolean.
#' @param pre_cv Return cv of precipitation (percent) in the `rast`? Boolean.
#' @param files Files that are to be used in creating the `rast` object. Vector.
#' @autoglobal
#' @dev

.create_rast <- function(tmn, tmx, tmp, dtr, pre, pre_cv, files) {
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
  # create.rast takes pre, tmp, tmn and tmx and creates a terra rast
  # object rast of 12 month data

  cru_rast_list <-
    lapply(
      X = files,
      FUN = .make_rast,
      wrld = wrld,
      month_names = month_names,
      pre = pre,
      pre_cv = pre_cv
    )

  names(cru_rast_list) <- substr(fs::path_file(files), 12L, 14L)

  # calculate tmn -------------------------------------------------------------
  if (tmn) {
    cru_rast_list$tmn <-
      cru_rast_list$tmp - (0.5 * cru_rast_list$dtr)
  }
  # calculate tmx -------------------------------------------------------------
  if (tmx) {
    cru_rast_list$tmx <-
      cru_rast_list$tmp + (0.5 * cru_rast_list$dtr)
  }

  # cleanup if tmn/tmx specified but tmp/dtr not -----------------------------
  if (any(tmx, tmn) && isFALSE(dtr)) {
    cru_rast_list[which(names(cru_rast_list) == "dtr")] <- NULL
  }
  if (any(tmx, tmn) && isFALSE(tmp)) {
    cru_rast_list[which(names(cru_rast_list) == "tmp")] <- NULL
  }
  return(terra::rast(cru_rast_list))
}

#' Helper Function Used in .create_rast()
#'
#' @param files A list of files to use in creating `rast` objects.
#' @param wrld An empty [terra::rast] object for filling with values.
#' @param month_names A vector of month names from jan -- dec.
#' @param pre Boolean include precipitation.
#' @param pre_cv Boolean include precipitation cv.
#'
#' @autoglobal
#' @dev
.make_rast <- function(files, wrld, month_names, pre, pre_cv) {
  wvar <- data.table::fread(
    files,
    header = FALSE
  )
  cells <- terra::cellFromXY(wrld, wvar[, c(2L, 1L)])
  if (ncol(wvar) == 14L) {
    for (j in 3L:14L) {
      wrld[cells] <- wvar[, j, with = FALSE]
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
        wrld[cells] <- wvar[, k, with = FALSE]
        if (k == 3L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- c(month_names, paste0("pre_cv_", month_names))
    } else if (pre) {
      for (k in 3L:14L) {
        wrld[cells] <- wvar[, k, with = FALSE]
        if (k == 3L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- month_names
    } else if (pre_cv) {
      for (k in 15L:26L) {
        wrld[cells] <- wvar[, k, with = FALSE]
        if (k == 15L) {
          y <- wrld
        } else {
          y <- c(y, wrld)
        }
      }
      names(y) <- paste0("pre_cv_", month_names)
    }
  } else {
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
