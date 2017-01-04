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

test_that("create_CRU_stack creates a list containing only wet days", {
  skip_on_cran()
  stacks <- create_CRU_stack(rd0 = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "rd0")
  expect_named(stacks$rd0, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$rd0, min), c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
  expect_equal(raster::cellStats(stacks$rd0, max), c(30.8, 28.2, 31.0, 30.0, 30.7, 28.7, 29.7, 28.7, 27.7, 28.4, 28.5, 29.5))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only tmp", {
  skip_on_cran()
  stacks <- create_CRU_stack(tmp = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "tmp")
  expect_named(stacks$tmp, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$tmp, min), c(-41.4, -43.8, -43.2, -35.1, -22.2, -16.3, -14.0, -17.3, -26.4, -36.3, -39.9, -41.9))
 expect_equal(raster::cellStats(stacks$tmp, max), c(29.4, 30.5, 32.4, 34.3, 36.0, 38.3, 37.5, 36.8, 34.8, 32.8, 29.7, 29.3))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})


test_that("create_CRU_stack creates a list containing only RH", {
  skip_on_cran()
  stacks <- create_CRU_stack(reh = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "reh")
  expect_named(stacks$reh, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$reh, min), c(18.4, 14.6, 13.5, 13.4, 15.5, 10.2, 10.8, 10.1, 11.0, 14.2, 19.0, 19.7))
  expect_equal(raster::cellStats(stacks$reh, max), c(100.0, 100.0, 100.0, 100.0, 96.9, 95.1, 96.9, 97.1, 95.5, 100.0, 100.0, 100.0))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only sun days", {
  skip_on_cran()
  stacks <- create_CRU_stack(sunp = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "sun")
  expect_named(stacks$sun, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$sun, min), c(0.0, 0.0, 3.3, 4.3, 8.1, 6.6, 5.3, 8.4, 4.5, 0.8, 0.0, 0.0))
  expect_equal(raster::cellStats(stacks$sun, max), c(92.8, 93.0, 90.2, 92.1, 93.1, 98.9, 98.8, 98.8, 99.1, 93.2, 94.6, 93.1))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only frost days", {
  skip_on_cran()
  stacks <- create_CRU_stack(frs = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "frs")
  expect_named(stacks$frs, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$frs, min), c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
  expect_equal(raster::cellStats(stacks$frs, max), c(31.0, 28.3, 31.0, 30.0, 31.0, 30.0, 27.8, 30.0, 30.0, 31.0, 30.0, 31.0))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only wnd", {
  skip_on_cran()
  stacks <- create_CRU_stack(wnd = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "wnd")
  expect_named(stacks$wnd, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  expect_equal(raster::cellStats(stacks$wnd, min), c(0.2, 0.3, 0.3, 0.4, 0.3, 0.2, 0.3, 0.4, 0.5, 0.4, 0.2, 0.3))
  expect_equal(raster::cellStats(stacks$wnd, max), c(9.8, 9.6, 9.4, 8.7, 8.7, 8.6, 9.1, 9.3, 9.3, 9.7, 9.6, 9.4))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only elv", {
  skip_on_cran()
  stacks <- create_CRU_stack(elv = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "elv")
  expect_named(stacks$elv, "elv")
  expect_equal(raster::cellStats(stacks$elv, max), 6242)
  expect_equal(raster::cellStats(stacks$elv, min), -361)
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})
