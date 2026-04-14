#' Read a single CRU file into a tidy data.table
#'
#' @param file CRU .dat.gz file path or a directory containing one such file.
#' @param vars Named logical vector.
#'
#' @returns A tidy data.table.
#' @autoglobal
#' @dev

.read_local_files <- function(file, vars) {
  # 1. Directory → return file paths
  if (fs::is_dir(file)) {
    return(fs::dir_ls(
      file,
      regexp = "grid_10min_.*\\.dat\\.gz$",
      recurse = FALSE
    ))
  }

  # 2. Single file → parse into tidy dt
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

  x <- data.table::fread(file, header = FALSE)
  n <- ncol(x)

  # 14‑column monthly variable
  if (n == 14L) {
    data.table::setnames(x, c("lat", "lon", month_names))
    dtx <- data.table::melt(
      x,
      id.vars = c("lat", "lon"),
      variable.name = "month"
    )
    data.table::setnames(dtx, c("lat", "lon", "month", "value"))
    return(dtx[])
  }

  # 26‑column pre + pre_cv
  if (n == 26L) {
    pre_dt <- x[, 1:14]
    data.table::setnames(pre_dt, c("lat", "lon", month_names))
    pre_dt <- data.table::melt(
      pre_dt,
      id.vars = c("lat", "lon"),
      variable.name = "month"
    )
    data.table::setnames(pre_dt, c("lat", "lon", "month", "pre"))

    if (!vars["pre_cv"]) {
      return(pre_dt[])
    }

    cv_dt <- x[, c(1, 2, 15:26)]
    data.table::setnames(cv_dt, c("lat", "lon", month_names))
    cv_dt <- data.table::melt(
      cv_dt,
      id.vars = c("lat", "lon"),
      variable.name = "month"
    )
    data.table::setnames(cv_dt, c("lat", "lon", "month", "pre_cv"))

    data.table::setkey(pre_dt, lat, lon, month)
    data.table::setkey(cv_dt, lat, lon, month)

    pre_dt[cv_dt, pre_cv := i.pre_cv]
    return(pre_dt[])
  }

  # 3‑column elevation
  if (n == 3L) {
    data.table::setnames(x, c("lat", "lon", "elv"))
    x[, elv := elv * 1000L]
    return(x[])
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}
