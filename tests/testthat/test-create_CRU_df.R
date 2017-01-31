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

-test_that("create_CRU_df creates a tidy data frame of max temperature", {
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
