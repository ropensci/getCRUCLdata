test_that(".read_local_files lists local files", {
  vars <- c(
    pre = TRUE,
    pre_cv = FALSE,
    tmp = FALSE,
    dtr = FALSE,
    reh = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  # Test 1: Directory with files (test_path already points to fixtures)
  fixture_dir <- test_path("fixtures")
  dtvar <- .read_local_files(fixture_dir, vars)
  expect_s3_class(dtvar, "data.table")
  expect_true(all(c("lat", "lon", "month") %in% names(dtvar)))

  # Test 2: Single file directly
  pre_file <- test_path("fixtures", "grid_10min_pre.dat.gz")
  dtvar2 <- .read_local_files(file = pre_file, vars = vars)
  expect_s3_class(dtvar2, "data.table")
  expect_true(all(c("lat", "lon", "month", "pre") %in% names(dtvar2)))
})
