
context("get_CRU_df")

test_that("get_CRU_df fails if no parameters are TRUE", {
  expect_error(get_CRU_df(),
               "You must select at least one element for download.")
})
