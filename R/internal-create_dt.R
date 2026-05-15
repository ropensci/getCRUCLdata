#' Create a data.table from CRU data
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A data.table.
#' @autoglobal
#' @dev
.create_dt <- function(vars, files) {
  tidy_dt <- if (is.character(files)) .tidy_dt(vars, files) else files
  tidy_dt <- .add_derived_dt(tidy_dt, vars)
  tidy_dt <- .drop_source_vars_dt(tidy_dt, vars)
  tidy_dt[, month := factor(month, levels = .cru_month_names, ordered = TRUE)]
  data.table::setorder(tidy_dt, month)
  tidy_dt[, `:=`(
    lat = round(lat, 3),
    lon = round(lon, 3)
  )]
  if (isTRUE(vars["elv"])) {
    tidy_dt <- tidy_dt[!.bad_coords, on = list(lat, lon)]
  }
  # Crop to CRU CL 2.0 extent: ymin = -60, ymax = 85
  tidy_dt <- tidy_dt[lat >= -60 & lat <= 85]
  return(tidy_dt[])
}

#' Add derived temperature values for TMAX and TMIN
#' @param dt A data.table object of CRU data containing `tmp` and `dtr` in order
#'  to calculate tmin and tmxax.
#' @param vars A named logical vector.
#' @returns A data.table with tmin and or tmax cols.
#' @autoglobal
.add_derived_dt <- function(dt, vars) {
  has_inputs <- all(c("tmp", "dtr") %in% names(dt))
  if (has_inputs) {
    if (isTRUE(vars["tmx"])) {
      dt[, tmx := tmp + 0.5 * dtr]
    }
    if (isTRUE(vars["tmn"])) {
      dt[, tmn := tmp - 0.5 * dtr]
    }
  }
  return(dt)
}


#' Remove source vars if not requested
#'
#' If `tmin` or `tmax` are requested but `tmp` or `dtr` are not requested, this
#'  function drops the unrequested vars.
#' @param dt A data.table object of CRU data containing `tmp` and `dtr` in order
#'  to calculate tmin and tmxax.
#' @param vars A named logical vector.
#' @returns A data.table with the unrequested var columns removed.
#' @autoglobal
.drop_source_vars_dt <- function(dt, vars) {
  if (isTRUE(vars["tmn"]) || isTRUE(vars["tmx"])) {
    if (!vars["tmp"]) {
      dt[, tmp := NULL]
    }
    if (!vars["dtr"]) dt[, dtr := NULL]
  }
  return(dt)
}
