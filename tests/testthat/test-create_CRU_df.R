context("create_CRU_df")

test_that("create_CRU_df fails if no parameters are TRUE", {
  expect_error(create_CRU_df(),
               "You must select at least one parameter for download.")
})
