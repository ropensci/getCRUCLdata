test_that(".validate_x() returns absolute path for valid directory", {
  # Create a temporary directory
  temp_dir <- tempdir()

  result <- .validate_x(temp_dir, "tmp")

  expect_true(fs::is_absolute_path(result))
  expect_true(fs::is_dir(result))
})

test_that(".validate_x() normalizes and trims path input", {
  # Create a temporary directory
  temp_dir <- tempdir()

  # Test with extra whitespace and path normalization
  messy_path <- paste0("  ", temp_dir, "  ")

  result <- .validate_x(messy_path, "tmp")

  expect_identical(result, fs::path_abs(fs::path_norm(temp_dir)))
})

test_that(".validate_x() warns and returns directory when multiple files requested with single .gz", {
  temp_dir <- tempdir()
  temp_file <- fs::path(temp_dir, "test.gz")
  fs::file_create(temp_file)

  # Convert to plain character string and normalize
  temp_dir_normalized <- as.character(fs::path_abs(fs::path_norm(temp_dir)))

  # Suppress warning for this test since we're checking the result
  result <- suppressWarnings(
    .validate_x(temp_file, c("tmp", "pre"))
  )
  expect_identical(result, temp_dir_normalized)

  # Separately verify the warning is raised
  expect_warning(
    .validate_x(temp_file, c("tmp", "pre")),
    "You supplied a single file"
  )

  # Cleanup
  fs::file_delete(temp_file)
})

test_that(".validate_x() throws error when .gz file directory does not exist", {
  nonexistent_dir <- "/nonexistent/path/that/does/not/exist"
  nonexistent_file <- fs::path(nonexistent_dir, "test.gz")

  expect_error(.validate_x(nonexistent_file, "tmp"))
})

test_that(".validate_x() returns .gz file when single variable requested", {
  temp_dir <- tempdir()
  temp_file <- fs::path(temp_dir, "test.gz")
  fs::file_create(temp_file)

  result <- .validate_x(temp_file, "tmp")

  expect_equal(result, fs::path_abs(fs::path_norm(temp_file)))

  # Cleanup
  fs::file_delete(temp_file)
})

test_that(".validate_x() handles relative paths and converts to absolute", {
  # Create a temporary directory
  temp_dir <- tempdir()
  original_wd <- getwd()
  tryCatch(
    {
      setwd(temp_dir)

      # Create a test subdirectory
      subdir <- "test_subdir"
      fs::dir_create(subdir)

      # Use relative path
      result <- .validate_x(subdir, "tmp")

      expect_true(fs::is_absolute_path(result))
      expect_true(fs::is_dir(result))

      # Cleanup
      fs::dir_delete(subdir)
    },
    finally = {
      setwd(original_wd)
    }
  )
})

test_that(".validate_x() handles paths with trailing slashes", {
  temp_dir <- tempdir()
  path_with_slash <- paste0(temp_dir, .Platform$file.sep)

  result <- .validate_x(path_with_slash, "tmp")

  expect_true(fs::is_dir(result))
})

test_that(".validate_x() correctly identifies .gz extension", {
  temp_dir <- tempdir()

  # Test with .gz file
  gz_file <- fs::path(temp_dir, "data.gz")
  fs::file_create(gz_file)

  result_gz <- .validate_x(gz_file, "tmp")
  expect_equal(fs::path_ext(result_gz), "gz")

  # Test with .tar.gz file (should still be treated as .gz)
  tar_gz_file <- fs::path(temp_dir, "data.tar.gz")
  fs::file_create(tar_gz_file)

  result_tar_gz <- .validate_x(tar_gz_file, "tmp")
  expect_equal(fs::path_ext(result_tar_gz), "gz")

  # Cleanup
  fs::file_delete(c(gz_file, tar_gz_file))
})

test_that(".validate_x() warns when multiple files with single .gz file", {
  temp_dir <- tempdir()
  temp_file <- fs::path(temp_dir, "test.gz")
  fs::file_create(temp_file)

  # Check that warning message contains expected text
  expect_warning(
    .validate_x(temp_file, c("tmp", "pre", "cld")),
    "multiple variables"
  )

  # Cleanup
  fs::file_delete(temp_file)
})

test_that(".validate_x() handles special characters in path", {
  temp_dir <- tempdir()
  # Create a subdirectory with spaces in name
  special_dir <- fs::path(temp_dir, "dir with spaces")
  fs::dir_create(special_dir)

  result <- .validate_x(special_dir, "tmp")

  expect_true(fs::is_dir(result))

  # Cleanup
  fs::dir_delete(special_dir)
})

test_that(".validate_x() throws error for non-existent directory path", {
  nonexistent_dir <- "/this/path/does/not/exist/at/all"

  expect_error(.validate_x(nonexistent_dir, "tmp"))
})

test_that(".validate_x() returns directory without error when valid directory", {
  temp_dir <- tempdir()

  # Should not error
  expect_no_error(
    result <- .validate_x(temp_dir, "tmp")
  )

  expect_equal(result, fs::path_abs(fs::path_norm(temp_dir)))
})

test_that(".validate_x() handles empty files parameter", {
  temp_dir <- tempdir()

  result <- .validate_x(temp_dir, character(0))

  expect_true(fs::is_dir(result))
})

test_that(".validate_x() returns directory with single file when no variables", {
  temp_dir <- tempdir()
  temp_file <- fs::path(temp_dir, "test.gz")
  fs::file_create(temp_file)

  # Empty files vector should behave like single file request
  result <- .validate_x(temp_file, character(0))

  # Should return the file path (no warning since length(files) is 0, not > 1)
  expect_equal(result, fs::path_abs(fs::path_norm(temp_file)))

  # Cleanup
  fs::file_delete(temp_file)
})

test_that(".validate_x() correctly determines files length for warning condition", {
  temp_dir <- tempdir()
  temp_file <- fs::path(temp_dir, "test.gz")
  fs::file_create(temp_file)

  # Exactly 2 files should trigger warning
  expect_warning(
    .validate_x(temp_file, c("tmp", "pre"))
  )

  # Exactly 1 file should not warn
  expect_no_warning(
    .validate_x(temp_file, "tmp")
  )

  # Cleanup
  fs::file_delete(temp_file)
})

test_that(".validate_x() preserves .gz extension in returned path", {
  temp_dir <- tempdir()
  gz_file <- fs::path(temp_dir, "cru_tmp_2020.gz")
  fs::file_create(gz_file)

  result <- .validate_x(gz_file, "tmp")

  expect_true(grepl("\\.gz$", result))

  # Cleanup
  fs::file_delete(gz_file)
})
