# Test that create_df creates a tidy dataframe of pre, pre_cv and tmp ---------
test_that("Test that .create_df() creates a tidy df of pre, pre_cv and tmp", {
  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))

  # create files for testing, these data are the first 10 lines of pre and tmp
  # from the CRU CL v. 2.0 data
  pre_data <- rbind(
    c(
      -59.083,
      -26.583,
      105.4,
      121.3,
      141.3,
      146.7,
      159.6,
      162.4,
      141.5,
      151.1,
      141.6,
      124.9,
      110.0,
      93.9,
      35.2,
      38.7,
      38.4,
      27.5,
      49.5,
      40.8,
      50.8,
      33.5,
      42.2,
      56.6,
      35.5,
      43.4
    ),
    c(
      -58.417,
      -26.250,
      106.3,
      121.3,
      141.6,
      147.4,
      160.3,
      163.5,
      142.1,
      151.7,
      142.1,
      125.5,
      110.5,
      94.4,
      36.2,
      39.8,
      38.6,
      27.8,
      49.6,
      40.8,
      51.0,
      33.3,
      43.1,
      57.2,
      35.8,
      44.2
    ),
    c(
      -58.417,
      -26.417,
      106.6,
      121.9,
      142.1,
      147.5,
      160.3,
      163.4,
      142.0,
      151.7,
      142.1,
      125.5,
      110.5,
      94.5,
      36.2,
      39.7,
      38.6,
      27.8,
      49.7,
      40.9,
      51.0,
      33.3,
      43.1,
      57.2,
      35.9,
      44.2
    ),
    c(
      -55.917,
      -67.250,
      73.1,
      78.7,
      81.5,
      81.2,
      68.5,
      67.9,
      62.5,
      60.2,
      60.4,
      55.0,
      59.9,
      71.2,
      44.1,
      54.2,
      51.1,
      54.2,
      59.0,
      47.2,
      62.0,
      65.6,
      58.9,
      47.8,
      50.9,
      47.0
    ),
    c(
      -55.750,
      -67.250,
      68.7,
      73.8,
      76.6,
      76.9,
      65.3,
      64.4,
      58.6,
      56.9,
      56.7,
      51.5,
      56.4,
      67.1,
      44.7,
      55.0,
      51.9,
      54.4,
      59.6,
      48.2,
      63.0,
      66.5,
      60.3,
      48.8,
      51.7,
      47.6
    ),
    c(
      -55.750,
      -67.417,
      70.2,
      75.7,
      78.8,
      78.6,
      66.5,
      66.2,
      59.8,
      58.7,
      58.1,
      52.7,
      57.2,
      68.4,
      44.6,
      55.0,
      51.9,
      54.8,
      59.8,
      48.2,
      62.9,
      66.4,
      60.1,
      48.5,
      51.9,
      47.6
    ),
    c(
      -55.750,
      -67.583,
      71.7,
      77.4,
      80.6,
      81.0,
      68.6,
      67.8,
      61.8,
      60.3,
      59.8,
      54.2,
      58.5,
      70.0,
      44.6,
      55.1,
      51.9,
      55.1,
      59.9,
      48.3,
      62.6,
      66.4,
      59.9,
      48.2,
      52.0,
      47.6
    ),
    c(
      -55.583,
      -67.417,
      65.3,
      70.3,
      73.4,
      74.0,
      63.3,
      62.4,
      55.8,
      55.1,
      54.3,
      49.1,
      53.6,
      64.0,
      45.3,
      55.9,
      52.8,
      55.0,
      60.4,
      49.3,
      63.9,
      67.4,
      61.6,
      49.5,
      52.7,
      48.3
    ),
    c(
      -55.583,
      -67.583,
      66.5,
      71.6,
      75.0,
      76.0,
      65.1,
      63.8,
      57.5,
      56.6,
      55.8,
      50.4,
      54.5,
      65.2,
      45.3,
      56.0,
      53.0,
      55.3,
      60.6,
      49.5,
      63.7,
      67.4,
      61.4,
      49.2,
      52.9,
      48.4
    ),
    c(
      -55.583,
      -68.083,
      71.6,
      78.0,
      82.6,
      82.0,
      69.6,
      69.7,
      61.8,
      62.6,
      60.8,
      54.7,
      57.9,
      69.8,
      45.4,
      55.9,
      52.7,
      56.3,
      61.0,
      49.6,
      63.3,
      66.9,
      60.7,
      48.4,
      53.4,
      48.6
    )
  )

  tmp_data <- rbind(
    c(
      -59.083,
      -26.583,
      0.2,
      0.3,
      0.2,
      -1.9,
      -6.0,
      -9.8,
      -13.6,
      -9.2,
      -8.1,
      -5.3,
      -2.3,
      -1.1
    ),
    c(
      -58.417,
      -26.250,
      0.6,
      0.8,
      0.7,
      -1.4,
      -5.4,
      -9.1,
      -12.9,
      -8.6,
      -7.5,
      -4.7,
      -1.8,
      -0.7
    ),
    c(
      -58.417,
      -26.417,
      0.4,
      0.5,
      0.5,
      -1.6,
      -5.6,
      -9.3,
      -13.1,
      -8.8,
      -7.7,
      -4.9,
      -2.1,
      -0.9
    ),
    c(
      -55.917,
      -67.250,
      8.0,
      8.0,
      6.8,
      5.2,
      3.1,
      1.7,
      1.2,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.250,
      8.2,
      8.2,
      6.9,
      5.2,
      3.1,
      1.7,
      1.1,
      1.8,
      3.1,
      4.9,
      6.3,
      7.5
    ),
    c(
      -55.750,
      -67.417,
      8.0,
      8.0,
      6.7,
      5.1,
      3.0,
      1.6,
      1.0,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.583,
      8.4,
      8.4,
      7.1,
      5.5,
      3.4,
      2.0,
      1.5,
      2.2,
      3.5,
      5.2,
      6.5,
      7.7
    ),
    c(
      -55.583,
      -67.417,
      8.3,
      8.3,
      7.0,
      5.3,
      3.0,
      1.6,
      1.1,
      1.9,
      3.2,
      5.0,
      6.4,
      7.7
    ),
    c(
      -55.583,
      -67.583,
      8.6,
      8.6,
      7.3,
      5.6,
      3.4,
      1.9,
      1.4,
      2.2,
      3.6,
      5.4,
      6.7,
      8.0
    ),
    c(
      -55.583,
      -68.083,
      8.2,
      8.2,
      6.9,
      5.3,
      3.1,
      1.8,
      1.3,
      2.0,
      3.4,
      5.1,
      6.4,
      7.6
    )
  )
  gz1 <- gzfile(file.path(tempdir(), "grid_10min_pre.dat.gz"), "w")
  utils::write.table(
    pre_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  gz1 <- gzfile(file.path(tempdir(), "grid_10min_tmp.dat.gz"), "w")
  utils::write.table(
    tmp_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  pre_cv <- TRUE
  pre <- TRUE
  tmn <- FALSE
  tmx <- FALSE
  elv <- FALSE
  rd0 <- FALSE
  tmp <- TRUE
  dtr <- FALSE
  reh <- FALSE
  sunp <- FALSE
  frs <- FALSE
  wnd <- FALSE

  files <-
    list.files(tempdir(), pattern = ".dat.gz$", full.names = TRUE)

  CRU_df <-
    .create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)

  expect_true(is.data.frame(CRU_df))
  expect_named(CRU_df, c("lat", "lon", "month", "pre", "pre_cv", "tmp"))
  expect_identical(
    lapply(CRU_df, typeof),
    list(
      lat = "double",
      lon = "double",
      month = "integer",
      pre = "double",
      pre_cv = "double",
      tmp = "double"
    )
  )
})

