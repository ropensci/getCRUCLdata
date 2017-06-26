
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

# test that .set_cache does a cache directory if cache is FALSE ----------------

test_that("test that set_cache does not create a dir if cache == FALSE", {
  cache <- FALSE
  cache_dir <- .set_cache(cache)
  expect_true(cache_dir == tempdir())
})
