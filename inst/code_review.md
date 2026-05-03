# getCRUCLdata code review — priority fixes

~~## 1. Elevation unit asymmetry (likely data correctness bug)

~~`read_cru_dt` applies a km → m conversion (`elv * 1000L`) in `.read_local_files`,
but the raster path in `.make_rast` does not. `read_cru_dt` and `read_cru_rast`
therefore return elevation in different units for the same source data.~~

---

~~## 2. Dead code — `.resolve_cru_inputs` never called~~

~~`.resolve_cru_inputs` exists in `internal-resolve_cru_inputs.R` but is never
called anywhere. `.file_handling` does the same job and is what the public
functions actually use. Either remove `.resolve_cru_inputs` or complete the
intended swap.~~

---

## 3. Missing `isTRUE()` guards on `vars[...]` lookups

Bare `vars["x"]` in `if` conditions and `||` expressions will error if the
element is `NA`. Affects:

- `.normalize_vars` (`internal-vars.R`)
- `.drop_source_vars_dt` (`internal-create_dt.R`)
- `.read_local_files` — `pre_cv` branch (`internal-read_local_files.R`)
- `.create_rast` — derived variable and drop blocks (`internal-create_rast.R`)

Fix: replace `vars["x"]` with `isTRUE(vars["x"])` throughout, consistent with
the fix already applied in `.add_derived_dt`.

---

## 4. `month_names` defined four times

The same 12-element character vector is duplicated in:

- `.read_local_files`
- `.dt_to_rast`
- `.make_rast`
- `.create_rast`

Extract to a single package-level constant (e.g. `.CRU_MONTH_NAMES`) in
`globals.R` or a new `constants.R`.

---

## 5. `.cru_template_rast()` not used in `.dt_to_rast()`

`.dt_to_rast` constructs the CRU template raster inline, duplicating the magic
numbers (930 rows, 2160 cols, ymin = −65, ymax = 90, xmin = −180, xmax = 180)
that `.cru_template_rast()` already encapsulates. `.dt_to_rast` should call
`.cru_template_rast()` instead.

---

## 6. `.validate_filter_files` has an unused `x` parameter

The `x` argument is accepted but never used inside the function body. Remove it
from the signature, or pass it into `.check_vars` / `.filter_files` if it was
intended to feed into validation.

---

## 7. `req_options()` no-op in `.retry_download`

The trailing `httr2::req_options()` call with no arguments at the end of the
request pipeline in `internal-retry_download.R` is a no-op. It reads like an
unfinished line where an option was removed without cleaning up the call. Remove
it.

---

## Additional notes (lower priority)

- **`CRU_FILES` lookup table** is reallocated on every call to `.filter_files`.
  Move it to package-level scope.
- **`.validate_filter_files` `x` arg** — `fs::path_ext(x) == "gz"` in
  `.file_handling` will also match `.tar.gz`; `endsWith(x, ".dat.gz")` is more
  precise.
- **`Map(.retry_download, ...)` swallows per-file errors** — a failed download
  returns silently and the caller proceeds with a missing file. Consider
  propagating errors explicitly.
- **`.tidy_dt` regex** makes `.gz` optional (`(\\.gz)?`) but no uncompressed
  code path exists. Drop the `?` or add the path.
- **`req_cache(path = fs::path_temp())`** — cache is cleared on session restart,
  so cross-session re-downloads get no benefit. Add a comment if this is
  intentional.
- **`.onAttach` R.utils warning** fires on every load regardless of whether the
  user needs `.gz` support. Consider gating on a package option.
- **`@inherit` + local `@returns` in `read_cru_rast.R`** — verify roxygen2 is
  resolving the conflict between the inherited and local `@returns` tags
  correctly.
- **`.check_vars` missing names check** — a nameless logical vector passes
  validation but silently misbehaves when `vars["tmp"]` returns `NA`. Add a
  `!is.null(names(vars))` guard.
