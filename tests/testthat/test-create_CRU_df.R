
context("create_CRU_df")

test_that("create_CRU_df fails if no parameters are TRUE", {
  expect_error(create_CRU_df(dsn = "~/"),
               "You must select at least one element for import.")
})

test_that("create_CRU_df fails if no dsn is specified", {
  expect_error(create_CRU_df(pre = TRUE),
               "File directory does not exist: .")
})
