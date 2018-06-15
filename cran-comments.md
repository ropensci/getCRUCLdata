# Test environments

- local macOS install, 3.5.0 (2018-04-23)

- local Ubuntu 18.04, R version 3.5.0 (2018-04-23)

- win-builder R Under development (unstable) (2018-06-13 r74894)

- win-builder R version R version 3.5.0 (2018-04-23)

# R CMD check results

0 errors | 0 warnings | 1 note

# New Patch Release

## Bug fixes

- Fix bug where `tmp` and `dtr` could not be returned with `tmn` or `tmx` raster
stacks

## Minor changes

- Fix documentation formatting issues

- Enhance `stop` messages for user, just print message, not the function that
called it to clarify

# Reverse dependencies

No ERRORs or WARNINGs found.
