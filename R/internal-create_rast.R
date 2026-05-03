#' Create terra rast objects
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A terra::rast object.
#' @autoglobal
#' @dev

.create_rast <- function(vars, files) {
  # 1. Expand directory → file paths
  if (is.character(files) && length(files) == 1L && fs::is_dir(files)) {
    files <- fs::dir_ls(files, regexp = "grid_10min_.*\\.dat\\.gz$")
  }

  # 2. If files are character paths → check gzip support
  if (is.character(files)) {
    .check_gzip_support(files)

    if (!length(files)) cli::cli_abort("No CRU raster files found.")
  }
  # 3. Handle different input types
  if (all(vapply(files, inherits, logical(1), what = "SpatRaster"))) {
    return(terra::rast(files))
  } else if (is.list(files) && !is.character(files)) {
    # List of tidy data.tables
    rast_list <- lapply(names(files), function(v) {
      .dt_to_rast(files[[v]], varname = v)
    })
    return(terra::rast(rast_list))
  }

  # 4. Build rasters from raw CRU files
  wrld <- .cru_template_rast()

  month_names <- c(
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

  varnames <- .cru_varname(files)

  rast_list <- lapply(seq_along(files), function(i) {
    .make_rast(
      file = files[[i]],
      wrld = wrld,
      month_names = month_names,
      vars = vars,
      varname = varnames[[i]]
    )
  })

  names(rast_list) <- varnames

  # Validate
  if (!all(vapply(rast_list, inherits, logical(1), what = "SpatRaster"))) {
    cli::cli_abort("One or more CRU rasters failed to build.")
  }

  # 5. Derived variables
  if (isTRUE(vars["tmn"]) && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmn <- rast_list$tmp - 0.5 * rast_list$dtr
  }
  if (isTRUE(vars["tmx"]) && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmx <- rast_list$tmp + 0.5 * rast_list$dtr
  }

  # Drop tmp/dtr if not requested
  if ((isTRUE(vars["tmn"]) || isTRUE(vars["tmx"])) && isFALSE(vars["tmp"])) {
    rast_list$tmp <- NULL
  }
  if ((isTRUE(vars["tmn"]) || isTRUE(vars["tmx"])) && isFALSE(vars["dtr"])) {
    rast_list$dtr <- NULL
  }

  terra::rast(rast_list)
}


.cru_template_rast <- function() {
  r <- terra::rast(
    nrows = 930,
    ncols = 2160,
    ymin = -65,
    ymax = 90,
    xmin = -180,
    xmax = 180
  )
  r[] <- NA_real_
  r
}


#' Extract CRU variable names from file paths
#'
#' Internal helper that converts full CRU file paths such as
#' `grid_10min_pre.dat.gz` or `grid_10min_pre_cv.dat.gz` into their
#' corresponding variable identifiers (`"pre"`, `"pre_cv"`, `"tmp"`, etc.).
#'
#' @param files Character vector of CRU `.dat.gz` file paths.
#'
#' @return A character vector of variable names with the `grid_10min_`
#'   prefix and file extension removed.
#' @dev
.cru_varname <- function(files) {
  base <- fs::path_file(files)
  file_stem <- sub("\\.dat\\.gz$", "", base)
  sub("^grid_10min_", "", file_stem)
}
