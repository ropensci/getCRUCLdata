#' Downloads and formats CRU CL 2.0 data
#'
#' @param pre Logical. If TRUE, downloads precipitation data.
#' @param pre_cv Logical. If TRUE, downloads precipitation data.
#' @param rd0 Logical. If TRUE, downloads runoff data.
#' @param tmp Logical. If TRUE, downloads temperature data.
#' @param dtr Logical. If TRUE, downloads diurnal temperature range data.
#' @param reh Logical. If TRUE, downloads relative humidity data.
#' @param tmn Logical. If TRUE, downloads minimum temperature data.
#' @param tmx Logical. If TRUE, downloads maximum temperature data.
#' @param sunp Logical. If TRUE, downloads sunshine data.
#' @param frs Logical. If TRUE, downloads frost day frequency data.
#' @param wnd Logical. If TRUE, downloads wind speed data.
#' @param elv Logical. If TRUE, downloads elevation data.
#'
#' Handles the downloading of CRU CL 2.0 data. This function is called by
#' [get_cru_df] and [get_cru_rast]. It is not intended to be called directly.
#'
#' @returns A data.table with the requested data.
#'
#' @dev
.get_cru <-
  function(
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
  ) {
    dl_files <- .filter_files(
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
    # download files ----------------------------------------------------------
    if (length(dl_files) > 0L) {
      cru_url <- "https://crudata.uea.ac.uk/cru/data/hrg/tmc/"
      dl_files <- as.list(paste0(cru_url, dl_files))

      tryCatch(
        for (f in seq_along(dl_files)) {
          .retry_download(url = f, .max_tries = 3L)
        },
        error = function(x) {
          cli::cli_abort(
            "The file downloads have failed.
          Please start the download again."
          )
        }
      )
    }

    # filter files from tempdir() in case there are files for which
    # we do not want data
    temp_dir_contents <- fs::dir_ls(
      fs::path_temp(),
      regexp = "\\.dat\\.gz$"
    )

    dl_files <- temp_dir_contents[temp_dir_contents %in% dl_files]

    # add full file path to the files
    dl_files <- fs::path(fs::path_temp(), dl_files)

    # fill the space with a "\" for R, if one exists
    dl_files <- gsub(" ", "\\ ", dl_files, fixed = TRUE)

    return(dl_files)
  }

.filter_files <- function(
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
) {
  file_name_vec <- c(
    pre = "grid_10min_pre.dat.gz",
    rd0 = "grid_10min_rd0.dat.gz",
    tmp = "grid_10min_tmp.dat.gz",
    dtr = "grid_10min_dtr.dat.gz",
    reh = "grid_10min_reh.dat.gz",
    sunp = "grid_10min_sunp.dat.gz",
    frs = "grid_10min_frs.dat.gz",
    wnd = "grid_10min_wnd.dat.gz",
    elv = "grid_10min_elv.dat.gz"
  )

  # check if pre_cv or tmx/tmn (derived) are true, make sure proper ---------
  # parameters set TRUE
  if (pre_cv) {
    pre <- TRUE
  }

  if (any(tmn, tmx)) {
    dtr <- tmp <- TRUE
  }
  # create object list to filter downloads ----------------------------------
  request_files_vec <- c(pre, rd0, tmp, dtr, reh, sunp, frs, wnd, elv)

  names(request_files_vec) <- names(file_name_vec)

  return(names(file_name_vec)[which(names(request_files_vec))])
}
