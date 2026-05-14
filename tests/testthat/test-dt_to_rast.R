test_that(".dt_to_rast() returns a terra SpatRaster", {
  # Create minimal test data
  dt <- data.table(
    lat = c(-60, -60, 0, 0, 60, 60),
    lon = c(-120, 120, -120, 120, -120, 120),
    month = rep(c("jan", "feb"), 3),
    value = c(10, 15, 20, 25, 5, 8)
  )

  result <- .dt_to_rast(dt, "tmp")

  expect_s4_class(result, "SpatRaster")
})

test_that(".dt_to_rast() creates 12 layers (one per month)", {
  dt <- data.table(
    lat = c(-60, 0, 60),
    lon = c(-120, 0, 120),
    month = c("jan", "feb", "mar"),
    value = c(10, 20, 30)
  )

  result <- .dt_to_rast(dt, "pre")

  expect_identical(terra::nlyr(result), 12)
})

test_that(".dt_to_rast() applies varname correctly to layer names", {
  dt <- data.table(
    lat = c(-60, 0),
    lon = c(-120, 120),
    month = c("jan", "feb"),
    value = c(10, 20)
  )

  result <- .dt_to_rast(dt, "tmp")

  expected_names <- paste0(
    "tmp_",
    c(
      "jan",
      "feb",
      "mar",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "oct",
      "nov",
      "dec"
    )
  )
  expect_equal(names(result), expected_names)
})

test_that(".dt_to_rast() uses correct CRU grid dimensions", {
  dt <- data.table(
    lat = c(-60, 0, 60),
    lon = c(-120, 0, 120),
    month = c("jan", "feb", "mar"),
    value = c(10, 20, 30)
  )

  result <- .dt_to_rast(dt, "tmp")

  expect_identical(terra::nrow(result), 930)
  expect_identical(terra::ncol(result), 2160)
  expect_identical(terra::ext(result)$xmin, -180, ignore_attr = TRUE)
  expect_identical(terra::ext(result)$xmax, 180, ignore_attr = TRUE)
  expect_identical(terra::ext(result)$ymin, -65, ignore_attr = TRUE)
  expect_identical(terra::ext(result)$ymax, 90, ignore_attr = TRUE)
})

test_that(".dt_to_rast() correctly places values at cell coordinates", {
  dt <- data.table(
    lat = c(0, 0),
    lon = c(0, 180),
    month = c("jan", "jan"),
    value = c(100, 200)
  )

  result <- .dt_to_rast(dt, "tmp")

  # Extract January layer
  jan_layer <- result[[1]]

  # Get cell indices for coordinates
  xy_0_0 <- cbind(0, 0)
  xy_180_0 <- cbind(180, 0)
  cell_0_0 <- terra::cellFromXY(jan_layer, xy_0_0)
  cell_180_0 <- terra::cellFromXY(jan_layer, xy_180_0)

  # Values should be in those cells
  expect_identical(terra::values(jan_layer)[cell_0_0], 100)
  expect_identical(terra::values(jan_layer)[cell_180_0], 200)
})

test_that(".dt_to_rast() handles all 12 months correctly", {
  # Create data with all months
  months <- c(
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  )
  dt <- data.table(
    lat = rep(0, 12),
    lon = rep(0, 12),
    month = months,
    value = seq_len(12)
  )

  result <- .dt_to_rast(dt, "tmp")

  # Verify all months have data
  for (i in seq_along(months)) {
    layer <- result[[i]]
    xy <- cbind(0, 0)
    cell <- terra::cellFromXY(layer, xy)
    expect_identical(terra::values(layer)[cell], as.numeric(i))
  }
})

test_that(".dt_to_rast() throws error when required columns are missing", {
  # Missing 'value' column
  dt_bad <- data.table(
    lat = c(-60, 0),
    lon = c(-120, 120),
    month = c("jan", "feb")
  )

  expect_error(.dt_to_rast(dt_bad, "tmp"))
})

test_that(".dt_to_rast() throws error when month column is missing", {
  dt_bad <- data.table(
    lat = c(-60, 0),
    lon = c(-120, 120),
    value = c(10, 20)
  )

  expect_error(.dt_to_rast(dt_bad, "tmp"))
})

test_that(".dt_to_rast() handles empty month subsets gracefully", {
  # Data with some months missing
  dt <- data.table(
    lat = c(0, 0),
    lon = c(0, 0),
    month = c("jan", "jan"), # Only January data
    value = c(10, 20)
  )

  result <- .dt_to_rast(dt, "tmp")

  # Should still return 12 layers
  expect_identical(terra::nlyr(result), 12)

  # Other months should be all NA
  feb_layer <- result[[2]]
  expect_true(all(is.na(terra::values(feb_layer))))
})

test_that(".dt_to_rast() works with different variable names", {
  dt <- data.table(
    lat = 0,
    lon = 0,
    month = "jan",
    value = 25
  )

  result_tmp <- .dt_to_rast(dt, "tmp")
  result_pre <- .dt_to_rast(dt, "pre")

  expect_true(grepl("^tmp_", names(result_tmp)[1]))
  expect_true(grepl("^pre_", names(result_pre)[1]))
})

test_that(".dt_to_rast() handles boundary coordinates", {
  dt <- data.table(
    lat = c(-65, 90, -65, 90),
    lon = c(-180, 180, 180, -180),
    month = rep("jan", 4),
    value = c(1, 2, 3, 4)
  )

  result <- .dt_to_rast(dt, "tmp")

  # Should not error and should produce valid raster
  expect_s4_class(result, "SpatRaster")
  expect_identical(terra::nlyr(result), 12)
})

test_that(".dt_to_rast() produces correct data type in output", {
  dt <- data.table(
    lat = 0,
    lon = 0,
    month = "jan",
    value = 42.5
  )

  result <- .dt_to_rast(dt, "tmp")

  # Check that numeric values are preserved
  jan_layer <- result[[1]]
  xy <- cbind(0, 0)
  cell <- terra::cellFromXY(jan_layer, xy)
  value <- terra::values(jan_layer)[cell]

  expect_type(value, "double")
  expect_equal(value, 42.5, tolerance = 1e-6)
})
