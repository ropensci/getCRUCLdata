#' Create a terra rast object of CRU CL v. 2.0 climatology elements
#'
#' @inheritSection read_cru_dt Nomenclature and Units
#'
#' @returns A terra::rast object.
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
