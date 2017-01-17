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
      c("dtr_url",
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

    # Download files -----------------------------------------------------------
    # adapted from my question on SO,
    # http://stackoverflow.com/questions/40715370/
    message(" \nDownloading requested data files.\n ")
    s_curl_fetch_disk <- purrr::safely(curl::curl_fetch_disk)
    retry_cfd <- function(url, path) {
      cache_file <- paste0(cache_dir, "/", basename(url))
      if (file.exists(cache_file))
        return()
      i <- 0
      repeat {
        i <- i + 1
        if (i == 6) {
          stop("Too many retries...server may be under load")
        }
        res <- s_curl_fetch_disk(url, cache_file)
        if (!is.null(res$result))
          return()
      }
    }
    purrr::walk(files, function(f) {
      purrr::walk(files, retry_cfd)
    })
  }
