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
  # Ensure destination directory exists
  fs::dir_create(fs::path_dir(dest))

  # Build request
  req <- httr2::request(url) |>
    httr2::req_user_agent("getCRUCLdata") |>
    httr2::req_headers(
      "Accept-Encoding" = "identity",
      "Connection" = "Keep-Alive"
    ) |>
    httr2::req_retry(max_tries = .max_tries) |>
    httr2::req_cache(path = fs::path_temp()) |>
    httr2::req_error(is_error = function(resp) FALSE)

  # Apply conditional options (progress, etc.)
  req <- httr2::req_options(req)

  # Perform request
  resp <- httr2::req_perform(req)

  # Check HTTP status
  if (httr2::resp_status(resp) >= 400L) {
    cli::cli_abort(
      "Failed to download {.url {url}} (HTTP {httr2::resp_status(resp)})."
    )
  }

  # Write raw body to disk
  brio::write_file_raw(
    httr2::resp_body_raw(resp),
    path = dest
  )

  invisible(dest)
}
