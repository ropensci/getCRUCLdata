#' Create a terra SpatRaster object of CRU CL v. 2.0 climatology elements
#'
#' Create a [terra::SpatRaster] object or list of objects from \acronym{CRU} CL
#'  2.0 data.
#'
#' @inherit read_cru_dt
#'
#' @examplesIf interactive()
#' # Create a data frame of temperature from locally available files in the
#' # tempdir() directory.
#' library(fs)
#'
#' f <- path(path_temp(), "grid_10min_tmp.dat.gz")
#'
#' download.file(
#'   url = "https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz",
#'   destfile = f
#' )
#'
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE, x = f)
#'
#' cru_tmp
#'
#' # or downloading directly from the CRU server
#'
#' cru_tmp <- read_cru_rast(tmp = TRUE)
#'
#' cru_tmp
#'
#' @returns A [terra::SpatRaster] object.
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
  x = NULL
) {
  vars <- c(
    pre = pre,
    pre_cv = pre_cv,
    rd0 = rd0,
    tmp = tmp,
    dtr = dtr,
    reh = reh,
    tmn = tmn,
    tmx = tmx,
    sunp = sunp,
    frs = frs,
    wnd = wnd,
    elv = elv
  )

  files <- .validate_filter_files(vars, x)
  resolved <- .file_handling(vars, files, x)

  .create_rast(resolved$vars, resolved$files)
}
