#' Read a single CRU file into a tidy data.table
#'
#' @param file CRU .dat.gz file path or a directory containing one such file.
#' @param vars Named logical vector.
#'
#' @returns A tidy data.table.
#' @autoglobal
#' @dev

.read_local_files <- function(file, vars) {
  # 1. Directory → find all matching files
  if (fs::is_dir(file)) {
    cat("DEBUG: Searching in directory:", file, "\n")

    files <- fs::dir_ls(
      file,
      regexp = "grid_10min_.*\\.dat\\.gz$",
      recurse = TRUE
    )

    cat("DEBUG: Files found:", length(files), "\n")
    if (length(files) > 0) {
      print(files)
    }
    cat("DEBUG: Files vector:", class(files), "\n")
    if (length(files) == 0L) {
      cli::cli_abort("No CRU files matching pattern found in {.var file}.")
    }

    dt_list <- lapply(files, function(f) {
      x <- data.table::fread(f, header = FALSE)
      .process_cru_file(x, vars)
    })

    return(data.table::rbindlist(dt_list, use.names = TRUE, fill = TRUE))
  }

  # 2. Single file → parse into tidy dt
  x <- data.table::fread(file, header = FALSE)
  return(.process_cru_file(x, vars))
}

# Helper function to avoid code duplication
.process_cru_file <- function(x, vars) {
  n <- ncol(x)

  # 14‑column monthly variable
  if (n == 14L) {
    data.table::setnames(x, c("lat", "lon", .cru_month_names))
    return(data.table::melt(
      x,
      id.vars = c("lat", "lon"),
      variable.name = "month",
      value.name = "value"
    ))
  }

  # 26‑column pre + pre_cv
  if (n == 26L) {
    pre_names <- .cru_month_names
    cv_names <- paste0(.cru_month_names, "_cv")
    data.table::setnames(x, c("lat", "lon", pre_names, cv_names))

    pre_dt <- data.table::melt(
      x[, c("lat", "lon", pre_names), with = FALSE],
      id.vars = c("lat", "lon"),
      variable.name = "month",
      value.name = "pre"
    )

    if (isFALSE(vars["pre_cv"])) {
      return(pre_dt)
    }

    cv_dt <- data.table::melt(
      x[, c("lat", "lon", cv_names), with = FALSE],
      id.vars = c("lat", "lon"),
      variable.name = "month",
      value.name = "pre_cv"
    )
    data.table::setnames(cv_dt, "month", "month")

    return(pre_dt[cv_dt, on = .(lat, lon, month)])
  }

  # 3‑column elevation
  if (n == 3L) {
    data.table::setnames(x, c("lat", "lon", "elv"))
    x[, elv := elv * 1000L]
    return(x)
  }

  cli::cli_abort("Unexpected file format in {.var file}.")
}
