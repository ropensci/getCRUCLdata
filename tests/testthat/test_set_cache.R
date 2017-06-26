
# test that .set_cache creates a cache directory if none exists ----------------

test_that("test that set_cache creates a cache directory if none exists", {
  skip_on_cran()
  unlink(rappdirs::user_cache_dir("getCRUCLdata"), recursive = TRUE)
  cache <- TRUE
  .set_cache(cache)
  expect_true(file.exists(file.path(rappdirs::user_cache_dir("getCRUCLdata"))))
  # cleanup
  unlink(rappdirs::user_cache_dir("climcropr"), recursive = TRUE)
})

test_that("test that set_cache uses tempdir() if caching == FALSE", {
  cache <- FALSE
  cache_dir <- .set_cache(cache)
  expect_true(cache_dir == tempdir())
})
