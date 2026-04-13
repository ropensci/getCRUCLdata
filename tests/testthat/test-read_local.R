test_that(".read_local_files lists local files", {
  local_d <- withr::local_tempdir()
  fs::dir_create(local_d)

  fs::file_copy(
    fs::dir_ls(test_path("fixtures"), glob = "*.dat.gz"),
    local_d
  )

  vars <- c(
    pre = TRUE,
    pre_cv = FALSE,
    tmp = FALSE,
    dtr = FALSE,
    reh = FALSE,
    tmn = FALSE,
    tmx = FALSE,
    sunp = FALSE,
    frs = FALSE,
    wnd = FALSE,
    elv = FALSE
  )

  files <- .read_local_files(local_d, vars)

  pre_file <- test_path("fixtures", "grid_10min_pre.dat.gz")

  dtvar <- .read_local_files(file = pre_file, vars = vars)
  expect_s3_class(dtvar, "data.table")
  expect_true(all(c("lat", "lon", "month", "pre") %in% names(dtvar)))
})