test_that("Test that .create_df() creates a tidy dataframe of pre, tmp, elv", {
  # These data are taken from the raw elevation data file
  elv_data <- cbind(
    c(
      -59.083,
      -58.417,
      -58.417,
      -55.917,
      -55.750,
      -55.750,
      -55.750,
      -55.583,
      -55.583,
      -55.583
    ),
    c(
      -26.583,
      -26.417,
      -26.250,
      -67.250,
      -67.583,
      -67.417,
      -67.250,
      -68.250,
      -68.083,
      -67.583
    ),
    c(
      0.193,
      0.239,
      0.194,
      0.064,
      0.032,
      0.103,
      0.063,
      0.062,
      0.123,
      0.019
    )
  )

  gz1 <- gzfile(file.path(tempdir(), "grid_10min_elv.dat.gz"), "w")
  utils::write.table(
    elv_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  pre_cv <- FALSE
  pre <- TRUE
  tmn <- FALSE
  tmx <- FALSE
  elv <- TRUE
  rd0 <- FALSE
  tmp <- FALSE
  dtr <- FALSE
  reh <- FALSE
  sunp <- FALSE
  frs <- FALSE
  wnd <- FALSE

  files <-
    list.files(tempdir(), pattern = ".dat.gz$", full.names = TRUE)

  CRU_df <-
    .create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)

  expect_true(is.data.frame(CRU_df))
  expect_named(CRU_df, c("lat", "lon", "month", "pre", "tmp", "elv"))

  expect_identical(
    lapply(CRU_df, typeof),
    list(
      lat = "double",
      lon = "double",
      month = "integer",
      pre = "double",
      tmp = "double",
      elv = "double"
    )
  )
})

