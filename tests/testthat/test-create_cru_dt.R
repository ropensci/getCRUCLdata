test_that(".create_dt computes derived variables correctly", {
  pre_file <- copy_fixture_to_temp("grid_10min_pre.dat.gz")
  tmp_file <- copy_fixture_to_temp("grid_10min_tmp.dat.gz")

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

  # IMPORTANT: pass file paths, not tidy data
  dtv <- .create_dt(vars, c(pre_file, tmp_file))

  expect_s3_class(dtv, "data.table")
  expect_true(all(c("lat", "lon", "month", "pre", "tmp") %in% names(dtv)))
})
