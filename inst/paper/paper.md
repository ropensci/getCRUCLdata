---
title: 'getCRUCLdata: Download and Use CRU CL2.0 Climatology Data in R'
authors:
- affiliation: 1
  name: Adam H Sparks
  orcid: 0000-0002-0061-8359
output: pdf_document
tags:
- climate
- R
- applied climatology
- high resolution surface
- data
affiliations:
  index: 1
  name: University of Southern Queensland, Centre for Crop Health, Toowoomba Queensland 4350, Australia
bibliography: paper.bib
date: "30 January 2017"

---

# Summary

The getCRUCLdata package provides four functions that automate importing CRU CL2.0 climatology data [@New2002] into R [@R-base], facilitates the calculation of minimum temperature and maximum temperature, and formats the data into a tidy data frame [@Wickham2014] or a list of raster stack objects [@Raster] for use in R or easily exports to a raster format file for use in a geographic information system (GIS). Two functions, `get_CRU_df` and `get_CRU_stack` provide the ability to easily download CRU CL2.0 data from the CRU website and import the data into R. The other two functions `create_CRU_df` and `create_CRU_stack` allow the user to easily import the CRU data files from a local disk location and transform them into a tidy data frame or raster stack. The data have applications in applied climatology, biogeochemical modelling, hydrology and agricultural meteorology [@New2002].

# References
