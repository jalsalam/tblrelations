# tblrelations

The goal of tblrelations is to fill in functions for working with tibbles in a RDBMS-like way (and on the way explore relational algebra terminology).

## Installation

You can (not yet) install the development version of tblrelations from Github with:

``` r
devtools::install_github("jalsalam/tblrelations")
```

## Example

Have you ever been surprised that a left_join resulted in an unexpected cross-join or dropped rows?

``` r
pk_ish(dfy, by = "id")
# TRUE if dfy$pk is unique
# FALSE if dfy$pk is not unique

fk_ish(dfx, dfy, by = "id")
# TRUE if all combination of "id" in dfx are in dfy and dfy$id is unique.

```

## Development goals

1. Use the same semantics for the `by` argument as are used in the `dplyr::join` verbs. Maybe this means using `tidyselect`? This should mean that you can do any of:

``` r
pk_ish(dfy, by = "id")
pk_ish(dfy, by = c("name", "dob"))

fk_ish(dfx, dfy, by = c("idx" = "idy"))
```

2. Maybe wrap `left_join` with `left_join_fk()` which checks `fk_ish` and if so does the normal `left_join`?

3. Maybe s3 object for which you can more permanently label pk?

4. Maybe express domains, codomains, onto, covers, or other such function/set theory types of concepts as tests on relations.

5. Maybe coerce a table to a function. E.g. :

```r
join_dfy <- as_tbl_function(dfy, by = "id")

dfx %>% join_dfy(by = "id")
```

But there are plenty of questions about how that should work.
