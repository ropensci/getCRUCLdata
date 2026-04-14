test_that("read_cru_dt loads CRU data from fixtures", {
  local_d <- withr::local_tempdir()
  fs::dir_create(local_d) # <-- FORCE creation of directory

  expect_true(fs::is_dir(local_d))

  fs::file_copy(
    fs::dir_ls(test_path("fixtures"), glob = "*.dat.gz"),
    local_d,
    overwrite = TRUE
  )

  df <- read_cru_dt(
    pre = TRUE,
    pre_cv = TRUE,
    tmp = TRUE,
    x = local_d
  )

  expect_s3_class(df, "data.table")
  expect_true(all(
    c("lat", "lon", "month", "pre", "pre_cv", "tmp") %in% names(df)
  ))
})
