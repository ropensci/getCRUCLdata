# Mock .retry_download() so tests never hit the network
mock_retry_download <- function(url, dest, .max_tries = 3L) {
  fname <- fs::path_file(url)
  src <- fixture_path(fname)

  if (!fs::file_exists(src)) {
    stop("Mock download: fixture not found: ", fname, call. = FALSE)
  }

  fs::file_copy(src, dest, overwrite = TRUE)
  invisible(dest)
}
