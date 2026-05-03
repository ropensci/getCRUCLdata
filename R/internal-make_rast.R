#' Internal helper for creating terra layers
#'
#' @param file CRU .dat.gz file path.
#' @param wrld Empty `terra::rast` template.
#' @param vars Named logical vector of CRU variable selections.
#'
#' @returns A [terra::rast] object for one variable.
#' @dev

.make_rast <- function(
  file,
  wrld,
  vars,
  varname
) {
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

  # --- Case 1: Standard 12‑month variables (14 columns) ---
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
    return(r * 1000L) # ensure km converted to m
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}
