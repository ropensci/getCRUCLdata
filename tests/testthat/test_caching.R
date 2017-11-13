
context("Cache directory handling")

# test that .set_cache creates a cache directory if none exists ----------------
test_that("test that set_cache creates a cache directory if none exists", {
  skip_on_cran()
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

test_that("cache directory is created if necessary", {
  # if cache directory exists during testing, remove it
  unlink(manage_cache$cache_path_get(),
         recursive = TRUE)
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  expect_true(dir.exists(manage_cache$cache_path_get()))
})

test_that("caching utils list files in cache and delete when asked", {
  skip_on_cran()
  unlink(
    list.files(manage_cache$cache_path_get()),
    recursive = TRUE
  )
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  f <-
    raster::raster(system.file("external/test.grd", package = "raster"))
  cache_dir <- manage_cache$cache_path_get()
  raster::writeRaster(f, file.path(cache_dir, "file1.asc"), format = "ascii")
  raster::writeRaster(f, file.path(cache_dir, "file2.asc"), format = "ascii")

  # test getCRUCLdata cache list
  k <- list.files(manage_cache$cache_path_get())
  expect_equal(basename(manage_cache$list()), k)

  # test delete one file
  expect_error(manage_cache$delete("file1.tif"))

  manage_cache$delete("file1.asc")
  l <- list.files(manage_cache$cache_path_get())
  expect_equal(basename(manage_cache$list()), l)

  # test delete all
  manage_cache$delete_all()
  expect_equal(list.files(
    manage_cache$list()
  ),
  character(0))
})
