# tblrelations

The goal of tblrelations is to fill in functions for working with tibbles in a RDBMS-like way (and on the way explore relational algebra terminology).

## Installation

You can install the development version of tblrelations from Github with:

``` r
devtools::install_github("jalsalam/tblrelations")
```


## Example

Have you ever been surprised that a left_join resulted in an unexpected cross-join or NA rows?

``` r
pk_ish(dfy, by = "id")
# TRUE if dfy$pk is unique
# FALSE if dfy$pk is not unique

fk_ish(dfx, dfy, by = "id")
# TRUE if all combination of "id" in dfx are in dfy and dfy$id is unique.

left_join_fk(dfx, dfy, by = "id")
# if there is a foreign-key-ish relationship of dfx -> dfy using "id", then it returns the joined table as normal, otherwise it errors.

```

## Development goals

1. Make sure that the same semantics of the `by` argument can be used with `left_join_fk()` as can be used with the normal dplyr join verbs. I know that the select/rename verbs use `tidyselect` package, but I don't think that there is a similar backend for join verb `by` specification.

2. Add diagnostics and good error messages that let you know if there are missing or duplicate values on your dimension table.

3. Add right_join_fk. Are there other join relationships that make sense for these kinds of checks?


## Much more speculative. Really need some DB research on what else might be helpful:

- Maybe s3 object for which you can more permanently label pk?

- Maybe express domains, codomains, onto, covers, or other such function/set theory types of concepts as tests on relations.

- Maybe coerce a table to a function. E.g. :

```r
join_dfy <- as_tbl_function(dfy, by = "id")

dfx %>% join_dfy(by = "id")
```

But there are plenty of questions about what else would be worthwhile.
