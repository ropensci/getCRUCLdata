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

test_that("create_CRU_stack creates a list containing only elv", {
  skip_on_cran()

  # These data are taken from the raw elevation data file
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
  expect_equal(raster::extent(stacks)[4], 85)
  unlink(list.files(
    path = tempdir(),
    pattern = "elv.txt$",
    full.names = TRUE
  ))
})
