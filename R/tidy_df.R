#' @importFrom dplyr %>%
#' @noRd
.tidy_df <-
  function(dtr,
           tmp,
           tmn,
           tmx,
           pre,
           pre_cv,
           reh,
           elv,
           sunp,
           wnd,
           frs,
           rd0,
           cache_dir) {
    files <- list.files(cache_dir, pattern = ".dat.gz$", full.names = TRUE)

    # internal function to read files from cache directory and tidy them -------

    # create list of tidied data frames ----------------------------------------
    CRU_list <-
      plyr::llply(.data = files,
                  .fun = .read_cache,
                  .progress = "text")

    # name the items in the list for the data that they contain ----------------
    names(CRU_list) <- substr(files, 73, 75)

    # rename the columns in the data frames within the list --------------------
    for (i in 1:length(CRU_list)) {
      wvars <- as.list(substr(files, 73, 75))
      names(CRU_list[[i]])[names(CRU_list[[i]]) == "wvar"] <-
        wvars[[i]]
    }

    # lastly merge the data frames into one tidy (large) data frame ------------
    CRU_df <- Reduce(function(...)
      dplyr::full_join(..., by = c("lat", "lon", "month")), CRU_list)

    return(CRU_df)

    # cleanup before we go -----------------------------------------------------
    rm(c(CRU_list, files))
  }

#' @noRd
.read_cache <- function(files, pre_cv) {
  lat <- NULL
  lon <- NULL
  month_names <-
    c("jan",
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
      "dec")

  x <- utils::read.table(files, header = FALSE, colClasses = "numeric")

                  if (ncol(x) == 14) {
                    names(x) <- c("lat", "lon", month_names)
                    x_df <-
                      x %>%
                      tidyr::gather(key = "month",
                                    value = "wvar",
                                    dplyr::everything(),
                                    -c(lat, lon))
                  } else
                    if (ncol(x) == 26) {
                      # split the data frame in 2, else errors on C stack usage
                      x_df1 <- x[, c(1:14)]
                      names(x_df1) <- c("lat", "lon", month_names)
                      x_df1 <-
                        x_df1 %>%
                        tidyr::gather(key = "month",
                                      value = "pre",
                                      dplyr::everything(),
                                      -c(lat, lon))
                      # if pre_cv is set TRUE, include it in final data frame
                      x_df2 <- x[, c(1:2, 15:26)]
                      if (isTRUE(pre_cv)) {
                        names(x_df2) <- c("lat", "lon", month_names)
                        x_df2 <-
                          x_df2 %>%
                          tidyr::gather(key = "month",
                                        value = "pre_cv",
                                        dplyr::everything(),
                                        -c(lat, lon))
                        x_df <- dplyr::bind_cols(x_df1, x_df2[, 4])
                      } else {
                        x_df <- x_df1
                      }
                    }
}
