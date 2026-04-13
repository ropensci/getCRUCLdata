#' Create a data.table from CRU data
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A data.table.
#' @dev

.create_dt <- function(vars, files) {
  tidy_dt <- if (is.character(files)) .tidy_dt(vars, files) else files

  if (vars["tmx"] && all(c("tmp", "dtr") %in% names(tidy_dt))) {
    tidy_dt[, tmx := tmp + 0.5 * dtr]
  }
  if (vars["tmn"] && all(c("tmp", "dtr") %in% names(tidy_dt))) {
    tidy_dt[, tmn := tmp - 0.5 * dtr]
  }

  if ((vars["tmn"] || vars["tmx"]) && !vars["tmp"]) {
    tidy_dt[, tmp := NULL]
  }
  if ((vars["tmn"] || vars["tmx"]) && !vars["dtr"]) {
    tidy_dt[, dtr := NULL]
  }

  tidy_dt[, month := factor(month)]
  data.table::setorder(tidy_dt, month)

  return(tidy_dt[])
}
