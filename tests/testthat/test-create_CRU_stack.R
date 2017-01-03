context("create_CRU_stack")

test_that("create_CRU_stack fails if no parameters are TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  expect_error(create_CRU_stack(),
               "You must select at least one parameter for download.")
})

test_that("create_CRU_stack creates a list of raster stacks of pre and tmp", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  stacks <- create_CRU_stack(pre = TRUE, tmp = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, c("pre", "tmp"))
  expect_named(
    stacks$pre,
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
    stacks$tmp,
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
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

test_that("create_CRU_stack creates stacks of tmn and tmx", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  stacks <- create_CRU_stack(tmn = TRUE, tmx = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, c("tmn", "tmx"))
  expect_equal(
    raster::cellStats(stacks$tmx, max),
    c(
      39.70,
      38.40,
      40.25,
      41.85,
      43.60,
      45.95,
      45.70,
      44.85,
      42.35,
      39.50,
      39.20,
      39.90
    )
  )
  expect_equal(
    raster::cellStats(stacks$tmx, min),
    c(
      -48.20,
      -43.35,
      -41.65,
      -32.45,
      -17.55,
      -11.50,
      -10.85,
      -12.30,
      -21.65,
      -32.05,
      -37.55,
      -45.50
    )
  )
  expect_equal(
    raster::cellStats(stacks$tmn, max),
    c(
      26.30,
      26.25,
      27.40,
      27.50,
      30.00,
      30.65,
      30.60,
      30.40,
      28.75,
      26.95,
      25.90,
      26.55
    )
  )
  expect_equal(
    raster::cellStats(stacks$tmn, min),
    c(
      -55.05,
      -52.95,
      -48.75,
      -41.35,
      -28.00,
      -21.40,
      -18.75,
      -22.55,
      -31.45,
      -40.60,
      -45.75,
      -52.50
    )
  )

  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})
