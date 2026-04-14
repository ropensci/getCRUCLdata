test_that("read_cru_dt uses mocked download instead of network", {
  with_mocked_bindings(
    .retry_download = mock_retry_download,
    .package = "getCRUCLdata",
    {
      df <- read_cru_dt(pre = TRUE, tmp = TRUE, x = NULL)
      expect_s3_class(df, "data.table")
      expect_true(all(c("pre", "tmp") %in% names(df)))
    }
  )
})
