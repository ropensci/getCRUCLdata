
#' @noRd
# data frame calculate tmx -----------------------------------------------------
.calculate_tmx <- function(tmp_val, dtr_val) {
  tmp_val + (0.5 * dtr_val)
}

# data frame calculate tmn -----------------------------------------------------
.calculate_tmn <- function(tmp_val, dtr_val) {
  tmp_val - (0.5 * dtr_val)
}
