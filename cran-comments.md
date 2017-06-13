
This is a new minor release that updates getCRUCLdata to use newer R resources
and reduces the imports

## Test environments  

- macOS 10.12.5 (local install), R version 3.4.0 (2017-04-21)
- Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R Under development (unstable) (2017-06-10 r72776)

## R CMD check results  

There were no ERRORs or WARNINGs  

## Minor Changes

- Use _purrr_ in place of _plyr_ functions  

- Update DESCRIPTION file to be more complete  

- Remove use of "%>%" in functions and remove _magrittr_ import  

## Bug fixes

- Fix bugs in CITATION file

- Format NEWS.md to be more markdown standards compliant
  
## Reverse dependencies

There are no reverse dependencies.

