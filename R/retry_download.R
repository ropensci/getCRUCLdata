#' Use httr2 to fetch a file with retries
#'
#' Retries to download the requested resource before stopping. Uses
#'  \CRANpkg{httr2} to cache in-session results in the `tempdir()`.
#'
#' @param cru_file `Character` A CRU filename to be downloaded to local storage.
#' @param .max_tries `Integer` The number of times to retry a failed download
#'   before emitting an error message.
#'
#' @examples
#'
#' cru_file <- "grid_10min_tmp.dat.gz"
#' .retry_download(
#'   cru_file = cru_file
#' )
#'
#' @returns Called for its side-effects, writes an object to the `tempdir()`
#'   for reading into the active \R session later.
#' @dev

.retry_download <- function(cru_file, .max_tries = 3L) {
  url <- sprintf("https://crudata.uea.ac.uk/cru/data/hrg/tmc/%s", cru_file)
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
    brio::write_file_raw(path = fs::path_temp(cru_file))
}

#' Apply conditional options to httr2 request
#' @param req A \CRANpkg{httr2} request object
#' @param url The URL being requested
#' @returns Modified \CRANpkg{httr2} request object
#' @dev
.apply_conditional_options <- function(req) {
  # Progress display for verbose mode
  if (.should_show_progress()) {
    req <- req |> httr2::req_progress()
  }

  req
}

#' Check if progress should be shown
#' @returns Logical
#' @dev
.should_show_progress <- function() {
  identical(getOption("getCRUCLdata.verbosity"), "verbose")
}
