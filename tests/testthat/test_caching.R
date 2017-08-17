
context("Cache directory handling")

# test that .set_cache creates a cache directory if none exists ----------------
test_that("test that set_cache creates a cache directory if none exists", {
  skip_on_cran()
  unlink(rappdirs::user_cache_dir("getCRUCLdata"), recursive = TRUE)
  cache <- TRUE
  .set_cache(cache)
  expect_true(file.exists(file.path(rappdirs::user_cache_dir("getCRUCLdata"))))
  # cleanup
  unlink(rappdirs::user_cache_dir("getCRUCLdata"), recursive = TRUE)
})

# test that .set_cache does a cache directory if cache is FALSE ----------------

test_that("test that set_cache does not create a dir if cache == FALSE", {
  cache <- FALSE
  cache_dir <- .set_cache(cache)
  expect_true(cache_dir == tempdir())
})

test_that("cache directory is created if necessary", {
  # if cache directory exists during testing, remove it
  unlink(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                  appauthor = "getCRUCLdata"),
         recursive = TRUE)
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  expect_true(dir.exists(
    rappdirs::user_cache_dir(appname = "getCRUCLdata",
                             appauthor = "getCRUCLdata")
  ))
})

test_that("caching utils list files in cache and delete when asked", {
  skip_on_cran()
  unlink(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                  appauthor = "getCRUCLdata"),
         recursive = TRUE)
  cache <- TRUE
  cache_dir <- .set_cache(cache)
  f <- raster::raster(system.file("external/test.grd", package = "raster"))
  cache_dir <- rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                        appauthor = "getCRUCLdata")
  raster::writeRaster(f, file.path(cache_dir, "file1.asc"), format = "ascii")
  raster::writeRaster(f, file.path(cache_dir, "file2.asc"), format = "ascii")

  # test getCRUCLdata cache list
  k <- list.files(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                           appauthor = "getCRUCLdata"))
  expect_equal(basename(CRU_cache_list()), k)

  # test delete one file
  expect_error(CRU_cache_delete("file1.tif"))

  CRU_cache_delete("file1.asc")
  l <- list.files(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                           appauthor = "getCRUCLdata"))
  expect_equal(basename(CRU_cache_list()), l)

  # test delete all
  CRU_cache_delete_all()
  expect_equal(list.files(rappdirs::user_cache_dir(appname = "getCRUCLdata",
                                                   appauthor = "getCRUCLdata")
                          ),
                          character(0))
}
)
