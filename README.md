
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/getCRUCLdata.svg?branch=master)](https://travis-ci.org/) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/adamhsparks/getCRUCLdata?branch=master&svg=true)](https://ci.appveyor.com/project/adamhsparks/getCRUCLdata) [![Coverage Status](https://img.shields.io/codecov/c/github/adamhsparks/getCRUCLdata/master.svg)](https://codecov.io/github/adamhsparks/getCRUCLdata?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/getCRUCLdata)](https://cran.r-project.org/package=getCRUCLdata) [![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/getCRUCLdata?color=blue)](https://github.com/metacran/cranlogs.app) [![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/grand-total/getCRUCLdata?color=blue)](https://github.com/metacran/cranlogs.app) [![Research software impact](http://depsy.org/api/package/cran/getCRUCLdata/badge.svg)](http://depsy.org/package/r/getCRUCLdata) [![DOI](https://zenodo.org/badge/71445587.svg)](https://zenodo.org/badge/latestdoi/71445587)

getCRUCLdata
============

Download and Use CRU CL2.0 Climatology Data in R
------------------------------------------------

Author/Maintainer: Adam Sparks

The getCRUCLdata package provides four functions that automate importing CRU CL2.0 climatology data into R, facilitate the calculation of minimum temperature and maximum temperature, and formats the data into a tidy data frame or a list of raster stack objects for use in an R session. CRU CL2.0 data are a gridded climatology of 1961-1990 monthly means released in 2002 and cover all land areas (excluding Antarctica) at 10 arcminutes (0.1666667 degree) resolution. For more information see the description of the data provided by the University of East Anglia Climate Research Unit (CRU), <https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

Changes to original data
------------------------

This package automatically converts elevation values from kilometres to metres.

This package crops all spatial outputs to an extent of ymin = -60, ymax = 85, xmin = -180, xmax = 180. Note that the original wind data include land area for parts of Antarctica.

Quick Start
===========

Install
-------

### Stable version

A stable version of getCRUCLdata is available from [CRAN](https://cran.r-project.org/package=getCRUCLdata).

``` r
install.packages("getCRUCLdata")
```

### Development version

A development version is available from from GitHub. If you wish to install the development version that may have new features (but also may not work properly), install the [devtools package](https://CRAN.R-project.org/package=devtools), available from CRAN. I strive to keep the master branch on GitHub functional and working properly, although this may not always happen.

If you find bugs, please file a [report as an issue](https://github.com/adamhsparks/getCRUCLdata/issues).

``` r
if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("adamhsparks/getCRUCLdata", build_vignettes = TRUE)

library(getCRUCLdata)
```

Using getCRUCLdata
------------------

Creating tidy data frames for use in R
--------------------------------------

There are two methods that this package provides for creating tidy data frames of the CRU CL2.0 climate data as a [`tibble`](https://github.com/tidyverse/tibble). Depending on your needs you may need to use `create_CRU_df()`, which will create a tidy data frame of the climate elements from *locally available* files. Or you can use `get_CRU_df()`, which will automate the fetching and importing of the data files into R in one step.

The `create_CRU_df()` function is useful if you have network issues that interfere with R downloading the data files themselves from the CRU website or if you frequently work with these data and do not wish to download them every time they are needed.

The `get_CRU_df()` function creates tidy data frames of the CRU CL2.0 climatology elements. Illustrated here, create a tidy data frame of all CRU CL2.0 climatology elements available.

``` r
library(getCRUCLdata)

CRU_data <- get_CRU_df(pre = TRUE,
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

Perhaps you only need one or two elements, it is easy to create a tidy data frame of mean temperature only.

``` r
t <- get_CRU_df(tmp = TRUE)
```

The `create_CRU_df()` function works in the same way with only one minor difference. You must supply the location of the files on the local disk (`dsn`) that you wish to import.

``` r
t <- create_CRU_df(tmp = TRUE, dsn = "~/Downloads")
```

Plotting data from the tidy dataframe
-------------------------------------

Now that we have the data, we can plot it easily using [`ggplot2`](http://ggplot2.org) and the fantastic [`viridis`](https://CRAN.R-project.org/package=viridis) package for the colour scale.

``` r
if (!require("ggplot2")) {
  install.packages(ggplot2)
}
if (!require("viridis")) {
  install.packages("viridis")
}

library(ggplot2)
library(viridis)
```

Now that the required packages are installed and loaded, we can generate a figure of temperatures using `ggplot2` to map the 12 months.

``` r
ggplot(data = t, aes(x = lon, y = lat)) +
  geom_raster(aes(fill = tmp)) +
  scale_fill_viridis(option = "inferno") +
  coord_quickmap() +
  ggtitle("Global Mean Monthly Temperatures 1961-1990") +
  facet_wrap(~ month, nrow = 4)
```

![Plot of global mean monthly temperatures 1961-1990](README-unnamed-chunk-6-1.png)

We can also generate a violin plot of the same data to visualise how the temperatures change throughout the year.

``` r
ggplot(data = t, aes(x = month, y = tmp)) +
  geom_violin() +
  ylab("Temperature (˚C)") +
  labs(title = "Global Monthly Mean Land Surface Temperatures From 1960-1991",
       subtitle = "Excludes Antarctica")
```

![Violin plot of global mean temperatures 1961-1990](README-unnamed-chunk-7-1.png)

Saving the tidy data frame as a CSV (comma separated values file) locally
-------------------------------------------------------------------------

Save the resulting tidy data frame to local disk as a comma separated (CSV) file to local disk.

``` r
library(readr)

write_csv(t, path = "~/CRU_tmp.csv")
```

Creating raster stacks for use in R or saving for use in a GIS
--------------------------------------------------------------

For working with spatial data,`getCRUCLdata()` provides two functions that create lists of [raster](https://CRAN.R-project.org/package=raster) stacks of the data.

The `create_CRU_stack()` and `get_CRU_stack()` functions provide similar functionality to `create_CRU_df()` and `get_CRU_df()`, but rather than returning a tidy data frame, they return a a list of [raster](https://CRAN.R-project.org/package=raster) stack objects for use in an R session.

Fetch data from the CRU website and create a list of raster stacks of all CRU CL2.0 climatology elements available.

``` r
CRU_stack <- get_CRU_stack(pre = TRUE,
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
tmn_tmx <- get_CRU_stack(tmn = TRUE,
                         tmx = TRUE)
```

The `create_CRU_stack()` function works in the same way with only one minor difference. You must supply the location of the files on the local disk (`dsn`) that you wish to import.

``` r
t <- create_CRU_stack(tmp = TRUE, dsn = "~/Downloads")
```

### Ploting raster stacks of tmin and tmax

Because the stacks are in a list, we need to access each element of the list individually to plot them, that's what the `[[1]]` or `[[2]]` is, the first or second element of the list.

``` r
library(raster)

plot(tmn_tmx[[1]])
```

![Plot of raster layers from minimum temperature stack](README-unnamed-chunk-10-1.png)

To plot only one month from the stack is also possible. Here we plot maxmimum temperature for July. Note that we use indexing `[[2]]` as before but append a `$jul` to the object. This is the name of the layer in the raster stack. So, we are telling R to plot the second object in the `tmn_tmx` list, which is `tmx` and from that raster stack, plot only the layer for July.

``` r
plot(tmn_tmx[[2]]$jul)
```

![Plot of maximum temperatures for July](README-unnamed-chunk-11-1.png)

Saving raster objects to local disk
-----------------------------------

The raster stack objects can be saved to disk as geotiff files (others are available, see help for `writeRaster` and `writeFormats` for more options) in the `Data` directory with a tmn or tmx prefix to the month for a filename.

``` r
library(raster)

dir.create(file.path("~/Data"), showWarnings = FALSE)
writeRaster(tmn_tmx$tmn, filename = paste0("~/Data/tmn_", names(tmn_tmx$tmn)), bylayer = TRUE, format = "GTiff")

writeRaster(tmn_tmx$tmx, filename = paste0("~/Data/tmx_", names(tmn_tmx$tmn)), bylayer = TRUE, format = "GTiff")
```

------------------------------------------------------------------------

Documentation
=============

For complete documentation see the package website: <https://adamhsparks.github.io/getCRUCLdata/>

Meta
====

CRU CL2.0 reference and abstract
--------------------------------

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)

> A high-resolution data set of surface climate over global land areas Climate Research, 2000, Vol 21, pg 1-25

> 1.  School of Geography and the Environment, University of Oxford, Mansfield Road, Oxford OX1 3TB, United Kingdom
> 2.  Climatic Research Unit, and (3) Tyndall Centre for Climate Change Research, both at School of Environmental Sciences, University of East Anglia, Norwich NR4 7TJ, United Kingdom
> 3.  International Water Management Institute, PO Box 2075, Colombo, Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute latitude/longitude data set of mean monthly surface climate over global land areas, excluding Antarctica. The climatology includes 8 climate elements - precipitation, wet-day frequency, temperature, diurnal temperature range, relative humidity,sunshine duration, ground frost frequency and windspeed - and was interpolated from a data set of station means for the period centred on 1961 to 1990. Precipitation was first defined in terms of the parameters of the Gamma distribution, enabling the calculation of monthly precipitation at any given return period. The data are compared to an earlier data set at 0.5 degrees latitude/longitude resolution and show added value over most regions. The data will have many applications in applied climatology, biogeochemical modelling, hydrology and agricultural meteorology and are available through the School of Geography Oxford (<http://www.geog.ox.ac.uk>), the International Water Management Institute "World Water and Climate Atlas" (<http://www.iwmi.org>) and the Climatic Research Unit (<http://www.cru.uea.ac.uk>).

Contributors
------------

-   [Adam H. Sparks](https://github.com/adamhsparks)

Other
-----

-   Please [report any issues or bugs](https://github.com/adamhsparks/getCRUCLdata/issues).
-   License: MIT
-   Get citation information for `getCRUCLdata` in R typing `citation(package = "getCRUCLdata")`
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
