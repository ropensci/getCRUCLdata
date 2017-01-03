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
  expect_equal(raster::cellStats(stacks$tmx, max), c(39.70, 38.40, 40.25, 41.85, 43.60, 45.95, 45.70, 44.85, 42.35, 39.50, 39.20, 39.90 ))
  expect_equal(raster::cellStats(stacks$tmx, min), c(-48.20, -43.35, -41.65, -32.45, -17.55, -11.50, -10.85, -12.30, -21.65, -32.05, -37.55, -45.50))
  expect_equal(raster::cellStats(stacks$tmn, max), c(26.30, 26.25, 27.40, 27.50, 30.00, 30.65, 30.60, 30.40, 28.75, 26.95, 25.90, 26.55))
  expect_equal(raster::cellStats(stacks$tmn, min), c(-55.05, -52.95, -48.75, -41.35, -28.00, -21.40, -18.75, -22.55, -31.45, -40.60, -45.75, -52.50))

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
  expect_equal(raster::cellStats(stacks$pre, max), c(910.1, 824.3, 727.3, 741.3, 1100.0, 2512.6, 2505.5, 1799.4, 849.8, 851.6, 843.7, 733.3))
  expect_equal(raster::cellStats(stacks$pre, min), c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates a list containing only pre_cv", {
  skip_on_cran()
  stacks <- create_CRU_stack(pre = TRUE, pre_cv = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, "pre_cv")
  expect_named(stacks$pre_cv, c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))
  #expect_equal(raster::cellStats(stacks$pre_cv, max), c())
  #expect_equal(raster::cellStats(stacks$pre_cv, min), c())
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
  expect_equal(raster::cellStats(stacks$rd0, max), c(31.0, 28.2, 31.0, 30.0, 30.7, 30.0, 31.0, 31.0, 29.1, 28.4, 28.5, 30.3))
  expect_equal(raster::cellStats(stacks$rd0, min), c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
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
  expect_equal(raster::cellStats(stacks$tmp, max), c(32.5, 32.1, 32.4, 34.3, 36.0, 38.3, 37.8, 36.8, 34.8, 32.8, 32.4, 32.2))
  expect_equal(raster::cellStats(stacks$tmp, min), c(-51.6, -47.6, -45.2, -36.6, -22.2, -16.3, -14.0, -17.3, -26.4, -36.3, -41.6, -49.0))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

