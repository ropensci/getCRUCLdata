getCRUCLdata: Use and Explore CRU CL v. 2.0 Climatology Elements in R
================

[![Build Status](https://travis-ci.org/ropensci/getCRUCLdata.svg?branch=master)](https://travis-ci.org/ropensci/getCRUCLdata)
[![Build status](https://ci.appveyor.com/api/projects/status/5ujpaeben1p9e7k6/branch/master?svg=true)](https://ci.appveyor.com/project/adamhsparks/getcrucldata/branch/master)
[![Codecov test coverage](https://codecov.io/gh/ropensci/getCRUCLdata/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/getCRUCLdata?branch=master)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.466812.svg)](https://doi.org/10.5281/zenodo.466812)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/getCRUCLdata)](https://cran.r-project.org/package=getCRUCLdata)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![JOSS status](http://joss.theoj.org/papers/421837399efdbef2a248d0cf4a6c1d15/status.svg)](http://joss.theoj.org/papers/421837399efdbef2a248d0cf4a6c1d15)
[![](https://badges.ropensci.org/96_status.svg)](https://github.com/ropensci/onboarding/issues/96)

Author/Maintainer: Adam Sparks

## Introduction to *getCRUCLdata*

The *getCRUCLdata* package provides functions that automate importing
CRU CL v. 2.0 climatology data into R, facilitate the calculation of
minimum temperature and maximum temperature, and formats the data into a
[tidy data frame](http://vita.had.co.nz/papers/tidy-data.html) as a
[`tibble::tibble()`](https://www.rdocumentation.org/packages/tibble/versions/1.2)
or a
[`list()`](https://www.rdocumentation.org/packages/base/versions/3.4.0/topics/list)
of
[`raster::stack()`](https://www.rdocumentation.org/packages/raster/versions/2.5-8/topics/stack)
objects for use in an R session.

CRU CL v. 2.0 data are a gridded climatology of 1961-1990 monthly means
released in 2002 and cover all land areas (excluding Antarctica) at 10
arcminutes (0.1666667 degree) resolution. For more information see the
description of the data provided by the University of East Anglia
Climate Research Unit (CRU),
<https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

## Changes to original CRU CL v. 2.0 data

This package automatically converts elevation values from kilometres to
metres.

This package crops all spatial outputs to an extent of ymin = -60, ymax
= 85, xmin = -180, xmax = 180. Note that the original wind data include
land area for parts of Antarctica.

# Quick Start

## Install

### Stable version

A stable version of *getCRUCLdata* is available from
[CRAN](https://cran.r-project.org/package=getCRUCLdata).

``` r
install.packages("getCRUCLdata")
```

### Development version

A development version is available from from GitHub. If you wish to
install the development version that may have new features (but also may
not work properly), install the `tidyverse` [`remotes
package`](https://CRAN.R-project.org/package=remotes), available from
CRAN. I strive to keep the master branch on GitHub functional and
working properly, although this may not always happen.

``` r
if (!require("remotes")) {
  install.packages("remotes")
}

install_github("ropensci/getCRUCLdata", build_vignettes = TRUE)
```

-----

# Documentation

For complete documentation see the package website:
<https://ropensci.github.io/getCRUCLdata/>

# Meta

## CRU CL v. 2.0 reference and abstract

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)

> A high-resolution data set of surface climate over global land areas
> Climate Research, 2000, Vol 21, pg 1-25

> 1)  School of Geography and the Environment, University of Oxford,
>     Mansfield Road, Oxford OX1 3TB, United Kingdom  
> 2)  Climatic Research Unit, and (3) Tyndall Centre for Climate Change
>     Research, both at School of Environmental Sciences, University of
>     East Anglia, Norwich NR4 7TJ, United Kingdom  
> 3)  International Water Management Institute, PO Box 2075, Colombo,
>     Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute
> latitude/longitude data set of mean monthly surface climate over
> global land areas, excluding Antarctica. The climatology includes 8
> climate elements - precipitation, wet-day frequency, temperature,
> diurnal temperature range, relative humidity,sunshine duration, ground
> frost frequency and windspeed - and was interpolated from a data set
> of station means for the period centred on 1961 to 1990. Precipitation
> was first defined in terms of the parameters of the Gamma
> distribution, enabling the calculation of monthly precipitation at any
> given return period. The data are compared to an earlier data set at
> 0.5 degrees latitude/longitude resolution and show added value over
> most regions. The data will have many applications in applied
> climatology, biogeochemical modelling, hydrology and agricultural
> meteorology and are available through the School of Geography Oxford
> (<http://www.geog.ox.ac.uk>), the International Water Management
> Institute “World Water and Climate Atlas” (<http://www.iwmi.org>) and
> the Climatic Research Unit (<http://www.cru.uea.ac.uk>).

## Contributors

  - [Adam H. Sparks](https://github.com/adamhsparks)

## Other

  - Please [report any issues or
    bugs](https://github.com/ropensci/getCRUCLdata/issues).

  - License: MIT

  - Get citation information for *getCRUCLdata* in R typing
    `citation(package = "getCRUCLdata")`

  - Please note that the *getCRUCLdata* project is released with a
  [Contributor Code of Conduct](CONDUCT.md). By participating in the
  *getCRUCLdata* project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
