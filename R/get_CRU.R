#' Downloads and formats CRU CL 2.0 data
#'
#' This is a new and simplified implementation of `get_CRU()`, note the all caps
#'  for "CRU" in the prior function.
#'
#' @param files A vector of file names to download from the server.
#'
#' Handles the downloading of CRU CL 2.0 data. This function is called by
#' [read_cru_dt] and [read_cru_rast]. It is not intended to be called directly.
#'
#' @returns A vector of local file names with the requested data.
#'
#' @dev
.get_cru <- function(files) {
  # download files ----------------------------------------------------------
  if (length(files) > 0L) {
    cru_url <- "https://crudata.uea.ac.uk/cru/data/hrg/tmc/"
    dl_files <- as.list(paste0(cru_url, files))

    tryCatch(
      for (f in seq_along(dl_files)) {
        .retry_download(url = dl_files[[f]], .max_tries = 3L)
      },
      error = function(x) {
        cli::cli_abort(
          "The file downloads have failed.
          Please start the download again."
        )
      }
    )
  }

  return(files)
}
