
#' @noRd
# calculate tmx ----------------------------------------------------------------
.calculate_tmx <- function(tmp_df, dtr_df) {
  tmx_df <- tmp_df[, c(3:14)] + (0.5 * dtr_df[, c(3:14)])
  tmx_df <- dplyr::bind_cols(tmp_df[, 1:2], tmx_df)
}

# calculate tmn ----------------------------------------------------------------
.calculate_tmn <- function(tmp_df, dtr_df) {
  tmn_df <- tmp_df[, c(3:14)] - (0.5 * dtr_df[, c(3:14)])
  tmn_df <- dplyr::bind_cols(tmp_df[, c(1:2)], tmn_df)
}
