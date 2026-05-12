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
#' @importFrom fs dir_create path_dir path_temp
#' @importFrom httr2 request req_user_agent req_headers req_retry req_cache
#' @importFrom httr2 req_error req_options req_perform resp_status resp_body_raw
#' @importFrom brio write_file_raw
#' @importFrom cli cli_abort

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

fs_dir_create <- dir_create
fs_path_dir <- path_dir
fs_path_temp <- path_temp

req_request <- request
req_user_agent <- req_user_agent
req_headers <- req_headers
req_retry <- req_retry
req_cache <- req_cache
req_error <- req_error
req_options <- req_options
req_perform <- req_perform
resp_status <- resp_status
resp_body_raw <- resp_body_raw

write_file_raw <- write_file_raw
cli_abort <- cli_abort
