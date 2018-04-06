

#' Check a tbl for a candidate primary key
#'
#' A primary key of a table is a column (or set of columns) which is distinct.
#'@examples
#'dfx <- tibble::tibble(id = c(1, 2, 3), val = c(1, 1, 2))
#'pk_ish(dfx, "id")
#'dfy <- tibble::tibble(id = c(1, 1, 2), val = c(1, 2, 3))
#'pk_ish(dfy, "id")
pk_ish <- function(.data, by = NULL,
                   na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  nrow(distinct(select(.data, by))) == nrow(.data)
}


#' Check a tbl for a candidate foreign key constraint relationship
#'
#' Satisfying a foreign key constraint relationship would ensure that
#' `z <- left_join(x, y, by = by)` would result in all rows of `x` appear in `z`.
#' A foreign key constraint requires two things:
#'   1) that all the key values in x be present in y
#'   2) that key be pk_ish in y (e.g., distinct combinations)
#' Note: currently using `by` parameter as a character vector, but join verbs have
#' more flexible specification. When this is addressed, probably the default arg will be NULL.
#'   @examples
#'   x <- tibble(id = c(1, 2, 3))
#'   y <- tibble(id = c(1, 2, 3), val = c(100, 200, 300))
#'   by <- "id"
#'   fk_ish(x, y, "id")
fk_ish <- function(x, y, by = NA_character_,
                   na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  x_combos <- select(x, by)
  y_combos <- select(y, by)

  res <- if (isTRUE(all.equal(nrow(dplyr::setdiff(x_combos, y_combos)), 0)) & (pk_ish(y, by = by))) {TRUE} else {FALSE}
  res
}
