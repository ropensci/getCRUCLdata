context("create_CRU_stack")

unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))

test_that("create_CRU_stack fails if no parameters are TRUE", {
  skip_on_cran()
  expect_error(create_CRU_stack(),
               "You must select at least one parameter for download.")
})

test_that("create_CRU_stack creates a list of raster stacks of pre and tmp", {
  skip_on_cran()
  stacks <- create_CRU_stack(pre = TRUE, tmp = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, c("pre", "tmp"))
  expect_named(stacks$pre, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))

  expect_named(stacks$tmp, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates stacks of tmn and tmx", {
  skip_on_cran()
  stacks <- create_CRU_stack(tmn = TRUE, tmx = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, c("tmn", "tmx"))
  expect_equal(raster::cellStats(stacks$tmn, min), c(-46.15, -48.80, -47.90, -41.35, -28.00, -21.40, -18.75, -22.55, -31.45, -40.60, -44.95, -46.65))
  expect_equal(raster::cellStats(stacks$tmn, max), c(25.20, 25.30, 25.55, 27.50, 30.00, 30.65, 30.60, 30.40, 28.75, 26.95, 24.85, 24.50))
  expect_equal(raster::cellStats(stacks$tmx, min), c(-36.85, -38.90, -38.70, -28.95, -16.85, -11.50, -10.85, -12.30, -21.65, -32.05, -35.15, -37.40))
  expect_equal(raster::cellStats(stacks$tmx, max), c(36.85, 38.05, 40.25, 41.85, 43.60, 45.95, 45.70, 44.85, 42.35, 39.50, 37.70, 36.05))

 unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only pre", {
  skip_on_cran()
  stacks <- create_CRU_stack(pre = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "pre")
  expect_named(stacks$pre, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$pre, max), c(499.6, 502.3, 608.4, 560.7, 592.0, 1138.3, 2012.5, 1350.6, 591.1, 626.5, 514.1, 467.5))
  expect_equal(raster::cellStats(stacks$pre, min), c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only pre_cv", {
  skip_on_cran()
  stacks <- create_CRU_stack(pre_cv = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "pre")
  expect_named(stacks$pre, c("pre_cv_jan", "pre_cv_feb", "pre_cv_mar", "pre_cv_apr", "pre_cv_may", "pre_cv_jun", "pre_cv_jul", "pre_cv_aug", "pre_cv_sep", "pre_cv_oct", "pre_cv_nov", "pre_cv_dec"))
  expect_equal(raster::cellStats(stacks$pre, min), c(8.7, 6.1, 5.9, 6.9, 15.1, 20.7, 16.9, 2.9, 12.1, 2.8, 0.0, 0.0))
  expect_equal(raster::cellStats(stacks$pre, max), c(496.2, 495.5, 482.0, 493.6, 490.4, 573.8, 546.3, 567.6, 507.2, 504.6, 517.8, 493.7))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})
