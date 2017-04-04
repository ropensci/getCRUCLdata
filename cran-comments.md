## Test environments  

- OS X 10.11.6 (local install), R version 3.3.3 (2017-03-06)
- Ubuntu 14.04.5 LTS (on travis-ci), R version 3.3.3 (2017-03-06)
- Windows (on win-builder), R version 3.3.3 (2017-03-06)
- Windows (on win-builder), R version 3.4.0 alpha (2017-03-31 r72459)

## R CMD check results  

There were no ERRORs or WARNINGs  

## Major Changes

  * `create_CRU_stack()` and `create_CRU_df()` now only work with locally available files. If you need to fetch and create a data frame or raster stack of the data, please use the new functions, `get_CRU_stack()` and `get_CRU_stack()`  
  * R >=3.2.0 now required  
  * Data can be cached using either `get_CRU_stack()` or `get_CRU_df()` for later use  

## Minor Changes

  * Improved documentation with examples on mapping and graphing and more detail regarding the data itself
  * Change the method in which files are downloaded to use `httr::GET()`  
  * Ingest data using `data.table::fread` to decrease the amount of time necessary to run the functions  
  * Functions check to see if data file(s) have already been downloaded during current R session, if so data file(s) are not requested for download again  
  * Months are returned as a factor object in the tidy data frame  
  
## Reverse dependencies

There are no reverse dependencies.

