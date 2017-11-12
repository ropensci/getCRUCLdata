
.set_cache <- function(cache) {
  if (isTRUE(cache)) {
    if (!dir.exists(CRU_cache$cache_path_get())) {
      CRU_cache$mkdir()
    }
    cache_dir <- CRU_cache$cache_path_get()
  } else {
   cache_dir <- tempdir()
  }
  return(cache_dir)
}
