context("create_CRU_df")

unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))

test_that("create_CRU_df fails if no parameters are TRUE", {
  expect_error(create_CRU_df(),
               "You must select at least one parameter for download.")
})

test_that("create_CRU_df creates a tidy data frame of precipitation", {
  skip_on_cran()
  pre_df <- create_CRU_df(pre = TRUE)
  expect_true(is.data.frame(pre_df))
  expect_named(pre_df, c("lat", "lon", "month", "pre"))
  expect_is(pre_df$lat, "numeric")
  expect_is(pre_df$lon, "numeric")
  expect_is(pre_df$month, "character")
  expect_is(pre_df$pre, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})

test_that("create_CRU_df creates a tidy data frame of precipitation cv", {
  skip_on_cran()
  pre_cv_df <- create_CRU_df(pre_cv = TRUE)
  expect_true(is.data.frame(pre_cv_df))
  expect_named(pre_cv_df, c("lat", "lon", "month", "pre", "pre_cv"))
  expect_is(pre_cv_df$lat, "numeric")
  expect_is(pre_cv_df$lon, "numeric")
  expect_is(pre_cv_df$month, "character")
  expect_is(pre_cv_df$pre, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})

test_that("create_CRU_df creates a tidy data frame of wet days", {
  skip_on_cran()
  rd0_df <- create_CRU_df(rd0 = TRUE)
  expect_true(is.data.frame(rd0_df))
  expect_named(rd0_df, c("lat", "lon", "month", "rd0"))
  expect_is(rd0_df$lat, "numeric")
  expect_is(rd0_df$lon, "numeric")
  expect_is(rd0_df$month, "character")
  expect_is(rd0_df$rd0, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})

test_that("create_CRU_df creates a tidy data frame of diurnal temp days", {
  skip_on_cran()
  dtr_df <- create_CRU_df(dtr = TRUE)
  expect_true(is.data.frame(dtr_df))
  expect_named(dtr_df, c("lat", "lon", "month", "dtr"))
  expect_is(dtr_df$lat, "numeric")
  expect_is(dtr_df$lon, "numeric")
  expect_is(dtr_df$month, "character")
  expect_is(dtr_df$dtr, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of temperature", {
  skip_on_cran()
  tmp_df <- create_CRU_df(tmp = TRUE)
  expect_true(is.data.frame(tmp_df))
  expect_named(tmp_df, c("lat", "lon", "month", "tmp"))
  expect_is(tmp_df$lat, "numeric")
  expect_is(tmp_df$lon, "numeric")
  expect_is(tmp_df$month, "character")
  expect_is(tmp_df$tmp, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of min temperature", {
  skip_on_cran()
  tmn_df <- create_CRU_df(tmn = TRUE)
  expect_true(is.data.frame(tmn_df))
  expect_named(tmn_df, c("lat", "lon", "month", "tmn"))
  expect_is(tmn_df$lat, "numeric")
  expect_is(tmn_df$lon, "numeric")
  expect_is(tmn_df$month, "character")
  expect_is(tmn_df$tmn, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})

test_that("create_CRU_df creates a tidy data frame of max temperature", {
  skip_on_cran()
  tmx_df <- create_CRU_df(tmx = TRUE)
  expect_true(is.data.frame(tmx_df))
  expect_named(tmx_df, c("lat", "lon", "month", "tmx"))
  expect_is(tmx_df$lat, "numeric")
  expect_is(tmx_df$lon, "numeric")
  expect_is(tmx_df$month, "character")
  expect_is(tmx_df$tmx, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of RH", {
  skip_on_cran()
  reh_df <- create_CRU_df(reh = TRUE)
  expect_true(is.data.frame(reh_df))
  expect_named(reh_df, c("lat", "lon", "month", "reh"))
  expect_is(reh_df$lat, "numeric")
  expect_is(reh_df$lon, "numeric")
  expect_is(reh_df$month, "character")
  expect_is(reh_df$reh, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})

test_that("create_CRU_df creates a tidy data frame of sunp", {
  skip_on_cran()
  sunp_df <- create_CRU_df(sunp = TRUE)
  expect_true(is.data.frame(sunp_df))
  expect_named(sunp_df, c("lat", "lon", "month", "sun"))
  expect_is(sunp_df$lat, "numeric")
  expect_is(sunp_df$lon, "numeric")
  expect_is(sunp_df$month, "character")
  expect_is(sunp_df$sun, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of ground frost days", {
  skip_on_cran()
  frs_df <- create_CRU_df(frs = TRUE)
  expect_true(is.data.frame(frs_df))
  expect_named(frs_df, c("lat", "lon", "month", "frs"))
  expect_is(frs_df$lat, "numeric")
  expect_is(frs_df$lon, "numeric")
  expect_is(frs_df$month, "character")
  expect_is(frs_df$frs, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of wind", {
  skip_on_cran()
  wnd_df <- create_CRU_df(wnd = TRUE)
  expect_true(is.data.frame(wnd_df))
  expect_named(wnd_df, c("lat", "lon", "month", "wnd"))
  expect_is(wnd_df$lat, "numeric")
  expect_is(wnd_df$lon, "numeric")
  expect_is(wnd_df$month, "character")
  expect_is(wnd_df$wnd, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})


test_that("create_CRU_df creates a tidy data frame of elevation", {
  skip_on_cran()
  elv_df <- create_CRU_df(elv = TRUE)
  expect_true(is.data.frame(elv_df))
  expect_named(elv_df, c("lat", "lon", "elv"))
  expect_is(elv_df$lat, "numeric")
  expect_is(elv_df$lon, "numeric")
  expect_is(elv_df$elv, "numeric")
  unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))
})
