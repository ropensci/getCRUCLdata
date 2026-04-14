test_that("read_cru_rast builds a SpatRaster from fixtures", {
  local_d <- withr::local_tempdir()

  fs::dir_copy(
    test_path("fixtures"),
    local_d,
    overwrite = TRUE
  )

  r <- read_cru_rast(pre = TRUE, tmp = TRUE, x = local_d)

  expect_s4_class(r, "SpatRaster")
  expect_true(any(grepl("pre", names(r))))
  expect_true(any(grepl("tmp", names(r))))
})
