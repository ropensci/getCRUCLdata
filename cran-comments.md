## Test environments

* local OS X install, R 3.4.2
* Ubuntu 14.04.5 LTS (on travis-ci), R version 3.4.2 (2017-09-28)
* win-builder R Under development (unstable) (2017-09-12 r73242)
* win-builder R version R version 3.4.2 (2017-09-28)

## R CMD check results

0 errors | 0 warnings | 1 note

# New Minor Release

## Major changes

- Use _hoardr_ for managing cached files

- Use `lapply` in place of `purrr::map`, _purrr_ is no longer imported

## Minor changes

- Correct documentation where examples pointed to a non-existent list

## Reverse dependencies

There are no reverse dependencies.
