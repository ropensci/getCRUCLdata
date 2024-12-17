#' Download and create a data.table of CRU CL v. 2.0 climatology elements
#'
#' This function automates downloading and importing \acronym{CRU}
#' \acronym{CL} v. 2.0 climatology data and creates a \CRANpkg{data.table} of
#'  the data.  If requested, minimum and maximum temperature may also be
#'  automatically calculated as described in the data
#'  [readme.txt](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt) file.
#'  Data may be cached for later use by this function, saving time downloading
#'  files in future use of this function.
#'
#' @section Nomenclature and Units:
#' \describe{
#' \item{pre}{precipitation (millimetres/month)}
#'   \describe{
#'    \item{cv}{cv of precipitation (percent)}
#'   }
#' \item{rd0}{wet-days (number days with >0.1 millimetres rain per month)}
#' \item{tmp}{mean temperature (degrees Celsius)}
#' \item{dtr}{mean diurnal temperature range (degrees Celsius)}
#' \item{reh}{relative humidity (percent)}
#' \item{sunp}{sunshine (percent of maximum possible (percent of day length))}
#' \item{frs}{ground-frost (number of days with ground-frost per month)}
#' \item{wnd}{10 metre windspeed (metres/second)}
#' \item{elv}{elevation (automatically converted to metres)}
#' }
#' For more information see the description of the data provided by
#' \acronym{CRU}, <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>
#'
#' @param pre Fetches precipitation (millimetres/month) from server and
#' returns it in the data frame, `TRUE`.  Defaults to `FALSE`.
#' @param pre_cv  Fetch cv of precipitation (percent) from server and
#' returns it in the data frame, `TRUE`.  Defaults to `FALSE`.  NOTE Setting
#' this to `TRUE` will always results in **pre** being set to `TRUE` and
#' returned as well.
#' @param rd0 Fetches wet-days (number days with >0.1 millimetres rain
#' per month) and returns it in the data frame?  Defaults to `FALSE`.
#' @param dtr Fetches mean diurnal temperature range (degrees Celsius)
#' and returns it in the data frame?  Defaults to `FALSE`.
#' @param tmp Fetches temperature (degrees Celsius) and returns it in the
#' data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmn Calculates minimum temperature values (degrees Celsius)
#' and returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param tmx Calculates maximum temperature (degrees Celsius) and
#' returns it in the data frame, `TRUE`. Defaults to `FALSE`.
#' @param reh Fetches relative humidity and returns it in the data frame,
#' `TRUE`. Defaults to FALSE.
#' @param sunp Fetch sunshine, percent of maximum possible (percent of
#' day length) and return it in the data frame?  Defaults to `FALSE`.
#' @param frs Fetches ground-frost records (number of days with ground-
#' frost per month) and return it in the data frame?  Defaults to `FALSE`.
#' @param wnd Fetches 10m wind speed (metres/second) and returns it in the
#' data frame, `TRUE`. Defaults to `FALSE`.
#' @param elv Fetches elevation (converted to metres) and returns it in
#' the data frame, `TRUE`.  Defaults to `FALSE`.
#' @param cache Stores CRU CL v. 2.0 data files locally for later use.
#' If `FALSE`, the downloaded files are removed when the \R session is closed.
#' To take advantage of cached files in future sessions, use `cache = TRUE`
#' even after the initial download and caching.  Defaults to `FALSE`.
#'
#' @examplesIf interactive()
#' # Download data and create a data frame of precipitation and temperature
#' # without caching the data files
#' CRU_pre_tmp <- get_CRU_df(pre = TRUE, tmp = TRUE)
#'
#' head(CRU_pre_tmp)
#' CRU_pre_tmp
#'
#' @seealso
#' [create_CRU_stack], [manage_cache].
#'
#' @return A \CRANpkg{data.table} object of \acronym{CRU} \acronym{CL} v. 2.0
#'  climatology elements.
#'
#' @author Adam H. Sparks, \email{adamhsparks@@gmail.com}
#' @source
#' \describe{
#'  \item{pre}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_pre.dat.gz>}
#'  \item{rd0}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_rd0.dat.gz>}
#'  \item{tmp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_tmp.dat.gz>}
#'  \item{dtr}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_dtr.dat.gz>}
#'  \item{reh}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_reh.dat.gz>}
#'  \item{sunp}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_sunp.dat.gz>}
#'  \item{frs}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_frs.dat.gz>}
#'  \item{wnd}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_wnd.dat.gz>, areas originally including Antarctica are removed.}
#'  \item{elv}{<https://crudata.uea.ac.uk/cru/data/hrg/tmc/grid_10min_elv.dat.gz>, values are converted from kilometres to metres.}
#' }
#' This package crops all spatial outputs to an extent of ymin = -60, ymax = 85,
#' xmin = -180, xmax = 180.
#'
#' @references New, Mark, et al. "A high-resolution data set of surface climate
#'  over global land areas." Climate research 21.1 (2002): 1-25.
#'  <https://crudata.uea.ac.uk/cru/data/hrg/tmc/new_et_al_10minute_climate_CR.pdf>
#'
#' @export

get_CRU_df <- function(pre = FALSE,
                       pre_cv = FALSE,
                       rd0 = FALSE,
                       tmp = FALSE,
                       dtr = FALSE,
                       reh = FALSE,
                       tmn = FALSE,
                       tmx = FALSE,
                       sunp = FALSE,
                       frs = FALSE,
                       wnd = FALSE,
                       elv = FALSE,
                       cache = FALSE) {
  .check_vars_FALSE(
    pre,
    pre_cv,
    rd0,
    tmp,
    dtr,
    reh,
    tmn,
    tmx,
    sunp,
    frs,
    wnd,
    elv
  )

  cache_dir <- .set_cache(cache)

  files <- .get_CRU(
    pre,
    pre_cv,
    rd0,
    tmp,
    dtr,
    reh,
    tmn,
    tmx,
    sunp,
    frs,
    wnd,
    elv,
    cache_dir
  )

  return(.create_df(tmn, tmx, tmp, dtr, pre, pre_cv, elv, files))
}

#' @export
#' @rdname get_CRU_df
get_cru_df <- get_CRU_df
