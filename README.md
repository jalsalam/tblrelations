
<!-- README.md is generated from README.Rmd. Please edit that file -->
tblrelations
============

The goal of tblrelations is to fill in functions for working with tibbles in a RDBMS-like way (and on the way explore relational algebra terminology).

Installation
------------

You can install the development version of tblrelations from Github with:

``` r
devtools::install_github("jalsalam/tblrelations")
```

Example
-------

When working with data frames in R in a relational data way, it is useful to identify primary and foreign keys:

``` r
library(tblrelations)
library(nycflights13)

airports
#> # A tibble: 1,458 x 8
#>    faa   name                   lat    lon   alt    tz dst   tzone        
#>    <chr> <chr>                <dbl>  <dbl> <int> <dbl> <chr> <chr>        
#>  1 04G   Lansdowne Airport     41.1  -80.6  1044    -5 A     America/New_~
#>  2 06A   Moton Field Municip~  32.5  -85.7   264    -6 A     America/Chic~
#>  3 06C   Schaumburg Regional   42.0  -88.1   801    -6 A     America/Chic~
#>  4 06N   Randall Airport       41.4  -74.4   523    -5 A     America/New_~
#>  5 09J   Jekyll Island Airpo~  31.1  -81.4    11    -5 A     America/New_~
#>  6 0A9   Elizabethton Munici~  36.4  -82.2  1593    -5 A     America/New_~
#>  7 0G6   Williams County Air~  41.5  -84.5   730    -5 A     America/New_~
#>  8 0G7   Finger Lakes Region~  42.9  -76.8   492    -5 A     America/New_~
#>  9 0P2   Shoestring Aviation~  39.8  -76.6  1000    -5 U     America/New_~
#> 10 0S9   Jefferson County In~  48.1 -123.    108    -8 A     America/Los_~
#> # ... with 1,448 more rows
```

``` r
pk_ish(airports, by = "faa")
#> [1] TRUE
```

``` r
flights
#> # A tibble: 336,776 x 19
#>     year month   day dep_time sched_dep_time dep_delay arr_time
#>    <int> <int> <int>    <int>          <int>     <dbl>    <int>
#>  1  2013     1     1      517            515         2      830
#>  2  2013     1     1      533            529         4      850
#>  3  2013     1     1      542            540         2      923
#>  4  2013     1     1      544            545        -1     1004
#>  5  2013     1     1      554            600        -6      812
#>  6  2013     1     1      554            558        -4      740
#>  7  2013     1     1      555            600        -5      913
#>  8  2013     1     1      557            600        -3      709
#>  9  2013     1     1      557            600        -3      838
#> 10  2013     1     1      558            600        -2      753
#> # ... with 336,766 more rows, and 12 more variables: sched_arr_time <int>,
#> #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```

``` r
pk_ish(flights, by = c("year", "month", "day", "flight"))
#> [1] FALSE
pk_ish(flights, by = c("year", "month", "day", "tailnum"))
#> [1] FALSE
pk_ish(flights, by = c("year", "month", "day", "hour", "flight"))
#> [1] FALSE
```

(this is supposed to be FALSE, FALSE, TRUE. See: [r4ds relational data](http://r4ds.had.co.nz/relational-data.html))

Have you ever been surprised that a left\_join resulted in an unexpected cross-join or NA rows?

``` r
pk_ish(dfy, by = "id")
# TRUE if dfy$pk is unique
# FALSE if dfy$pk is not unique

fk_ish(dfx, dfy, by = "id")
# TRUE if all combination of "id" in dfx are in dfy and dfy$id is unique.

left_join_fk(dfx, dfy, by = "id")
# if there is a foreign-key-ish relationship of dfx -> dfy using "id", then it returns the joined table as normal, otherwise it errors.
```

Development goals
-----------------

1.  Make sure that the same semantics of the `by` argument can be used with `left_join_fk()` as can be used with the normal dplyr join verbs. I know that the select/rename verbs use `tidyselect` package, but I don't think that there is a similar backend for join verb `by` specification.

2.  Add diagnostics and good error messages that let you know if there are missing or duplicate values on your dimension table.

3.  Add right\_join\_fk. Are there other join relationships that make sense for these kinds of checks?

Much more speculative. Really need some DB research on what else might be helpful:
----------------------------------------------------------------------------------

-   Maybe s3 object for which you can more permanently label pk?

-   Maybe express domains, codomains, onto, covers, or other such function/set theory types of concepts as tests on relations.

-   Maybe coerce a table to a function. E.g. :

``` r
join_dfy <- as_tbl_function(dfy, by = "id")

dfx %>% join_dfy(by = "id")
```

But there are plenty of questions about what else would be worthwhile.