unlink(list.files(
  path = tempdir(),
  pattern = ".dat.gz$",
  full.names = TRUE
))

# Test that create_df creates tmn if requested ---------------------------------

test_that("Test that .create_df() creates a tidy dataframe of pre, tmp, elv", {
  dtr_data <- rbind(
    c(
      -59.083,
      -26.583,
      0.2,
      0.3,
      0.2,
      -1.9,
      -6.0,
      -9.8,
      -13.6,
      -9.2,
      -8.1,
      -5.3,
      -2.3,
      -1.1
    ),
    c(
      -58.417,
      -26.250,
      0.6,
      0.8,
      0.7,
      -1.4,
      -5.4,
      -9.1,
      -12.9,
      -8.6,
      -7.5,
      -4.7,
      -1.8,
      -0.7
    ),
    c(
      -58.417,
      -26.417,
      0.4,
      0.5,
      0.5,
      -1.6,
      -5.6,
      -9.3,
      -13.1,
      -8.8,
      -7.7,
      -4.9,
      -2.1,
      -0.9
    ),
    c(
      -55.917,
      -67.250,
      8.0,
      8.0,
      6.8,
      5.2,
      3.1,
      1.7,
      1.2,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.250,
      8.2,
      8.2,
      6.9,
      5.2,
      3.1,
      1.7,
      1.1,
      1.8,
      3.1,
      4.9,
      6.3,
      7.5
    ),
    c(
      -55.750,
      -67.417,
      8.0,
      8.0,
      6.7,
      5.1,
      3.0,
      1.6,
      1.0,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.583,
      8.4,
      8.4,
      7.1,
      5.5,
      3.4,
      2.0,
      1.5,
      2.2,
      3.5,
      5.2,
      6.5,
      7.7
    ),
    c(
      -55.583,
      -67.417,
      8.3,
      8.3,
      7.0,
      5.3,
      3.0,
      1.6,
      1.1,
      1.9,
      3.2,
      5.0,
      6.4,
      7.7
    ),
    c(
      -55.583,
      -67.583,
      8.6,
      8.6,
      7.3,
      5.6,
      3.4,
      1.9,
      1.4,
      2.2,
      3.6,
      5.4,
      6.7,
      8.0
    ),
    c(
      -55.583,
      -68.083,
      8.2,
      8.2,
      6.9,
      5.3,
      3.1,
      1.8,
      1.3,
      2.0,
      3.4,
      5.1,
      6.4,
      7.6
    )
  )

  tmp_data <- rbind(
    c(
      -59.083,
      -26.583,
      0.2,
      0.3,
      0.2,
      -1.9,
      -6.0,
      -9.8,
      -13.6,
      -9.2,
      -8.1,
      -5.3,
      -2.3,
      -1.1
    ),
    c(
      -58.417,
      -26.250,
      0.6,
      0.8,
      0.7,
      -1.4,
      -5.4,
      -9.1,
      -12.9,
      -8.6,
      -7.5,
      -4.7,
      -1.8,
      -0.7
    ),
    c(
      -58.417,
      -26.417,
      0.4,
      0.5,
      0.5,
      -1.6,
      -5.6,
      -9.3,
      -13.1,
      -8.8,
      -7.7,
      -4.9,
      -2.1,
      -0.9
    ),
    c(
      -55.917,
      -67.250,
      8.0,
      8.0,
      6.8,
      5.2,
      3.1,
      1.7,
      1.2,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.250,
      8.2,
      8.2,
      6.9,
      5.2,
      3.1,
      1.7,
      1.1,
      1.8,
      3.1,
      4.9,
      6.3,
      7.5
    ),
    c(
      -55.750,
      -67.417,
      8.0,
      8.0,
      6.7,
      5.1,
      3.0,
      1.6,
      1.0,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.583,
      8.4,
      8.4,
      7.1,
      5.5,
      3.4,
      2.0,
      1.5,
      2.2,
      3.5,
      5.2,
      6.5,
      7.7
    ),
    c(
      -55.583,
      -67.417,
      8.3,
      8.3,
      7.0,
      5.3,
      3.0,
      1.6,
      1.1,
      1.9,
      3.2,
      5.0,
      6.4,
      7.7
    ),
    c(
      -55.583,
      -67.583,
      8.6,
      8.6,
      7.3,
      5.6,
      3.4,
      1.9,
      1.4,
      2.2,
      3.6,
      5.4,
      6.7,
      8.0
    ),
    c(
      -55.583,
      -68.083,
      8.2,
      8.2,
      6.9,
      5.3,
      3.1,
      1.8,
      1.3,
      2.0,
      3.4,
      5.1,
      6.4,
      7.6
    )
  )
  gz1 <- gzfile(file.path(tempdir(), "grid_10min_dtr.dat.gz"), "w")
  utils::write.table(
    dtr_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  gz1 <- gzfile(file.path(tempdir(), "grid_10min_tmp.dat.gz"), "w")
  utils::write.table(
    tmp_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  pre_cv <- FALSE
  pre <- FALSE
  tmn <- TRUE
  tmx <- FALSE
  elv <- FALSE
  rd0 <- FALSE
  tmp <- FALSE
  dtr <- FALSE
  reh <- FALSE
  sunp <- FALSE
  frs <- FALSE
  wnd <- FALSE

  files <-
    list.files(tempdir(), pattern = ".dat.gz$", full.names = TRUE)

  CRU_df <-
    .create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)

  expect_named(CRU_df, c("lat", "lon", "month", "tmn"))
  expect_equal(CRU_df$tmn[1], 0.1)
  expect_equal(
    lapply(CRU_df, typeof),
    list(
      lat = "double",
      lon = "double",
      month = "integer",
      tmn = "double"
    )
  )
})


unlink(list.files(
  path = tempdir(),
  pattern = ".dat.gz$",
  full.names = TRUE
))

# Test that create_df creates tmx if requested ---------------------------------
test_that("Test that .create_df() creates tmx if requested", {
  dtr_data <- rbind(
    c(
      -59.083,
      -26.583,
      0.2,
      0.3,
      0.2,
      -1.9,
      -6.0,
      -9.8,
      -13.6,
      -9.2,
      -8.1,
      -5.3,
      -2.3,
      -1.1
    ),
    c(
      -58.417,
      -26.250,
      0.6,
      0.8,
      0.7,
      -1.4,
      -5.4,
      -9.1,
      -12.9,
      -8.6,
      -7.5,
      -4.7,
      -1.8,
      -0.7
    ),
    c(
      -58.417,
      -26.417,
      0.4,
      0.5,
      0.5,
      -1.6,
      -5.6,
      -9.3,
      -13.1,
      -8.8,
      -7.7,
      -4.9,
      -2.1,
      -0.9
    ),
    c(
      -55.917,
      -67.250,
      8.0,
      8.0,
      6.8,
      5.2,
      3.1,
      1.7,
      1.2,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.250,
      8.2,
      8.2,
      6.9,
      5.2,
      3.1,
      1.7,
      1.1,
      1.8,
      3.1,
      4.9,
      6.3,
      7.5
    ),
    c(
      -55.750,
      -67.417,
      8.0,
      8.0,
      6.7,
      5.1,
      3.0,
      1.6,
      1.0,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.583,
      8.4,
      8.4,
      7.1,
      5.5,
      3.4,
      2.0,
      1.5,
      2.2,
      3.5,
      5.2,
      6.5,
      7.7
    ),
    c(
      -55.583,
      -67.417,
      8.3,
      8.3,
      7.0,
      5.3,
      3.0,
      1.6,
      1.1,
      1.9,
      3.2,
      5.0,
      6.4,
      7.7
    ),
    c(
      -55.583,
      -67.583,
      8.6,
      8.6,
      7.3,
      5.6,
      3.4,
      1.9,
      1.4,
      2.2,
      3.6,
      5.4,
      6.7,
      8.0
    ),
    c(
      -55.583,
      -68.083,
      8.2,
      8.2,
      6.9,
      5.3,
      3.1,
      1.8,
      1.3,
      2.0,
      3.4,
      5.1,
      6.4,
      7.6
    )
  )

  tmp_data <- rbind(
    c(
      -59.083,
      -26.583,
      0.2,
      0.3,
      0.2,
      -1.9,
      -6.0,
      -9.8,
      -13.6,
      -9.2,
      -8.1,
      -5.3,
      -2.3,
      -1.1
    ),
    c(
      -58.417,
      -26.250,
      0.6,
      0.8,
      0.7,
      -1.4,
      -5.4,
      -9.1,
      -12.9,
      -8.6,
      -7.5,
      -4.7,
      -1.8,
      -0.7
    ),
    c(
      -58.417,
      -26.417,
      0.4,
      0.5,
      0.5,
      -1.6,
      -5.6,
      -9.3,
      -13.1,
      -8.8,
      -7.7,
      -4.9,
      -2.1,
      -0.9
    ),
    c(
      -55.917,
      -67.250,
      8.0,
      8.0,
      6.8,
      5.2,
      3.1,
      1.7,
      1.2,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.250,
      8.2,
      8.2,
      6.9,
      5.2,
      3.1,
      1.7,
      1.1,
      1.8,
      3.1,
      4.9,
      6.3,
      7.5
    ),
    c(
      -55.750,
      -67.417,
      8.0,
      8.0,
      6.7,
      5.1,
      3.0,
      1.6,
      1.0,
      1.8,
      3.1,
      4.8,
      6.1,
      7.3
    ),
    c(
      -55.750,
      -67.583,
      8.4,
      8.4,
      7.1,
      5.5,
      3.4,
      2.0,
      1.5,
      2.2,
      3.5,
      5.2,
      6.5,
      7.7
    ),
    c(
      -55.583,
      -67.417,
      8.3,
      8.3,
      7.0,
      5.3,
      3.0,
      1.6,
      1.1,
      1.9,
      3.2,
      5.0,
      6.4,
      7.7
    ),
    c(
      -55.583,
      -67.583,
      8.6,
      8.6,
      7.3,
      5.6,
      3.4,
      1.9,
      1.4,
      2.2,
      3.6,
      5.4,
      6.7,
      8.0
    ),
    c(
      -55.583,
      -68.083,
      8.2,
      8.2,
      6.9,
      5.3,
      3.1,
      1.8,
      1.3,
      2.0,
      3.4,
      5.1,
      6.4,
      7.6
    )
  )
  gz1 <- gzfile(file.path(tempdir(), "grid_10min_dtr.dat.gz"), "w")
  utils::write.table(
    dtr_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  gz1 <- gzfile(file.path(tempdir(), "grid_10min_tmp.dat.gz"), "w")
  utils::write.table(
    tmp_data,
    file = gz1,
    col.names = FALSE,
    row.names = FALSE
  )
  close(gz1)

  pre_cv <- FALSE
  pre <- FALSE
  tmn <- FALSE
  tmx <- TRUE
  elv <- FALSE
  rd0 <- FALSE
  tmp <- FALSE
  dtr <- FALSE
  reh <- FALSE
  sunp <- FALSE
  frs <- FALSE
  wnd <- FALSE

  files <-
    list.files(tempdir(), pattern = ".dat.gz$", full.names = TRUE)

  CRU_df <-
    .create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files)

  expect_named(CRU_df, c("lat", "lon", "month", "tmx"))
  expect_equal(CRU_df$tmx[1], 0.3)

  expect_identical(
    lapply(CRU_df, typeof),
    list(
      lat = "double",
      lon = "double",
      month = "integer",
      tmx = "double"
    )
  )

  unlink(list.files(
    path = tempdir(),
    pattern = ".dat.gz$",
    full.names = TRUE
  ))
})
