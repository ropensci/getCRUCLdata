
.onLoad <-
  function(libname = find.package("getCRUCLdata"),
           pkgname = "getCRUCLdata") {
    # CRAN Note avoidance
    if (getRversion() >= "2.15.1") {
      utils::globalVariables(c("."))
    }
  }

.onAttach <- function(libname, pkgname) {
  msg <- paste0("\nCRU CL 2.0 data are provided by the Climate Research Unit\n",
                "at the University of East Anglia. This data-set is owned by\n",
                "its author, Mark New. It is being distributed, where\n",
                "necessary by Tim Mitchell.\n",
                "\n",
                "Users should refer to the published literature for details\n",
                "of it.\n",
                "\n",
                "The data set may be freely used for non-commerical\n",
                "scientific and educational purposes, provided it is\n",
                "described as CRU CL 2.0 and attributed to:\n",
                "\n",
                "New, M., Lister, D., Hulme, M. and Makin, I., 2002: A\n",
                "high-resolution data set of surface climate over global\n",
                "land areas. Climate Research 21:1-25\n")
  packageStartupMessage(msg)
}
