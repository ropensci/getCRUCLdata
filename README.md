
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/getCRUCLdata.svg?branch=master)](https://travis-ci.org/) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/adamhsparks/getCRUCLdata?branch=master&svg=true)](https://ci.appveyor.com/project/adamhsparks/getCRUCLdata) [![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/getCRUCLdata?color=blue)](https://github.com/metacran/cranlogs.app) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/getCRUCLdata)](https://cran.r-project.org/package=getCRUCLdata)

getCRUCLdata
============

Download and Use CRU CL2.0 Climatology Data in R
------------------------------------------------

Author/Maintainer: Adam Sparks

The getCRUCLdata package provides two functions that automate downloading and importing CRU CL2.0 climatology data into R, facilitate the calculation of minimum temperature and maximum temperature, and formats the data into a tidy data frame or a list of raster stack objects for use in an R session. CRU CL2.0 data are a gridded climatology of 1961-1990 monthly means released in 2002 and cover all land areas (excluding Antarctica) at 10-minute resolution. For more information see the description of the data provided by the University of East Anglia Climate Research Unit (CRU), <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

License: MIT + file LICENSE

Imports: curl, dplyr, plyr, purrr, raster, tidyr, utils

Changes to original data
------------------------

This package automatically converts elevation values from kilometres to metres.

This package crops all spatial outputs to an extent of ymin = -60, ymax = 85, xmin = -180, xmax = 180. Note that the original wind data include land area for parts of Antarctica.

Quick Start
===========

Install
-------

### Stable version

A stable version of GSODR is available from [CRAN](https://cran.r-project.org/package=getCRUCLdata).

``` r
install.packages("getCRUdata")
```

### Development version

A development version is available from from GitHub. If you wish to install the development version that may have new features (but also may not work properly), install the [devtools package](https://CRAN.R-project.org/package=devtools), available from CRAN. I strive to keep the master branch on GitHub functional and working properly, although this may not always happen.

If you find bugs, please file a [report as an issue](https://github.com/adamhsparks/getCRUCLdata/issues).

``` r
#install.packages("devtools")
devtools::install_github("adamhsparks/getCRUCLdata", build_vignettes = TRUE)
```

Using getCRUCLdata
------------------

Creating tidy data frames for use in R
--------------------------------------

The `create_CRU_df()` function creates tidy data frames of the CRU CL2.0 climatology elements. Illustrated here, create a tidy data frame of all CRU CL2.0 climatology elements available.

``` r
library(getCRUCLdata)

CRU_data <- create_CRU_df(pre = TRUE,
                          pre_cv = TRUE,
                          rd0 = TRUE,
                          tmp = TRUE,
                          dtr = TRUE,
                          reh = TRUE,
                          tmn = TRUE,
                          tmx = TRUE,
                          sunp = TRUE,
                          frs = TRUE,
                          wnd = TRUE,
                          elv = TRUE)
```

Create a tidy data frame of mean temperature and relative humidity.

``` r
t_rh <- create_CRU_df(tmp = TRUE,
                      reh = TRUE)
```

Creating raster stacks for use in R
-----------------------------------

The `create_CRU_stack()` function provides functionality for producing a list of [raster](https://CRAN.R-project.org/package=raster) stack objects for use in an R session.

Create a list of raster stacks of all CRU CL2.0 climatology elements available.

``` r
CRU_stack <- create_CRU_stack(pre = TRUE,
                              pre_cv = TRUE,
                              rd0 = TRUE,
                              tmp = TRUE,
                              dtr = TRUE,
                              reh = TRUE,
                              tmn = TRUE,
                              tmx = TRUE,
                              sunp = TRUE,
                              frs = TRUE,
                              wnd = TRUE,
                              elv = TRUE)
```

Create a list of raster stacks of maximum and minimum temperature.

``` r
tmn_tmx <- create_CRU_stack(tmn = TRUE,
                            tmx = TRUE)
```

------------------------------------------------------------------------

Data reference and abstract
===========================

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)

> A high-resolution data set of surface climate over global land areas Climate Research, 2000, Vol 21, pg 1-25

> 1.  School of Geography and the Environment, University of Oxford, Mansfield Road, Oxford OX1 3TB, United Kingdom
> 2.  Climatic Research Unit, and (3) Tyndall Centre for Climate Change Research, both at School of Environmental Sciences, University of East Anglia, Norwich NR4 7TJ, United Kingdom
> 3.  International Water Management Institute, PO Box 2075, Colombo, Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute latitude/longitude data set of mean monthly surface climate over global land areas, excluding Antarctica. The climatology includes 8 climate elements - precipitation, wet-day frequency, temperature, diurnal temperature range, relative humidity,sunshine duration, ground frost frequency and windspeed - and was interpolated from a data set of station means for the period centred on 1961 to 1990. Precipitation was first defined in terms of the parameters of the Gamma distribution, enabling the calculation of monthly precipitation at any given return period. The data are compared to an earlier data set at 0.5 degrees latitude/longitude resolution and show added value over most regions. The data will have many applications in applied climatology, biogeochemical modelling, hydrology and agricultural meteorology and are available through the School of Geography Oxford (<http://www.geog.ox.ac.uk>), the International Water Management Institute "World Water and Climate Atlas" (<http://www.iwmi.org>) and the Climatic Research Unit (<http://www.cru.uea.ac.uk>).

Notes
=====

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
