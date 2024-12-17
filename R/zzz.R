manage_cache <- NULL # nocov start

.onLoad <-
  function(libname = find.package("getCRUCLdata"),
           pkgname = "getCRUCLdata") {
    # CRAN Note avoidance
    if (getRversion() >= "2.15.1") {
      utils::globalVariables(c("."))

      x <- hoardr::hoard()
      x$cache_path_set(
        path = "getCRUCLdata",
        prefix = "org.R-project.R/R",
        type = "user_cache_dir"
      )
      manage_cache <<- x
    }
  }

# nocov end
