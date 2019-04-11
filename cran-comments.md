# Test environments

- local macOS install, 3.5.3 (2019-03-11)

- local Ubuntu 18.04 LTS, R version 3.6.0 (2018-04-23)

- win-builder R version 3.6.0 alpha (2019-04-09 r76362)

- win-builder R version 3.5.3 (2019-03-11)

# R CMD check results

0 errors | 0 warnings | 1 note

# New Minor Release

## Bug fixes

- Update tests that spuriously failed on some systems due to tolerances

- Update package to follow CRAN policies

## Minor changes

- Remove Imports for _dplyr_, _tibble_ and _tidyr_ to lessen dependencies

- Remove Suggests for _readr_ and _sp_

- Add _tibble_ to Suggests. _tibble_ is no longer required for use of this
package

- Enhance documentation

# Reverse dependencies

No ERRORs or WARNINGs found.
