# getCRUCLdata: Use and Explore CRU CL v. 2.0 Climatology Elements in R

<!-- badges: start -->

[![R-CMD-check](https://github.com/ropensci/getCRUCLdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/getCRUCLdata/actions/workflows/R-CMD-check.yaml) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.466812.svg)](https://doi.org/10.5281/zenodo.466812) [![JOSS status](http://joss.theoj.org/papers/10.21105/joss.00230/status.svg)](https://joss.theoj.org/papers/10.21105/joss.00230) [![](https://badges.ropensci.org/96_status.svg)](https://github.com/ropensci/software-review/issues/96) [![codecov](https://codecov.io/gh/ropensci/getCRUCLdata/graph/badge.svg?token=OZjFYcNGbS)](https://app.codecov.io/gh/ropensci/getCRUCLdata)

<!-- badges: end -->

## Introduction to {getCRUCLdata}

The {getCRUCLdata} package provides functions that automate importing CRU CL v. 2.0 climatology data into R, facilitates the calculation of minimum temperature and maximum temperature, and formats the data into a [data.table](https://CRAN.R-project.org/package=data.table) or a list of [terra::rast](https://CRAN.R-project.org/package=terra) objects for use.

CRU CL v. 2.0 data are a gridded climatology of 1961-1990 monthly means released in 2002 and cover all land areas (excluding Antarctica) at 10 arc minutes (0.1666667 degree) resolution. For more information see the description of the data provided by the University of East Anglia Climate Research Unit (CRU), <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

## Changes to original CRU CL v. 2.0 data

This package automatically converts elevation values from kilometres to metres.

This package crops all spatial outputs to an extent of ymin = -60, ymax = 85, xmin = -180, xmax = 180. Note that the original wind data include land area for parts of Antarctica.

# Quick Start

## Install

{getCRUCLdata} is not available from CRAN. You can install it from GitHub as follows.

``` r
if (!require("remotes")) {
  install.packages("remotes")
}

install_github("ropensci/getCRUCLdata", build_vignettes = TRUE)
```

Or you can install it from the rOpenSci [R-universe](https://r-universe.dev/search?q=getCRUCLdata).

``` r
# Enable the rOpenSci R-universe
options(repos = c(
    rOpenSci = "https://ropensci.r-universe.dev",
    CRAN = "https://cloud.r-project.org"))
# Install the package
install.packages("getCRUCLdata")
```

------------------------------------------------------------------------

# Documentation

For complete documentation see the package website: <https://docs.ropensci.org/getCRUCLdata/>.

# Meta

## CRU CL v. 2.0 reference and abstract

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)

> A high-resolution data set of surface climate over global land areas Climate Research, 2000, Vol 21, pg 1-25

> 1.  School of Geography and the Environment, University of Oxford, Mansfield Road, Oxford OX1 3TB, United Kingdom
> 2.  Climatic Research Unit, and (3) Tyndall Centre for Climate Change Research, both at School of Environmental Sciences, University of East Anglia, Norwich NR4 7TJ, United Kingdom
> 3.  International Water Management Institute, PO Box 2075, Colombo, Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute latitude/longitude data set of mean monthly surface climate over global land areas, excluding Antarctica. The climatology includes 8 climate elements - precipitation, wet-day frequency, temperature, diurnal temperature range, relative humidity,sunshine duration, ground frost frequency and windspeed - and was interpolated from a data set of station means for the period centred on 1961 to 1990. Precipitation was first defined in terms of the parameters of the Gamma distribution, enabling the calculation of monthly precipitation at any given return period. The data are compared to an earlier data set at 0.5 degrees latitude/longitude resolution and show added value over most regions. The data will have many applications in applied climatology, biogeochemical modelling, hydrology and agricultural meteorology and are available through the School of Geography Oxford (<https://www.geog.ox.ac.uk/>), the International Water Management Institute “World Water and Climate Atlas” (<https://www.iwmi.org/>) and the Climatic Research Unit (<https://www.uea.ac.uk/groups-and-centres/climatic-research-unit>).

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the [`allcontributors` package](https://github.com/ropensci/allcontributors) following the [all-contributors](https://allcontributors.org) specification. Contributions of any kind are welcome!

### Code

+------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------+
| [![](https://avatars.githubusercontent.com/u/3195906?v=4){alt=""} ](https://github.com/adamhsparks)\ | [![](https://avatars.githubusercontent.com/u/577668?v=4){alt=""} ](https://github.com/sckott)\ | [![](https://avatars.githubusercontent.com/u/216319?v=4){alt=""} ](https://github.com/jeroen)\ | [![](https://avatars.githubusercontent.com/u/138494?v=4){alt=""} ](https://github.com/karthik)\ |
| [adamhsparks](https://github.com/ropensci/getCRUCLdata/commits?author=adamhsparks)                   | [sckott](https://github.com/ropensci/getCRUCLdata/commits?author=sckott)                       | [jeroen](https://github.com/ropensci/getCRUCLdata/commits?author=jeroen)                       | [karthik](https://github.com/ropensci/getCRUCLdata/commits?author=karthik)                      |
+------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------+

### Issues

+-------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| [![](https://avatars.githubusercontent.com/u/1305767?u=151f7c98a1bb78ccceac6297d28750acb42ec877&v=4){alt=""} ](https://github.com/ivanhanigan)\ | [![](https://avatars.githubusercontent.com/u/77564290?v=4){alt=""} ](https://github.com/sunjj878)\ | [![](https://avatars.githubusercontent.com/u/29225293?u=326393156ff083af6e10548ff16a1c8e439ebdf9&v=4){alt=""} ](https://github.com/mhesselbarth)\ |
| [ivanhanigan](https://github.com/ropensci/getCRUCLdata/issues?q=is%3Aissue+author%3Aivanhanigan)                                                | [sunjj878](https://github.com/ropensci/getCRUCLdata/issues?q=is%3Aissue+author%3Asunjj878)         | [mhesselbarth](https://github.com/ropensci/getCRUCLdata/issues?q=is%3Aissue+author%3Amhesselbarth)                                                |
+-------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+

<!-- markdownlint-enable -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## Other

-   Please [report any issues or bugs](https://github.com/ropensci/getCRUCLdata/issues).

-   License: MIT

-   Get citation information for *getCRUCLdata* in R typing `citation(package = "getCRUCLdata")`

-   Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.
