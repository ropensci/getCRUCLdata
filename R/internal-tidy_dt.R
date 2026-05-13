#' Read and merge CRU files into a tidy data.table
#'
#' @param vars Named logical vector.
#' @param files Character vector of CRU file paths.
#'
#' @returns A merged data.table.
#' @autoglobal
#' @dev
.tidy_dt <- function(vars, files) {
  .check_gzip_support(files)

  varnames <- sub(
    "^grid_10min_([a-z0-9_]+)\\.dat\\.gz$",
    "\\1",
    fs::path_file(files)
  )

  dt_list <- lapply(seq_along(files), function(i) {
    .read_local_files(files[[i]], vars, varnames[[i]])
  })
  names(dt_list) <- varnames

  # Separate elevation (no month column)
  elv_dt <- NULL
  if ("elv" %in% names(dt_list)) {
    elv_dt <- dt_list[["elv"]]
    dt_list[["elv"]] <- NULL
  }

  monthly <- Filter(function(dt) "month" %in% names(dt), dt_list)

  if (length(monthly) == 0L) {
    return(if (!is.null(elv_dt)) elv_dt else data.table::data.table())
  }

  # Set keys on all tables then reduce with merge
  # Using merge rather than cbind avoids any row-order assumptions across
  # files with different column counts (e.g. pre 26-col vs tmp 14-col)
  lapply(monthly, data.table::setkeyv, cols = c("lat", "lon", "month"))

  merged <- Reduce(
    function(x, y) merge(x, y, by = c("lat", "lon", "month"), all = FALSE),
    monthly
  )

  if (!is.null(elv_dt)) {
    data.table::setkeyv(merged, c("lat", "lon"))
    data.table::setkeyv(elv_dt, c("lat", "lon"))
    merged <- elv_dt[merged]
  }

  merged[]
}


#' Read a single CRU file into a tidy data.table
#'
#' @param file    CRU .dat.gz file path.
#' @param vars    Named logical vector.
#' @param varname Variable name string (e.g. "tmp", "rd0", "elv").
#'
#' @returns A tidy data.table.
#' @autoglobal
#' @dev
.read_local_files <- function(file, vars, varname) {
  x <- data.table::fread(file, header = FALSE)
  n <- ncol(x)

  # --- 14-column: standard 12-month variable --------------------------------
  if (n == 14L) {
    data.table::setnames(x, c("lat", "lon", .cru_month_names))
    dtx <- data.table::melt(
      x,
      id.vars = c("lat", "lon"),
      measure.vars = .cru_month_names,
      variable.name = "month",
      value.name = varname
    )
    return(dtx[])
  }

  # --- 26-column: pre + pre_cv ----------------------------------------------
  if (n == 26L) {
    pre_dt <- x[, 1:14]
    data.table::setnames(pre_dt, c("lat", "lon", .cru_month_names))
    pre_dt <- data.table::melt(
      pre_dt,
      id.vars = c("lat", "lon"),
      measure.vars = .cru_month_names,
      variable.name = "month",
      value.name = "pre"
    )

    if (isFALSE(vars["pre_cv"])) {
      return(pre_dt[])
    }

    cv_dt <- x[, c(1L, 2L, 15:26)]
    data.table::setnames(cv_dt, c("lat", "lon", .cru_month_names))
    cv_dt <- data.table::melt(
      cv_dt,
      id.vars = c("lat", "lon"),
      measure.vars = .cru_month_names,
      variable.name = "month",
      value.name = "pre_cv"
    )

    data.table::setkey(pre_dt, lat, lon, month)
    data.table::setkey(cv_dt, lat, lon, month)
    pre_dt[cv_dt, pre_cv := i.pre_cv]
    return(pre_dt[])
  }

  # --- 3-column: elevation --------------------------------------------------
  if (n == 3L) {
    data.table::setnames(x, c("lat", "lon", "elv"))
    x[, elv := elv * 1000L]
    return(x[])
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}
