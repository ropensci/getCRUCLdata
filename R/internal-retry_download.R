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
    cli::cli_abort("Failed to download {.url {url}} (HTTP {status}).")
  }

  write_file_raw(resp_body_raw(resp), path = dest)
  invisible(dest)
}

#' @noRd
fs_dir_create <- function(...) fs::dir_create(...)

#' @noRd
fs_path_dir <- function(...) fs::path_dir(...)

#' @noRd
fs_path_temp <- function(...) fs::path_temp(...)

#' @noRd
req_request <- function(...) httr2::request(...)

#' @noRd
req_user_agent <- function(...) httr2::req_user_agent(...)

#' @noRd
req_headers <- function(...) httr2::req_headers(...)

#' @noRd
req_retry <- function(...) httr2::req_retry(...)

#' @noRd
req_cache <- function(...) httr2::req_cache(...)

#' @noRd
req_error <- function(...) httr2::req_error(...)

#' @noRd
req_options <- function(...) httr2::req_options(...)

#' @noRd
req_perform <- function(...) httr2::req_perform(...)

#' @noRd
resp_status <- function(...) httr2::resp_status(...)

#' @noRd
resp_body_raw <- function(...) httr2::resp_body_raw(...)

#' @noRd
write_file_raw <- function(...) brio::write_file_raw(...)
