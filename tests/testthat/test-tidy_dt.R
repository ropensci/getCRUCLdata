test_that(".tidy_dt merges multiple CRU files correctly", {
  pre <- copy_fixture_to_temp("grid_10min_pre.dat.gz")
  tmp <- copy_fixture_to_temp("grid_10min_tmp.dat.gz")

  vars <- c(
    pre = TRUE,
    pre_cv = FALSE,
    tmp = TRUE,
    dtr = FALSE,
    reh = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  tidy_dt <- .tidy_dt(vars, c(pre, tmp))

  expect_s3_class(tidy_dt, "data.table")
  expect_true(all(c("lat", "lon", "month", "pre", "tmp") %in% names(tidy_dt)))
  expect_identical(nrow(tidy_dt), 10L * 12L)
})
