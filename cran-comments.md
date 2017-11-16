## Test environments

* local OS X install, R 3.4.2
* Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.2 (2017-09-28)
* win-builder R Under development (unstable) (2017-09-12 r73242)
* win-builder R version R version 3.4.2 (2017-09-28)

## R CMD check results

0 errors | 0 warnings | 1 note

# New Minor Release

- Fixed a bug where the file cache was not in the proper subdirectory. The file
cache has moved to the proper location in a `R/getCRUCLdata` location rather
than `getCRUCLdata`.

- Use `lapply` in place of `purrr::map`, _purrr_ is no longer imported

## Minor changes

- Correct documentation where examples pointed to a non-existent list

## Deprecated functions

`CRU_cache_list()` now superceded by`manage_cache$list()`
`CRU_cache_details()` now superceded by `manage_cache$details()`
`CRU_cache_delete()` now superceded by `manage_cache$delete()`
`CRU_cache_delete_all()` now superceded by `manage_cache$delete_all()`

## Reverse dependencies

There are no reverse dependencies.
