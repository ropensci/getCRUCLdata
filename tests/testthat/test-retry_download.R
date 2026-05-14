fake_req <- structure(list(), class = "httr2_request")
fake_resp <- structure(list(), class = "httr2_response")

mock_names <- c(
  "fs_dir_create",
  "fs_path_dir",
  "fs_path_temp",
  "req_request",
  "req_user_agent",
  "req_headers",
  "req_retry",
  "req_cache",
  "req_error",
  "req_options",
  "req_perform",
  "resp_status",
  "resp_body_raw",
  "write_file_raw"
)

default_mocks <- list(
  fs_dir_create = function(...) invisible(NULL),
  fs_path_dir = function(path, ...) "/tmp",
  fs_path_temp = function(...) "/tmp",

  req_request = function(...) fake_req,
  req_user_agent = function(req, ...) req,
  req_headers = function(req, ...) req,
  req_retry = function(req, max_tries, ...) req,
  req_cache = function(req, ...) req,
  req_error = function(req, ...) req,
  req_options = function(req, ...) req,
  req_perform = function(req, ...) fake_resp,

  resp_status = function(...) 200L,
  resp_body_raw = function(...) as.raw(c(0x68, 0x69)),

  write_file_raw = function(...) invisible(NULL)
)

merge_mocks <- function(defaults, overrides = list()) {
  if (length(overrides) == 0) {
    return(defaults)
  }

  defaults[names(overrides)] <- overrides
  defaults
}

local_retry_download_mocks <- function(overrides = list()) {
  local_mocked_bindings(
    .env = getNamespace("getCRUCLdata"),
    !!!merge_mocks(default_mocks[mock_names], overrides)
  )
}

test_that(".retry_download returns dest invisibly on success", {
  dest <- "/tmp/file.nc"
  local_retry_download_mocks()

  result <- withVisible(.retry_download(
    "https://example.com/file.nc",
    dest
  ))

  expect_identical(result$value, dest)
  expect_false(result$visible)
})

test_that(".retry_download aborts on HTTP 404", {
  local_retry_download_mocks(
    list(resp_status = function(...) 404L)
  )

  expect_error(
    .retry_download("https://example.com/missing.nc", "/tmp/missing.nc"),
    regexp = "HTTP 404"
  )
})

test_that(".retry_download aborts on HTTP 500", {
  local_retry_download_mocks(
    list(resp_status = function(...) 500L)
  )

  expect_error(
    .retry_download("https://example.com/broken.nc", "/tmp/broken.nc"),
    regexp = "HTTP 500"
  )
})

test_that(".retry_download does not abort below the 400 threshold", {
  local_retry_download_mocks(
    list(resp_status = function(...) 399L)
  )

  expect_no_error(
    .retry_download("https://example.com/ok.nc", "/tmp/ok.nc")
  )
})

test_that(".retry_download writes the raw response body to dest", {
  raw_bytes <- as.raw(c(0x01, 0x02, 0x03))
  written_path <- NULL
  written_bytes <- NULL

  local_retry_download_mocks(
    list(
      resp_body_raw = function(...) raw_bytes,
      write_file_raw = function(data, path) {
        written_bytes <<- data
        written_path <<- path
      }
    )
  )

  .retry_download("https://example.com/data.nc", "/tmp/data.nc")

  expect_equal(written_bytes, raw_bytes)
  expect_equal(written_path, "/tmp/data.nc")
})

test_that(".retry_download creates the destination directory", {
  created_dir <- NULL

  local_retry_download_mocks(
    list(
      fs_path_dir = function(path, ...) "/some/nested/dir",
      fs_dir_create = function(path, ...) {
        created_dir <<- path
      }
    )
  )

  .retry_download("https://example.com/data.nc", "/some/nested/dir/data.nc")

  expect_identical(created_dir, "/some/nested/dir")
})

test_that(".retry_download forwards .max_tries to req_retry", {
  captured_max_tries <- NULL

  local_retry_download_mocks(
    list(
      req_retry = function(req, max_tries, ...) {
        captured_max_tries <<- max_tries
        req
      }
    )
  )

  .retry_download(
    "https://example.com/data.nc",
    "/tmp/data.nc",
    .max_tries = 7L
  )

  expect_identical(captured_max_tries, 7L)
})

test_that(".retry_download error message includes the URL and status code", {
  url <- "https://example.com/secret.nc"

  local_retry_download_mocks(
    list(resp_status = function(...) 403L)
  )

  expect_error(
    .retry_download(url, "/tmp/secret.nc"),
    regexp = "secret\\.nc.*403|403.*secret\\.nc"
  )
})
