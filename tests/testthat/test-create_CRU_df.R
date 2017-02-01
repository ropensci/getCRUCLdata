context("create_CRU_df")

unlink(list.files(path = tempdir(), pattern = ".dat.gz$", full.names = TRUE))

test_that("create_CRU_df fails if no parameters are TRUE", {
  expect_error(create_CRU_df(),
               "You must select at least one parameter for download.")
})


