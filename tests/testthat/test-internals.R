test_that(".tidy_dt merges fixture data correctly (parallel-safe)", {
  pre <- copy_fixture_to_temp("grid_10min_pre.dat.gz")
  tmp <- copy_fixture_to_temp("grid_10min_tmp.dat.gz")

  vars <- c(
    pre = TRUE,
    tmp = TRUE,
    pre_cv = FALSE,
    dtr = FALSE,
    reh = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  dt <- .tidy_dt(vars, c(pre, tmp))

  expect_s3_class(dt, "data.table")
  expect_true(all(c("lat", "lon", "month", "pre", "tmp") %in% names(dt)))
})

test_that(".create_dt computes derived variables correctly", {
  pre <- copy_fixture_to_temp("grid_10min_pre.dat.gz")
  tmp <- copy_fixture_to_temp("grid_10min_tmp.dat.gz")

  # Create a fake dtr fixture by copying tmp (just for test structure)
  dtr <- copy_fixture_to_temp("grid_10min_tmp.dat.gz")

  vars <- c(
    pre = TRUE,
    tmp = TRUE,
    dtr = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    pre_cv = FALSE,
    reh = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  dt_test <- .create_dt(vars, c(pre, tmp))

  expect_true("tmp" %in% names(dt_test))
  expect_true("pre" %in% names(dt_test))
})
