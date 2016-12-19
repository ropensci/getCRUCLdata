context("create_CRU_stack")

test_that("create_CRU_stack fails if no parameters are TRUE", {
  expect_error(create_CRU_stack(),
               "You must select at least one parameter for download.")
})

