context(".validate_dsn")

test_that(".validate_dsn stops if the dsn is not provided", {
  dsn <- NULL
  expect_error(.validate_dsn(dsn),
         "You must define the dsn where you have stored the local files
         for import.")
})
