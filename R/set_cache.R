
.set_cache <- function(cache) {
  if (isTRUE(cache)) {
    cache_dir <- rappdirs::user_cache_dir("getCRUCLdata")
    if (!dir.exists(cache_dir)) {
      dir.create(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                          appauthor = "getCRUCLdata"),
                 recursive = TRUE)
    }
  } else {
    cache_dir <- tempdir()
  }
  return(cache_dir)
}
