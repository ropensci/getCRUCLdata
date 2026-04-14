.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("R.utils", quietly = TRUE)) {
    cli::cli_inform(
      c(
        "!" = "Package {.pkg R.utils} is not installed.",
        " " = "Reading `.gz` files with {.fn data.table::fread} may fail.",
        " " = "Install it with {.code install.packages('R.utils')}."
      )
    )
  }
}
