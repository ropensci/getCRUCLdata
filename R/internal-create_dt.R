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

  # Compute derived variables (tmn, tmx)
  tidy_dt <- .add_derived_dt(tidy_dt, vars)

  # Drop tmp/dtr if not requested
  tidy_dt <- .drop_source_vars_dt(tidy_dt, vars)

  data.table::setorder(tidy_dt, month)
  tidy_dt[, month := factor(month, levels = 1:12)]

  tidy_dt[]
}


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

  dt
}

#' @autoglobal
.drop_source_vars_dt <- function(dt, vars) {
  if ((isTRUE(vars["tmn"]) || isTRUE(vars["tmx"]))) {
    if (!vars["tmp"]) {
      dt[, tmp := NULL]
    }
    if (!vars["dtr"]) dt[, dtr := NULL]
  }

  dt
}
