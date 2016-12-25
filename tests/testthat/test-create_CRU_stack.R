context("create_CRU_stack")

test_that("create_CRU_stack fails if no parameters are TRUE", {
  expect_error(create_CRU_stack(),
               "You must select at least one parameter for download.")
})

test_that("create_CRU_stack creates a list of raster stacks of pre and tmp", {
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
  unlink(paste0(
    tempdir(),
    c("/grid_10min_pre.dat.gz", "/grid_10min_tmp.dat.gz")
  ))
})

test_that("create_CRU_stack creates stacks of tmn and tmx", {
  stacks <- create_CRU_stack(tmn = TRUE, tmx = TRUE)
  expect_true(is.list(stacks))
  expect_named(stacks, c("tmn", "tmx"))
})
