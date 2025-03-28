# Changelog


## 1.2.0 (latest)
- Deprecated `minterms` and `maxterms` parameters on `karnaugh()`; use `manual-terms` instead
    - Update Manual to reflect this deprecation
- Replaced use of `style` (deprecated in Typst 0.13.0) with `context` expression; `k-mapper` should now compile when using Typst 0.13.x. 
- Minor style/layout changes in Manual

## 1.1.0
- Added changelog
- Fixed typos in Manual
- Added new arguments to `karnaugh()`
    - `implicant-stroke-transparentize` (default: `-100%`)
    - `implicant-stroke-darken` (default: `60%`)
    - `implicant-stroke-width` (default: `0.5pt`)
- Documented new changes in Manual

## 1.0.0
- Added customizable Karnaugh maps using the `karnaugh()` function
- Added Manual to document this package