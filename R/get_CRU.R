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
    CRU_url <- "https://crudata.uea.ac.uk/cru/data/hrg/tmc/"
    dtr_url <- paste0(CRU_url, "grid_10min_dtr.dat.gz")
    tmp_url <- paste0(CRU_url, "grid_10min_tmp.dat.gz")
    reh_url <- paste0(CRU_url, "grid_10min_reh.dat.gz")
    elv_url <- paste0(CRU_url, "grid_10min_elv.dat.gz")
    pre_url <- paste0(CRU_url, "grid_10min_pre.dat.gz")
    sun_url <- paste0(CRU_url, "grid_10min_sunp.dat.gz")
    wnd_url <- paste0(CRU_url, "grid_10min_wnd.dat.gz")
    frs_url <- paste0(CRU_url, "grid_10min_frs.dat.gz")
    rd0_url <- paste0(CRU_url, "grid_10min_rd0.dat.gz")

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
      c(dtr_url,
        tmp_url,
        reh_url,
        elv_url,
        pre_url,
        sun_url,
        wnd_url,
        frs_url,
        rd0_url)
    names(files) <-
      names(object_list) <-
      c(
        "dtr_url",
        "tmp_url",
        "reh_url",
        "elv_url",
        "pre_url",
        "sun_url",
        "wnd_url",
        "frs_url",
        "rd0_url"
      )

    # filter downloads ---------------------------------------------------------

    files <- as.list(files[object_list %in% !isTRUE(files)])

    # check to see, did we already download these data, if so don't redownload--
    cache_dir_contents <-
      list.files(cache_dir, pattern = ".dat.gz$")

    # if there are files already locally available;
    # check against the newly requested files and update list to download ------

    if (length(cache_dir_contents) > 0) {

      # remove files that are not requested a second time around ---------------
      rm_files <- basename(unlist(files))
      rm_files <- cache_dir_contents[!(cache_dir_contents %in% rm_files)]
      rm_files <- paste0(cache_dir, "/", rm_files)
      file.remove(rm_files)

      # create list of files that do need to be downloaded ---------------------
      cache_dir_contents <- paste0(CRU_url, cache_dir_contents)
      files <- as.list(files[!(files %in% cache_dir_contents)])
    }

    if (length(files) > 0) {
      # download files ---------------------------------------------------------
      message(" \nDownloading requested data files.\n ")
      pb <-
        utils::txtProgressBar(
          min = 0,
          max = length(files),
          initial = 0,
          style = 3
        )
      for (f in 1:length(files)) {
        httr::GET(url = files[[f]],
                  httr::write_disk(paste0(cache_dir, "/",
                                          basename(files[[f]])),
                                   overwrite = TRUE))
        utils::setTxtProgressBar(pb, f)
      }
    }
  }
