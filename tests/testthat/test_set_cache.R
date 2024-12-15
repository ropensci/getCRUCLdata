# test that .set_cache creates a cache directory if none exists ----------------

test_that("test that .set_cache creates a cache directory if none exists", {
  skip_if_offline()
  unlink(manage_cache$cache_path_get(), recursive = TRUE)
  cache <- TRUE
  .set_cache(cache)
  expect_true(file.exists(manage_cache$cache_path_get()))
  # cleanup
  unlink(manage_cache$cache_path_get(), recursive = TRUE)
})

# test that .set_cache does a cache directory if cache is FALSE ----------------

test_that("test that set_cache does not create a dir if cache == FALSE", {
  cache <- FALSE
  cache_dir <- .set_cache(cache)
  expect_true(cache_dir == tempdir())
})
