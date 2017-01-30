#' getCRUdata: Download and Create a Data Frame or Raster Stack Object of CRU CL2.0 Climatology Variables
#'
#' The getCRUdata package provides functions that automate downloading and
#' importing CRU CL2.0 climatology data into R, facilitates the calculation of
#' minimum temperature and maximum temperature, converts elevation from
#' kilometres to metres and formats the data into a tidy data frame or a list
#' of raster stack objects for use in an R session.  CRU CL2.0 data are a
#' gridded climatology of 1961-1990 monthly means released in 2002 and cover all
#' land areas (excluding Antarctica) at 10 arc-second resolution.  For more
#' information see the description of the data provided by the University of
#' East Anglia Climate Research Unit (CRU),
#' \url{https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt}.
#'
#' @docType package
#'
#' @name getCRUdata
#'
#' @seealso \code{\link{create_CRU_df}}
#'
#' @seealso \code{\link{create_CRU_stack}}
#'
#' @references
#' \url{https://crudata.uea.ac.uk/cru/data/hrg/tmc/}
#'
#' New, M., Lister, D., Hulme, M. and Makin, I., 2002: A high-resolution data
#' set of surface climate over global land areas. \emph{Climate Research}
#' \bold{21}:1-25
#' (\href{https://crudata.uea.ac.uk/cru/data/hrg/tmc/}{abstract},
#' \href{http://www.int-res.com/articles/cr2002/21/c021p001.pdf}{paper})
#'
#'@author Adam H Sparks
NULL
