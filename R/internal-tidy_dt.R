#' Read and merge CRU files into a tidy data.table
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A merged data.table.
#' @dev

.tidy_dt <- function(vars, files) {
  .check_gzip_support(files)

  dt_list <- lapply(files, .read_local_files, vars = vars)

  varnames <- sub(
    "^grid_10min_([a-z0-9_]+)\\.dat\\.gz$",
    "\\1",
    fs::path_file(files)
  )
  names(dt_list) <- varnames

  # Separate elevation (no month column)
  elv_dt <- NULL
  if ("elv" %in% names(dt_list)) {
    elv_dt <- dt_list[["elv"]]
    dt_list[["elv"]] <- NULL
  }

  monthly <- Filter(function(dt) "month" %in% names(dt), dt_list)

  if (length(monthly) == 0L) {
    return(if (!is.null(elv_dt)) elv_dt[] else data.table::data.table())
  }

  # All monthly tables share identical lat/lon/month rows — key and join
  lapply(monthly, data.table::setkey, lat, lon, month)
  merged <- Reduce(function(x, y) x[y], monthly)

  # Join elevation
  if (!is.null(elv_dt)) {
    data.table::setkey(elv_dt, lat, lon)
    data.table::setkey(merged, lat, lon)
    merged <- elv_dt[merged]
  }

  merged[]
}
