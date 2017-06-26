
This is a new minor release that updates getCRUCLdata using R packages that are
currently under development, removes one that is not and removes one import

## Test environments  

- macOS 10.12.5 (local install), R version 3.4.0 (2017-04-21)
- Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R version 3.4.0 (2017-04-21)
- Windows (on win-builder), R Under development (unstable) (2017-06-23 r72852)

## R CMD check results  

There were no ERRORs or WARNINGs  

## Minor Changes

- Use `file.path` in place of `paste0`

- _ccafs_ is now Suggested

## Bug fixes

- Fix bug where `rappdirs::user_config_dir()` was incorrectly used in place of
`rappdirs::user_cache_dir()`

## Reverse dependencies

There are no reverse dependencies.

