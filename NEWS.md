# getCRUCLdata 1.0.3

## Minor changes

- Add source and references to documentation for data

- Create function aliases that use all lower case, _e.g._, `get_cru_stack()` vs `get_CRU_stack()`

- Improved documentation with linting, ensuring consistency in units of measurement, etc.

# getCRUCLdata 1.0.2

## Minor changes

- Reknit vignette with proper values

# getCRUCLdata 1.0.1

## Minor changes

- Fix CITATION to align with current CRAN standards

- Update URLs to ensure all are valid

- Correct grammar in several parts of documentation and README

## Bug fixes

- Fix cross references in documentation

# getCRUCLdata 1.0.0

## Major changes

- The cache is now where ever `tools::R_user_dir(package = "getCRUCLdata", which = "cache")` is defined by R (>= 4.0.0) and _should_ align with CRAN standards, so it _might_ be possible to get this back on CRAN

- Depends on R (>= 4.0.0)

- {data.table} is no longer imported as a whole

## Minor changes

- {cli} is used for errors that are emitted to the user

- Many internal changes including code linting and styling to improve code smells

- Improved documentation

- Use {roxyglobals} for undefined globals

# getCRUCLdata 0.3.3

## Minor changes

- Replace _raster_ package with _terra_

- Update URLs

# getCRUCLdata 0.3.2

## Minor changes

- Correct link redirects in README

- Correct formatting in documentation

- Precompile main vignette

- Add second vignette to illustrate advanced usage

- Remove _pkgdown_ from Suggests

- Move CI to GitHub Actions

# getCRUCLdata 0.3.1

## Bug fixes

- Fix bug in documentation that prevented example from working

## Minor changes

- Update URL in DESCRIPTION file

# getCRUCLdata 0.3.0

## Major changes

- Remove Imports for _dplyr_, _tibble_ and _tidyr_ to lessen dependencies

- Remove Suggests for _readr_ and _sp_

- Enhance documentation

## Bug fixes

- Update tests that spuriously failed on some systems due to tolerances

- Update package to follow CRAN policies

# getCRUCLdata 0.2.5

## Minor changes

- Removes startup message, instead placing information in CITATION file

- Reorganises internal functions consolidating functions all in a single file
  and following a standard naming scheme for all internal functions

# getCRUCLdata 0.2.4

## Bug fixes

- Fix bug where `tmp` and `dtr` could not be returned with `tmn` or `tmx` raster
  stacks

- Move `rappdirs` to SUGGESTS to fix NOTEs

## Minor changes

- Fix documentation formatting issues

- Enhance `stop` messages for user, just print message, not the function that
  called it to clarify

# getCRUCLdata 0.2.3

## Bug fixes

- Fix missing import for `rappdirs`

## Minor changes

- Remove the use of `plyr` in tests

# getCRUCLdata 0.2.2

## Bug fixes

- Fix incorrect ORCID entry author field

# getCRUCLdata 0.2.1

## Minor changes

- Fix ORCID entry in DESCRIPTION per CRAN maintainer's request

- Remove Scott as contributor, the code contributed has been removed

# getCRUCLdata 0.2.0

## Major changes

- Use _hoardr_ for managing cached files

- Fixed a bug where the file cache was not in the proper subdirectory. The file
  cache has moved to the proper location in a `R/getCRUCLdata` location rather
  than `getCRUCLdata`. You may wish to move files externally to R in order to keep
  them in the cache where the package will find them

- Use `lapply` in place of `purrr::map`, _purrr_ is no longer imported

## Minor changes

- Correct documentation where examples pointed to a non-existent list

## Deprecated functions

`CRU_cache_list()` now superseded by`manage_cache$list()`
`CRU_cache_details()` now superseded by `manage_cache$details()`
`CRU_cache_delete()` now superseded by `manage_cache$delete()`
`CRU_cache_delete_all()` now superseded by `manage_cache$delete_all()`

# getCRUCLdata 0.1.10

## Major changes

- Add startup message regarding data source, use and citation

- Include Scott Chamberlain as copyright holder and contributor for file
  caching functionality

# getCRUCLdata 0.1.9

## Bug fixes

- Fix issues in cached file management where files were not properly handled

# getCRUCLdata 0.1.8

## Bug Fixes

- Fix bug where `cache` was not specified in internal function, `.set_cache()`,
  this caused either of the functions fetching data from CRU to fail

- Fix bug where `cache` directory could not be created on Windows OS machines

- Fix bug where tmx was returned when _either_ tmn _or_ tmx was requested for
  data frame, tmn now returned when requested and tmx now returned when requested.
  Raster stacks were not affected by this bug

## Minor Changes

- Replaced `for f in 1:length()` with `for f in seq_along()` for better
  programming practices

# getCRUCLdata 0.1.7

## Minor Changes

- Use `file.path` in place of `paste0`

## Bug Fixes

- Fix bug where `rappdirs::user_config_dir()` was incorrectly used in place of
  `rappdirs::user_cache_dir()`

# getCRUCLdata 0.1.6

## Minor Changes

- Use _purrr_ in place of _plyr_ functions

- Update DESCRIPTION file to be more complete

- Remove use of "%>%" in functions and remove _magrittr_ import

## Bug Fixes

- Fix bugs in CITATION file

- Format NEWS.md to be more markdown standards compliant

# getCRUCLdata 0.1.5

## Major Changes

- `create_CRU_stack()` and `create_CRU_df()` now only work with locally
  available files. If you need to fetch and create a data frame or raster stack
  of the data, please use the new functions, `get_CRU_stack()` and
  `get_CRU_stack()`

- R >=3.2.0 now required

- Data can be cached using either `get_CRU_stack()` or `get_CRU_df()` for later
  use

## Minor Changes

- Improved documentation with examples on mapping and graphing and more detail
  regarding the data itself

- Change the method in which files are downloaded to use `httr::GET()`

- Ingest data using `data.table::fread` to decrease the amount of time necessary
  to run the functions

- Functions check to see if data file(s) have already been downloaded during
  current R session, if so data file(s) are not requested for download again

- Months are returned as a factor object in the tidy data frame

# getCRUCLdata 0.1.4

## Minor Changes

- Correct fix bug in data frame object generation where elevation was improperly
  handled and function would stop

# getCRUCLdata 0.1.3

## Minor Changes

- Correct fix bug in raster object generation where the objects were incorrectly
  cropped

- Update documentation with ROxygen 6.0.0

- Minor edits to documentation for clarity

# getCRUCLdata 0.1.2

## Minor Changes

- Correct documentation to read that the data resolution is 10 minute, not 10
  seconds

- Correct URLs in DESCRIPTION file

- Add required version for PURRR

- Add required version for R

- Corrected URL pointing to CRU readme.txt file

# getCRUCLdata 0.1.1

## Minor Changes

- Renamed to getCRUdata as suggested by CRAN maintainers

- Revised description file as requested by CRAN maintainers

- Enhanced vignette

## getCRUCL2.0 0.1.0

## Minor Changes

- Initial submission to CRAN
