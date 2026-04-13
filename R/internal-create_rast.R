#' Create terra rast objects
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A terra::rast object.
#' @dev

.create_rast <- function(vars, files) {
  # 1. Expand directory → file paths
  if (is.character(files) && length(files) == 1L && fs::is_dir(files)) {
    files <- fs::dir_ls(files, regexp = "grid_10min_.*\\.dat\\.gz$")
  }

  # 2. If files are already SpatRaster objects → stack them
  if (all(vapply(files, inherits, logical(1), what = "SpatRaster"))) {
    return(terra::rast(files))
  }

  # 3. If files is a named list of tidy data.tables → convert to rasters
  if (is.list(files) && !is.character(files)) {
    rast_list <- lapply(names(files), function(v) {
      dtv <- files[[v]]
      .dt_to_rast(dtv, varname = v)
    })
    names(rast_list) <- names(files)
    return(terra::rast(rast_list))
  }

  # 4. Otherwise: treat as file paths
  if (!length(files)) {
    cli::cli_abort("No CRU raster files found.")
  }

  # Base raster template
  wrld <- terra::rast(
    nrows = 930L,
    ncols = 2160L,
    ymin = -65L,
    ymax = 90L,
    xmin = -180L,
    xmax = 180L
  )
  wrld[] <- NA

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

  # 5. Build rasters from raw CRU files
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

  # Validate: all must be SpatRaster
  if (!all(vapply(rast_list, inherits, logical(1), what = "SpatRaster"))) {
    cli::cli_abort("One or more CRU rasters failed to build.")
  }

  # 6. Derived raster variables
  if (vars["tmn"] && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmn <- rast_list$tmp - 0.5 * rast_list$dtr
  }
  if (vars["tmx"] && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmx <- rast_list$tmp + 0.5 * rast_list$dtr
  }

  # Drop tmp/dtr if requested
  if ((vars["tmn"] || vars["tmx"]) && !vars["tmp"]) {
    rast_list$tmp <- NULL
  }
  if ((vars["tmn"] || vars["tmx"]) && !vars["dtr"]) {
    rast_list$dtr <- NULL
  }

  return(terra::rast(rast_list))
}


#' Extract CRU variable names from file paths
#'
#' Internal helper that converts full CRU file paths such as
#' `grid_10min_pre.dat.gz` or `grid_10min_pre_cv.dat.gz` into their
#' corresponding variable identifiers (`"pre"`, `"pre_cv"`, `"tmp"`, etc.).
#'
#' This function strips both the directory and the `.dat.gz` suffix, and
#' removes the standard `grid_10min_` prefix used in CRU CL v2.0 filenames.
#'
#' @param files Character vector of CRU `.dat.gz` file paths.
#'
#' @return A character vector of variable names with the `grid_10min_`
#'   prefix and file extension removed.
#'
#' @dev
.cru_varname <- function(files) {
  base <- fs::path_file(files)
  file_stem <- sub("\\.dat\\.gz$", "", base)
  sub("^grid_10min_", "", file_stem)
}
