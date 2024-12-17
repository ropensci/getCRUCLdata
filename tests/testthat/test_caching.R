# test that .set_cache creates a cache directory if none exists ----------------
test_that("test that set_cache creates a cache directory if none exists", {
  skip_if_offline()
  withr::local_envvar(R_USER_CACHE_DIR = tempdir())
  temp_cache <- file.path(tempdir(), "R/getCRUCLdata/")
  manage_cache <- hoardr::hoard()
  manage_cache$cache_path_set(
    path = "getCRUCLdata",
    prefix = "org.R-project.R/R",
    type = "user_cache_dir"
  )
  cache <- TRUE
  .set_cache(cache)
  expect_true(file.exists(manage_cache$cache_path_get()))
  withr::deferred_run()
})

# test that .set_cache does a cache directory if cache is FALSE ----------------

test_that("test that set_cache does not create a dir if cache == FALSE", {
  cache_dir <- .set_cache(cache = FALSE)
  expect_true(cache_dir == tempdir())
})

test_that("cache directory is created if necessary", {
  # if cache directory exists during testing, remove it
  unlink(manage_cache$cache_path_get(),
    recursive = TRUE
  )
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  expect_true(dir.exists(manage_cache$cache_path_get()))
})

test_that("caching utils list files in cache and delete when asked", {
  skip_if_offline()
  unlink(list.files(manage_cache$cache_path_get()),
    recursive = TRUE
  )
  withr::local_envvar(R_USER_CACHE_DIR = tempdir())
  temp_cache <- file.path(tempdir(), "R/getCRUCLdata/")
  manage_cache <- hoardr::hoard()
  manage_cache$cache_path_set(
    path = "getCRUCLdata",
    prefix = "org.R-project.R/R",
    type = "user_cache_dir"
  )
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  f <-
    terra::rast(system.file("ex/test.grd", package = "terra"))
  cache_dir <- manage_cache$cache_path_get()
  terra::writeRaster(f, file.path(cache_dir, "file1.asc"))
  terra::writeRaster(f, file.path(cache_dir, "file2.asc"))

  # test getCRUCLdata cache list
  k <- list.files(manage_cache$cache_path_get())
  expect_identical(basename(manage_cache$list()), k)

  # test delete one file
  expect_error(manage_cache$delete("file1.tif"))

  manage_cache$delete("file1.asc")
  l <- list.files(manage_cache$cache_path_get())
  expect_identical(basename(manage_cache$list()), l)

  # test delete all
  manage_cache$delete_all()
  expect_identical(list.files(manage_cache$list()), character(0))
  withr::deferred_run()
})
