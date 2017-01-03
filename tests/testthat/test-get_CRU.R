context(".get_CRU")

unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))

test_that("get_CRU will retrieve only precipitation file when pre TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()

    # be sure to start with a clean directory
  cache_dir <- tempdir()
  unlink(list.files(
    path = cache_dir,
    pattern = ".dat.gz$",
    full.names = TRUE
  ))

  .get_CRU(pre = TRUE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_pre.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})


test_that("get_CRU will retrieve only precipitation file when pre_cv TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = TRUE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_pre.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only tmp file when tmp TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = TRUE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_tmp.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only diurnal tmp range file when dtr TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = TRUE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_dtr.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})


test_that("get_CRU will retrieve diurnal tmp range & tmp files when tmn TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = TRUE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, c("grid_10min_dtr.dat.gz", "grid_10min_tmp.dat.gz"))
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve diurnal tmp range & tmp files when tmx TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = TRUE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, c("grid_10min_dtr.dat.gz", "grid_10min_tmp.dat.gz"))
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})


test_that("get_CRU will retrieve only RH file when reh TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = TRUE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_reh.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only sunp file when sunp TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = TRUE,
           frs = FALSE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_sunp.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only frs file when frs TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = TRUE,
           wnd = FALSE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_frs.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only wnd file when wnd TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = TRUE,
           elv = FALSE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_wnd.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})

test_that("get_CRU will retrieve only elv file when elv TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  cache_dir <- tempdir()
  .get_CRU(pre = FALSE,
           pre_cv = FALSE,
           rd0 = FALSE,
           tmp = FALSE,
           dtr = FALSE,
           reh = FALSE,
           tmn = FALSE,
           tmx = FALSE,
           sunp = FALSE,
           frs = FALSE,
           wnd = FALSE,
           elv = TRUE,
           cache_dir)
  files <- list.files(cache_dir, pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_elv.dat.gz")
  unlink(list.files(path = cache_dir, pattern = ".dat.gz$", full.names = TRUE))
})
