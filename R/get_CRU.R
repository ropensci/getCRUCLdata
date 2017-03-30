#' @noRd
.get_CRU <-
  function(pre,
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
           elv,
           cache_dir) {
    dtr_file <- "grid_10min_dtr.dat.gz"
    tmp_file <- "grid_10min_tmp.dat.gz"
    reh_file <- "grid_10min_reh.dat.gz"
    elv_file <- "grid_10min_elv.dat.gz"
    pre_file <- "grid_10min_pre.dat.gz"
    sun_file <- "grid_10min_sunp.dat.gz"
    wnd_file <- "grid_10min_wnd.dat.gz"
    frs_file <- "grid_10min_frs.dat.gz"
    rd0_file <- "grid_10min_rd0.dat.gz"

    # check if pre_cv or tmx/tmn (derived) are true, make sure proper ----------
    # parameters set TRUE
    if (isTRUE(pre_cv)) {
      pre <- TRUE
    }

    if (isTRUE(tmn) | isTRUE(tmx)) {
      dtr <- tmp <- TRUE
    }
    # create object list to filter downloads -----------------------------------
    object_list <- c(dtr, tmp, reh, elv, pre, sunp, wnd, frs, rd0)

    files <-
      c(
        dtr_file,
        tmp_file,
        reh_file,
        elv_file,
        pre_file,
        sun_file,
        wnd_file,
        frs_file,
        rd0_file
      )
    names(files) <-
      names(object_list) <-
      c(
        "dtr_file",
        "tmp_file",
        "reh_file",
        "elv_file",
        "pre_file",
        "sun_file",
        "wnd_file",
        "frs_file",
        "rd0_file"
      )

    # filter downloaded --------------------------------------------------------
    # which files are being requested?
    files <- files[object_list %in% !isTRUE(files)]

    # which files are locally available?
    cache_dir_contents <-
      list.files(cache_dir, pattern = ".dat.gz$")

    # which files requested need to be downloaded
    dl_files <- files[!(files %in% cache_dir_contents)]

    # download files -----------------------------------------------------------
    if (length(dl_files) > 0) {
      message(" \nDownloading requested data files.\n ")

      CRU_url <- "https://crudata.uea.ac.uk/cru/data/hrg/tmc/"
      dl_files <- as.list(paste0(CRU_url, dl_files))

      pb <-
        utils::txtProgressBar(
          min = 0,
          max = length(dl_files),
          initial = 0,
          style = 3
        )
      tryCatch(
        for (f in 1:length(dl_files)) {
          httr::GET(url = dl_files[[f]],
                    httr::write_disk(paste0(
                      cache_dir, "/",
                      basename(dl_files[[f]])
                    ),
                    overwrite = TRUE))
          utils::setTxtProgressBar(pb, f)
        },
        error = function(x) {
          do.call(file.remove, list(list.files(cache_dir, full.names = TRUE)))
          stop("\nThe file downloads have failed.\n
               \nPlease start the download again.\n")
        }
      )
    }

    # filter files from cache directory in case there are local files for which
    # we do not want data
    cache_dir_contents <- as.list(list.files(cache_dir,
                                             pattern = ".dat.gz$"))

    files <- cache_dir_contents[cache_dir_contents %in% files]

    # add full file path to the files
    files <- paste0(cache_dir, "/", files)

    # fill the space with a "\" for R, if one exists
    files <- gsub(" ", "\\ ", files, fixed = TRUE)

    return(files)
  }

#' @noRd
.get_local <- function(pre,
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
                       elv,
                       cache_dir) {
  # check if pre_cv or tmx/tmn (derived) are true, make sure proper ----------
  # parameters set TRUE
  if (isTRUE(pre_cv)) {
    pre <- TRUE
  }

  if (isTRUE(tmn) | isTRUE(tmx)) {
    dtr <- tmp <- TRUE
  }

  dtr_file <- "grid_10min_dtr.dat.gz"
  tmp_file <- "grid_10min_tmp.dat.gz"
  reh_file <- "grid_10min_reh.dat.gz"
  elv_file <- "grid_10min_elv.dat.gz"
  pre_file <- "grid_10min_pre.dat.gz"
  sun_file <- "grid_10min_sunp.dat.gz"
  wnd_file <- "grid_10min_wnd.dat.gz"
  frs_file <- "grid_10min_frs.dat.gz"
  rd0_file <- "grid_10min_rd0.dat.gz"

  object_list <- c(dtr, tmp, reh, elv, pre, sunp, wnd, frs, rd0)

  files <-
    c(
      dtr_file,
      tmp_file,
      reh_file,
      elv_file,
      pre_file,
      sun_file,
      wnd_file,
      frs_file,
      rd0_file
    )
  names(files) <-
    names(object_list) <-
    c(
      "dtr_file",
      "tmp_file",
      "reh_file",
      "elv_file",
      "pre_file",
      "sun_file",
      "wnd_file",
      "frs_file",
      "rd0_file"
    )

  # filter files -------------------------------------------------------------
  # which files are being requested?
  files <- files[object_list %in% !isTRUE(files)]

  # filter files from cache directory in case there are local files for which
  # we do not want data
  cache_dir_contents <- as.list(list.files(cache_dir, pattern = ".dat.gz$"))

  files <- cache_dir_contents[cache_dir_contents %in% files]

  if (length(files) < 0) {
    stop(
      "There are no CRU CL v. 2.0 data files available in this directory."
    )
  }

  # add full file path to the files
  files <- paste0(cache_dir, "/", files)

  # fill the space with a "\" for R, if one exists
  files <- gsub(" ", "\\ ", files, fixed = TRUE)

  return(files)
}
