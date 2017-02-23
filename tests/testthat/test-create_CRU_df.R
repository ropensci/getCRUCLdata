
context("create_CRU_df")

unlink(list.files(
  path = tempdir(),
  pattern = ".dat.gz$",
  full.names = TRUE
))

test_that("create_CRU_df fails if no parameters are TRUE", {
  expect_error(create_CRU_df(),
               "You must select at least one parameter for download.")
})

test_that("Test that .tidy_df creates a tidy dataframe of pre, pre_cv and tmp", {
  CRU_df <-
    create_CRU_df(pre_cv = TRUE,
                  pre = TRUE,
                  tmn = FALSE,
                  tmx = FALSE,
                  elv = FALSE,
                  tmp = TRUE)

  expect_true(is.data.frame(CRU_df))
  expect_named(CRU_df, c("lat", "lon", "month", "pre", "pre_cv", "tmp"))
  expect_is(CRU_df$lat, "numeric")
  expect_is(CRU_df$lon, "numeric")
  expect_is(CRU_df$month, "character")
  expect_is(CRU_df$pre, "numeric")
  expect_is(CRU_df$pre_cv, "numeric")
  expect_is(CRU_df$tmp, "numeric")
})


test_that("Test that .tidy_df creates a tidy dataframe of pre, pre_cv, tmp and elv", {
  skip_on_cran()

  CRU_df <-
    create_CRU_df(pre_cv = TRUE,
                  pre = TRUE,
                  tmn = FALSE,
                  tmx = FALSE,
                  tmp = TRUE,
                  elv = TRUE)

  expect_true(is.data.frame(CRU_df))
  expect_named(CRU_df, c("lat", "lon", "month", "pre", "pre_cv", "tmp", "elv"))
  expect_is(CRU_df$lat, "numeric")
  expect_is(CRU_df$lon, "numeric")
  expect_is(CRU_df$elv, "numeric")
})

unlink(list.files(
  path = tempdir(),
  pattern = ".dat.gz$",
  full.names = TRUE
))

