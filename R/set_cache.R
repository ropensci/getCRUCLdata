
.set_cache <- function(cache) {
  if (isTRUE(cache)) {
    cache_dir <- rappdirs::user_cache_dir("getCRUCLdata")
    if (!file.exists(cache_dir)) {
      dir.create(cache_dir)
    }
  } else {
    cache_dir <- tempdir()
  }
  return(cache_dir)
}
