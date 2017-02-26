context("create_CRU_stack")

test_that("create_CRU_stack fails if no dsn is specified", {
  expect_error(create_CRU_stack(pre = TRUE),
               "File directory does not exist: .")
})

test_that("create_CRU_stack fails if no parameters are TRUE", {
  expect_error(create_CRU_stack(dsn = "~/"),
               "You must select at least one element for importing")
})
