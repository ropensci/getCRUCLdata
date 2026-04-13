#' Internal helper for creating terra layers
#'
#' @param file CRU .dat.gz file path.
#' @param wrld Empty `terra::rast` template.
#' @param month_names Character vector of month names.
#' @param vars Named logical vector of CRU variable selections.
#'
#' @returns A terra::rast object for one variable.
#' @dev

.make_rast <- function(file, wrld, month_names, vars, varname) {
  wvar <- data.table::fread(file, header = FALSE)
  cells <- terra::cellFromXY(wrld, wvar[, c(2L, 1L)])
  n <- ncol(wvar)

  if (n == 14L) {
    layers <- vector("list", 12L)
    for (j in 3L:14L) {
      r <- terra::rast(wrld)
      r[cells] <- wvar[[j]]
      layers[[j - 2L]] <- r
    }
    names(layers) <- month_names
    out <- terra::rast(layers)
    names(out) <- paste0(varname, "_", month_names) # ← add this
    return(out)
  }

  if (n == 26L) {
    pre_layers <- vector("list", 12L)
    for (j in 3L:14L) {
      r <- terra::rast(wrld)
      r[cells] <- wvar[[j]]
      pre_layers[[j - 2L]] <- r
    }
    names(pre_layers) <- paste0("pre_", month_names)

    if (isFALSE(vars["pre_cv"])) {
      return(terra::rast(pre_layers))
    }

    cv_layers <- vector("list", 12L)
    for (j in 15L:26L) {
      r <- terra::rast(wrld)
      r[cells] <- wvar[[j]]
      cv_layers[[j - 14L]] <- r
    }
    names(cv_layers) <- paste0("pre_cv_", month_names)

    return(terra::rast(c(pre_layers, cv_layers)))
  }

  if (n == 3L) {
    r <- terra::rast(wrld)
    r[cells] <- wvar[[3L]] * 1000L
    names(r) <- "elv"
    return(r)
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}
