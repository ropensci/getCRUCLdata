## Test environments
* local macOS install, R 3.3.2
* Windows (on Appveyor), R 3.3.2
* win-builder (devel and release)
* Linux (on Travis), (devel and release)
* local Linux (Ubuntu 16.04) install, R 3.3.2

## R CMD check results

0 errors | 0 warnings | 1 note

## Major Changes

  * `create_CRU_stack()` and `create_CRU_df()` now only work with locally available files. If you need to fetch and create a data frame or raster stack of the data, please use the new functions, `get_CRU_stack()` and `get_CRU_stack()`
  * R >=3.2.0 now required

## Minor Changes

  * Improved documentation with examples on mapping and graphing and more detail regarding the data itself
  * Change the method in which files are downloaded to use `httr::GET()`
  * Ingest data using `data.table::fread` to decrease the amount of time necessary to run the functions
  * Functions check to see if data file(s) have already been downloaded during current R session, if so data file(s) are not requested for download again
  * Months are returned as a factor object in the tidy data frame
  
## Reverse dependencies

There are no reverse dependencies.

