## R CMD check results

0 errors | 0 warnings | 2 notes

## Fixes from previous CRAN version

I had asked that the last version of this package on CRAN be removed, but the
notes indicate it was forcibly removed for "leaving things behind".

Therefore, in this release, the caching capabilities now follow the new R
standard `tools::R_user_dir(package = "getCRUCLdata")` in spite of the default
behaviour of the underlying CRAN packages, {hoadr} and {rappdirs}, which have
been used since this package was first submitted to CRAN to provide file
caching functionality in this package. I trust that this is sufficient to have
this package reinstated on CRAN.

- This is a new release.
