# getCRUCLdata 0.1.5

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
  
# getCRUCLdata 0.1.4

## Minor Changes

  * Correct fix bug in data frame object generation where elevation was improperly handled and function would stop  

# getCRUCLdata 0.1.3

## Minor Changes

  * Correct fix bug in raster object generation where the objects were incorrectly cropped  
  * Update documentation with ROxygen 6.0.0  
  * Minor edits to documentation for clarity  

# getCRUCLdata 0.1.2

## Minor Changes

  - Correct documentation to read that the data resolution is 10 minute, not 10 seconds  
  - Correct URLs in DESCRIPTION file  
  - Add required version for PURRR  
  - Add required version for R  
  - Corrected URL pointing to CRU readme.txt file  

# getCRUCLdata 0.1.1

## Minor Changes

  - Renamed to getCRUdata as suggested by CRAN maintainers  
  - Revised description file as requested by CRAN maintainers  
  - Enhanced vignette  

# getCRUCL2.0 0.1.0

## Minor Changes

  - Initial submission to CRAN
