#' Internal helper for creating terra layers
#'
#' @param file CRU .dat.gz file path.
#' @param wrld Empty `terra::rast` template.
#' @param vars Named logical vector of CRU variable selections.
#'
#' @returns A [terra::rast] object for one variable.
#' @dev
.make_rast <- function(file, wrld, vars, varname) {
  wvar <- data.table::fread(file, header = FALSE)
  cells <- terra::cellFromXY(wrld, wvar[, c(2L, 1L)])
  n <- ncol(wvar)

  # Helper: build a list of 12 monthly layers from column indices
  build_monthly <- function(cols, prefix = NULL) {
    layers <- lapply(seq_along(cols), function(i) {
      r <- terra::rast(wrld)
      r[cells] <- wvar[[cols[i]]]
      r
    })
    names(layers) <- if (is.null(prefix)) {
      .cru_month_names
    } else {
      paste0(prefix, .cru_month_names)
    }
    layers
  }

  # Helper: build a single-layer raster
  build_single <- function(col, name) {
    r <- terra::rast(wrld)
    r[cells] <- wvar[[col]]
    names(r) <- name
    r
  }

  # --- Case 1: Standard 12-month variables (14 columns) ---
  if (n == 14L) {
    layers <- build_monthly(3:14)
    names(layers) <- paste0(varname, "_", .cru_month_names)
    return(terra::rast(layers))
  }

  # --- Case 2: pre + pre_cv (26 columns) ---
  if (n == 26L) {
    pre_layers <- build_monthly(3:14, "pre_")
    if (!isTRUE(vars["pre_cv"])) {
      return(terra::rast(pre_layers))
    }
    cv_layers <- build_monthly(15:26, "pre_cv_")
    return(terra::rast(c(pre_layers, cv_layers)))
  }

  # --- Case 3: elevation (3 columns) ---
  if (n == 3L) {
    r <- build_single(3L, "elv")
    r <- r * 1000L
    r <- .remove_bad_cells_rast(r)
    return(r)
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}


#' Create terra rast objects
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A terra::rast object.
#' @autoglobal
#' @dev
.create_rast <- function(vars, files) {
  # 1. Expand directory -> file paths
  if (is.character(files) && length(files) == 1L && fs::is_dir(files)) {
    files <- fs::dir_ls(files, regexp = "grid_10min_.*\\.dat\\.gz$")
  }

  # 2. Check gzip support for character paths
  if (is.character(files)) {
    .check_gzip_support(files)
    if (!length(files)) cli::cli_abort("No CRU raster files found.")
  }

  # 3. Handle pre-built SpatRaster or tidy data.table list inputs
  if (all(vapply(files, inherits, logical(1), what = "SpatRaster"))) {
    return(terra::crop(terra::rast(files), .cru_extent()))
  }

  if (is.list(files) && !is.character(files)) {
    rast_list <- lapply(names(files), function(v) {
      .dt_to_rast(files[[v]], varname = v)
    })
    return(terra::crop(terra::rast(rast_list), .cru_extent()))
  }

  # 4. Build rasters from raw CRU files
  wrld <- .cru_template_rast()
  varnames <- .cru_varname(files)

  rast_list <- lapply(seq_along(files), function(i) {
    .make_rast(
      file = files[[i]],
      wrld = wrld,
      vars = vars,
      varname = varnames[[i]]
    )
  })
  names(rast_list) <- varnames

  if (!all(vapply(rast_list, inherits, logical(1), what = "SpatRaster"))) {
    cli::cli_abort("One or more CRU rasters failed to build.")
  }

  # 5. Derived variables (tmn / tmx from tmp +/- 0.5 * dtr)
  if (isTRUE(vars["tmn"]) && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmn <- rast_list$tmp - 0.5 * rast_list$dtr
  }
  if (isTRUE(vars["tmx"]) && all(c("tmp", "dtr") %in% names(rast_list))) {
    rast_list$tmx <- rast_list$tmp + 0.5 * rast_list$dtr
  }

  # Drop tmp / dtr if they were only needed as intermediates
  if ((isTRUE(vars["tmn"]) || isTRUE(vars["tmx"])) && isFALSE(vars["tmp"])) {
    rast_list$tmp <- NULL
  }
  if ((isTRUE(vars["tmn"]) || isTRUE(vars["tmx"])) && isFALSE(vars["dtr"])) {
    rast_list$dtr <- NULL
  }

  # Crop to CRU CL 2.0 extent: ymin = -60, ymax = 85
  terra::crop(terra::rast(rast_list), .cru_extent())
}


#' CRU 10-minute global raster template
#'
#' Shared baseline grid (930 x 2160, lat -65 to 90, lon -180 to 180).
#' All values initialised to NA_real_.
#'
#' @return A single-layer terra::rast.
#' @dev
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


#' CRU CL 2.0 output crop extent
#'
#' Crops all raster outputs to ymin = -60, ymax = 85, xmin = -180, xmax = 180,
#' matching the stated coverage of the CRU CL 2.0 dataset in the package's
#' README. This crops the wind data that cover the Antarctic region.
#'
#' @return A terra::ext object.
#' @dev
.cru_extent <- function() {
  terra::ext(-180, 180, -60, 85)
}


#' Extract CRU variable names from file paths
#'
#' Strips the `grid_10min_` prefix and `.dat.gz` suffix from CRU filenames,
#' returning the bare variable identifier (e.g. "pre", "pre_cv", "elv").
#'
#' @param files Character vector of CRU `.dat.gz` file paths.
#' @return Character vector of variable names.
#' @dev
.cru_varname <- function(files) {
  base <- fs::path_file(files)
  file_stem <- sub("\\.dat\\.gz$", "", base)
  sub("^grid_10min_", "", file_stem)
}
