#' Use httr2 to fetch a file with retries
#'
#' Downloads a file with retry logic and optional progress display.
#' The downloaded file is written to `dest`.
#'
#' @param url Character. The full URL to download.
#' @param dest Character. File path where the downloaded file will be written.
#' @param .max_tries Integer. Number of retry attempts.
#'
#' @returns Invisibly returns `dest` for convenience.
#' @dev Internal function, not user-facing.
.retry_download <- function(url, dest, .max_tries = 3L) {
  fs_dir_create(fs_path_dir(dest))

  req <- req_request(url) |>
    req_user_agent("getCRUCLdata") |>
    req_headers(
      "Accept-Encoding" = "identity",
      "Connection" = "Keep-Alive"
    ) |>
    req_retry(max_tries = .max_tries) |>
    req_cache(path = fs_path_temp()) |>
    req_error(is_error = function(resp) FALSE) |>
    req_options()

  resp <- req_perform(req)

  status <- resp_status(resp)
  if (status >= 400L) {
    cli_abort(
      "Failed to download {.url {url}} (HTTP {status})."
    )
  }

  write_file_raw(
    resp_body_raw(resp),
    path = dest
  )

  invisible(dest)
}

fs_dir_create <- fs::dir_create
fs_path_dir <- fs::path_dir
fs_path_temp <- fs::path_temp

req_request <- httr2::request
req_user_agent <- httr2::req_user_agent
req_headers <- httr2::req_headers
req_retry <- httr2::req_retry
req_cache <- httr2::req_cache
req_error <- httr2::req_error
req_options <- httr2::req_options
req_perform <- httr2::req_perform
resp_status <- httr2::resp_status
resp_body_raw <- httr2::resp_body_raw

write_file_raw <- brio::write_file_raw
cli_abort <- cli::cli_abort
