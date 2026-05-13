#' Read and merge CRU files into a tidy data.table
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A merged data.table.
#' @dev

.tidy_dt <- function(vars, files) {
  .check_gzip_support(files)
  varnames <- sub(
    "^grid_10min_([a-z0-9_]+)\\.dat\\.gz$",
    "\\1",
    fs::path_file(files)
  )

  dt_list <- lapply(seq_along(files), function(i) {
    dtv <- .read_local_files(files[[i]], vars)
    v <- varnames[[i]]

    if ("value" %in% names(dtv)) {
      data.table::setnames(dtv, "value", v)
    }

    return(dtv)
  })

  names(dt_list) <- varnames

  # Separate elevation
  elv_dt <- NULL
  if ("elv" %in% names(dt_list)) {
    elv_dt <- dt_list[["elv"]]
    dt_list[["elv"]] <- NULL
  }

  # Merge monthly variables
  monthly <- Filter(function(dt) "month" %in% names(dt), dt_list)

  if (length(monthly) == 0L) {
    merged <- if (!is.null(elv_dt)) elv_dt else data.table::data.table()
    return(merged[])
  }

  lapply(monthly, data.table::setkey, lat, lon, month)
  merged <- Reduce(function(x, y) x[y], monthly)

  # Add elevation
  if (!is.null(elv_dt)) {
    data.table::setkey(elv_dt, lat, lon)
    merged <- elv_dt[merged, on = c("lat", "lon")]
  }

  return(merged[])
}
