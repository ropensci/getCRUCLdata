
context(".get_CRU")

# Test that get_CRU will retrieve only precipitation file when pre_cv TRUE -----
test_that("get_CRU will retrieve only precipitation file when pre_cv TRUE", {
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))

  skip_on_cran()
  skip_on_appveyor()
  .get_CRU(
    pre = FALSE,
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
    cache_dir = tempdir()
  )
  files <- list.files(tempdir(), pattern = ".dat.gz$")
  expect_identical(files, "grid_10min_pre.dat.gz")
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

# Test that get_CRU will retrieve diurnal tmp & tmp files when tmn TRUE --------

test_that("get_CRU will retrieve diurnal tmp range & tmp files when tmn TRUE", {
  skip_on_cran()
  skip_on_appveyor()
  .get_CRU(
    pre = FALSE,
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
    cache_dir = tempdir()
  )
  files <- list.files(tempdir(), pattern = ".dat.gz$")
  expect_identical(files, c("grid_10min_dtr.dat.gz", "grid_10min_tmp.dat.gz"))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

# Test that get_CRU will retrieve diurnal tmp & tmp files when tmx TRUE --------
test_that("get_CRU will retrieve diurnal tmp range & tmp files when tmx TRUE", {
  skip_on_cran()
  skip_on_appveyor()

  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))

  .get_CRU(
    pre = FALSE,
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
    cache_dir = tempdir()
  )
  files <- list.files(tempdir(), pattern = ".dat.gz$")
  expect_identical(files, c("grid_10min_dtr.dat.gz", "grid_10min_tmp.dat.gz"))
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})

# Test that get_CRU will set pre to TRUE if pre_cv is TRUE and pre is FALSE ----

test_that("get_CRU will set pre to TRUE if pre_cv is TRUE and pre is FALSE", {
  skip_on_cran()
  skip_on_appveyor()
  pre <- FALSE
  pre_cv <- TRUE

  expect_true(!isTRUE(pre))

  if (isTRUE(pre_cv)) {
    pre <- TRUE
  }
  expect_true(pre)
})

# Test that get_CRU will set tmp and dtr to TRUE if tmn or tmx is TRUE and -----
# either/both are false

test_that("get_CRU will set tmp and dtr to TRUE if tmn or tmx
          is TRUE and either/both are false", {
  skip_on_cran()

  tmp <- FALSE
  dtr <- FALSE
  tmn <- TRUE
  tmx <- TRUE
  expect_true(!isTRUE(tmp))
  expect_true(!isTRUE(dtr))

  if (isTRUE(tmn) | isTRUE(tmx)) {
    dtr <- tmp <- TRUE
  }

  expect_true(tmp)
  expect_true(dtr)
})
