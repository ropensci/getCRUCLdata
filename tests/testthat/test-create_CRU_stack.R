context("create_CRU_stack")

test_that("create_CRU_stack fails if no parameters are TRUE", {
  skip_on_cran()
  expect_error(create_CRU_stack(),
               "You must select at least one parameter for download.")
})

test_that("create_CRU_stack creates a list of raster stacks of pre and tmp", {

  files <-
    list.files(tempdir(), pattern = ".dat.gz$", full.names = TRUE)

  stacks <- create_CRU_stack(pre = TRUE, tmp = TRUE)

  expect_true(is.list(stacks))
  expect_named(
    stacks[[1]],
    c(
      "jan",
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
      "dec"
    )
  )

  expect_named(
    stacks[[2]],
    c(
      "jan",
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
      "dec"
    )
  )
})

test_that("create_CRU_stack creates a list containing only elv", {
  skip_on_cran()

  stacks <- create_CRU_stack(elv = TRUE)

  expect_named(stacks, "elv")
  expect_named(stacks$elv, "elv")
  expect_equal(raster::cellStats(stacks$elv, max), 6486)
  expect_equal(raster::cellStats(stacks$elv, min), -361)
  expect_equal(raster::extent(stacks$elv)[1], -180)
  expect_equal(raster::extent(stacks$elv)[2], 180)
  expect_equal(raster::extent(stacks$elv)[3], -60)
  expect_equal(raster::extent(stacks$elv)[4], 85)
})

