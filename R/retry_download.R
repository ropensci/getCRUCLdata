#' Use httr2 to fetch a file with retries
#'
#' Retries to download the requested resource before stopping. Uses
#'  \CRANpkg{httr2} to cache in-session results in the `tempdir()`.
#'
#' @param url `Character` The URL being requested.
#' @param .max_tries `Integer` The number of times to retry a failed download
#'   before emitting an error message.
#'
#' @examples
#'
#' f <- fs::path(fs::path_temp(), "grid_10min_tmp.dat.gz")
#' .retry_download(
#'   url =
#'    sprintf("https://crudata.uea.ac.uk/cru/data/hrg/tmc/%s", fs::path_file(f))
#'   dest = f
#' )
#'
#' @returns Called for its side-effects of writing an object to the active \R
#'  session's `tempdir()`.
#' @dev

.retry_download <- function(url, .max_tries = 3L) {
  # Build base request
  req <- httr2::request(base_url = url) |>
    httr2::req_user_agent("getCRUCLdata") |>
    httr2::req_headers(
      "Accept-Encoding" = "identity",
      "Connection" = "Keep-Alive"
    ) |>
    httr2::req_retry(max_tries = .max_tries) |>
    httr2::req_cache(path = fs::path_temp())

  # Apply conditional modifications
  req <- .apply_conditional_options(req)

  # Perform request and save
  req |>
    httr2::req_perform() |>
    httr2::resp_body_raw() |>
    brio::write_file_raw(path = fs::path(fs::path_temp(), fs::path_file(url)))
}

#' Apply conditional options to httr2 request
#' @param req A \CRANpkg{httr2} request object.
#' @param url The URL being requested.
#' @returns Modified \CRANpkg{httr2} request object.
#' @dev
.apply_conditional_options <- function(req) {
  # Progress display for verbose mode
  if (.should_show_progress()) {
    req <- req |> httr2::req_progress()
  }

  req
}

#' Check if progress should be shown
#' @returns Boolean
#' @dev
.should_show_progress <- function() {
  identical(getOption("getCRUCLdata.verbosity"), "verbose")
}
