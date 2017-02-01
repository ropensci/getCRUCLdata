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

test_that("create_CRU_stack creates a list containing only elv", {
  skip_on_cran()
  V1 <-
    c(
      -59.083,
      -58.417,
      -58.417,
      -55.917,
      -55.750,
      -55.750,
      -55.750,
      -55.583,
      -55.583,
      -55.583
    )
  V2 <-
    c(
      -26.583,
      -26.417,
      -26.250,
      -67.250,
      -67.583,
      -67.417,
      -67.250,
      -68.250,
      -68.083,
      -67.583
    )
  V3 <-
    c(0.193,
      0.239,
      0.194,
      0.064,
      0.032,
      0.103,
      0.063,
      0.062,
      0.123,
      0.019)


  elv <- data.frame(V1, V2, V3)

  utils::write.table(
    elv,
    file = paste0(tempdir(), "/elv.txt"),
    col.names = FALSE,
    row.names = FALSE
  )
  files <- list.files(path = tempdir(),
                      pattern = "^elv.txt$",
                      full.names = TRUE)

  wrld <-
    raster::raster(
      nrows = 930,
      ncols = 2160,
      ymn = -65,
      ymx = 90,
      xmn = -180,
      xmx = 180
    )

  wrld[] <- NA

  month_names <-
    c("jan",
      "feb",
      "mar",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "oct",
      "nov",
      "dec")
  pre <- pre_cv <- NULL

  stacks <- .create_stack(files, wrld, month_names, pre, pre_cv)
  expect_named(stacks, "elv")
  expect_named(stacks$elv, "elv")
  expect_equal(raster::cellStats(stacks$elv, max), 239)
  expect_equal(raster::cellStats(stacks$elv, min), 19)
  expect_equal(raster::extent(stacks)[1], -180)
  expect_equal(raster::extent(stacks)[2], 180)
  expect_equal(raster::extent(stacks)[3], -60)
  expect_equal(raster::extent(stacks)[1], 85)
  unlink(list.files(
    path = tempdir(),
    pattern = "elv.txt$",
    full.names = TRUE
  ))
})
