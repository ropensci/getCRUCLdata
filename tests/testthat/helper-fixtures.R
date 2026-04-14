# Helper to locate fixture files
fixture_path <- function(name) {
  testthat::test_path("fixtures", name)
}

copy_fixture_to_temp <- function(name) {
  dest <- file.path(tempdir(), name)
  fs::file_copy(fixture_path(name), dest, overwrite = TRUE)
  dest
}
