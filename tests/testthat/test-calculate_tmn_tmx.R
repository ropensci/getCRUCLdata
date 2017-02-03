
test_that("tmx is calculated correctly", {
tmx <- .calculate_tmx(10.0, 2.0)
expect_equal(tmx, 11)
})

test_that("tmn is calculated correctly", {
tmn <- .calculate_tmn(10.0, 2.0)
expect_equal(tmn, 9)
})
