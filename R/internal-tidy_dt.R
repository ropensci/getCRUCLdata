#' Read and merge CRU files into a tidy data.table
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A merged data.table.
#' @dev
#'

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

  merged <- Reduce(
    function(x, y) merge(x, y, by = c("lat", "lon", "month")),
    monthly
  )

  # Add elevation
  if (!is.null(elv_dt)) {
    merged <- merged[elv_dt, on = c("lat", "lon")]
  }

  return(merged[])
}
