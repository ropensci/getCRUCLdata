.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("R.utils", quietly = TRUE)) {
    cli::cli_inform(
      c(
        x = "Package {.pkg R.utils} is not installed.",
        i = "Reading `.gz` files with {.fn data.table::fread} may fail.",
        i = "Install it with {.code install.packages('R.utils')}."
      )
    )
  }
}
