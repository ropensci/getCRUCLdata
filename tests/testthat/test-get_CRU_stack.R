context("get_CRU_stack")

test_that("get_CRU_stack fails if no parameters are TRUE", {
  expect_error(get_CRU_stack(),
               "You must select at least one element for download.")
})
