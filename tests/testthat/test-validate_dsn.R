# Test that .validate_dsn stops if the dsn is not provided ---------------------

test_that(".validate_dsn stops if the dsn is not provided", {
  skip_if_offline()
  dsn <- NULL
  expect_error(.validate_dsn(dsn))
})
