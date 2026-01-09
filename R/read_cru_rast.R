#' Create a terra rast object of CRU CL v. 2.0 climatology elements
#'
#' Automates importing \acronym{CRU} \acronym{CL} v.2.0 climatology
#' data and creates a \CRANpkg{terra} [terra::rast] object of the
#' data.  If requested, minimum and maximum temperature may also be
#' automatically calculated as described in the data
#' [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file.
#' Data may be cached for later use by this function, saving time downloading
#' files in future using this function.  This function can be useful if you
#' have network connection issues that mean automated downloading of the files
#' using \R does not work properly or you have cached the files locally for
#' your own future use.
#'
#' @inheritSection read_cru_dt Nomenclature and Units
#' @inheritParams read_cru_dt
#' @inherit read_cru_dt author
#' @inherit read_cru_dt source
#' @inherit read_cru_dt references
#'
#' @examplesIf interactive()
#'
#' # Downloading directly from the CRU server
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE)
#'
#' # Using a local file, downloaded to tempdir() for this example
#' library(fs)
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = file.path(tempdir(), "grid_10min_tmp.dat.gz")
#' )
#'
#' f <- path(path_temp(), "grid_10min_tmp.dat.gz")
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE, x = f)
#'
#' cru_tmp
#'
#' @seealso [read_cru_dt].
#'
#' @returns A [terra::rast] object of \acronym{CRU} \acronym{CL} v. 2.0
#'  climatology elements.
#'
#' @export

read_cru_rast <- function(
  pre = FALSE,
  pre_cv = FALSE,
  rd0 = FALSE,
  tmp = FALSE,
  dtr = FALSE,
  reh = FALSE,
  tmn = FALSE,
  tmx = FALSE,
  sunp = FALSE,
  frs = FALSE,
  wnd = FALSE,
  elv = FALSE,
  x
) {
  .check_vars(
    pre,
    pre_cv,
    rd0,
    tmp,
    dtr,
    reh,
    tmn,
    tmx,
    sunp,
    frs,
    wnd,
    elv
  )

  if (is.null(x)) {
    files <- .get_cru(
      pre,
      pre_cv,
      rd0,
      tmp,
      dtr,
      reh,
      tmn,
      tmx,
      sunp,
      frs,
      wnd,
      elv
    )

    if (pre_cv) {
      pre <- TRUE
    }
  } else {
    .validate_x(x)

    files <-
      .read_local_files(
        .files = c(pre, rd0, tmp, dtr, reh, tmn, tmx, sunp, frs, wnd, elv),
        .pre_cv = pre_cv
      )

    if (length(files) == 0) {
      cli::cli_abort(
        "No CRU CL 2.0 data files were found in {.var dsn}.
      Please check that you have the proper file location."
      )
    }
  }

  return(.create_rasts(tmn, tmx, tmp, dtr, pre, pre_cv, files))
}
