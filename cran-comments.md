
This is a new bug fix release that fixes bugs that prevented the previous
version submitted to CRAN from working

## Test environments

- macOS 10.12.5 (local install), R version 3.4.0 (2017-04-21)
- Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R Under development (unstable) (2017-06-23 r72852)

## R CMD check results

There were no ERRORs or WARNINGs

## Bug Fixes

- Fix bug where `cache` was not specified in internal function, `.set_cache()`,
this caused either of the functions fetching data from CRU to fail

- Fix bug where cache directory could not be created on Windows OS machines

## Minor Changes

- Replaced `for f in 1:length()` with `for f in seq_along()` for better
programming practices

## Reverse dependencies

There are no reverse dependencies.
