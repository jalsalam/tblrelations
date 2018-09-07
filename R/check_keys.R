#' Check a tbl for a candidate primary key
#'
#' @param .data a data frame
#' @param by a character vector specifying a candidate primary to (e.g., to check)
#' @return boolean whether `x` has primary key `by`
#' A primary key of a table is a column (or set of columns) which is distinct.
#' Should error if the specified `by` is not present in .data
#'@examples
#'dfx <- tibble::tibble(id = c(1, 2, 3), val = c(1, 1, 2))
#'pk_ish(dfx, "id")
#'dfy <- tibble::tibble(id = c(1, 1, 2), val = c(1, 2, 3))
#'pk_ish(dfy, "id")
#' @export
pk_ish <- function(.data, by = NULL,
                   na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  id_all_rows <- nrow(dplyr::distinct(dplyr::select(.data, by))) == nrow(.data)

  #TODO: check subsets
  #no_subsets_id_all_rows <-

  id_all_rows
}

#' @export
assert_pk_ish <- function(.data, by = NULL,
                          na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  data_name <- rlang::expr_text(rlang::enexpr(.data))

  if (!nrow(dplyr::distinct(dplyr::select(.data, by))) == nrow(.data)) {
    by_names <- glue::glue_collapse(by, sep = "`, `", last = "` and `")
    stop(glue::glue("fields `{by_names}` are not `pk_ish` in `{data_name}` because they do not uniquely identify all rows"), call. = FALSE)
  }

  #TODO: no_subsets_id_all_rows?

  invisible(.data)
}

# assert_pk_ish(mtcars, by = c("mpg", "cyl"))

#' Check a tbl for a candidate foreign key constraint relationship
#'
#' @param x data frame
#' @param y data frame with foreign key relationship to x
#' @param by character vector of key relationship, with semantics of dplyr join `by` parameters.
#' @return boolean whether `by` variables could specify a foreign key relationship `x`->`y`
#'
#' Satisfying a foreign key constraint relationship would ensure that
#' `z <- dplyr::left_join(x, y, by = by)` would result in all rows of `x` appear in `z`.
#' A foreign key constraint requires two things:
#'   1) that all the key values in x be present in y
#'   2) that key be pk_ish in y (e.g., distinct combinations)
#' Note: errors if the specified `by` is not present
#' Note 2: goal is to have a more flexible variable specification that can use `vars()` type spec (at least for same-named-key..)
#' Maybe the default arg should be NULL, not NA_character_ ?
#'
#' @examples
#' x <- tibble(id = c(1, 2, 3))
#' y <- tibble(id = c(1, 2, 3), val = c(100, 200, 300))
#' by <- "id"
#' fk_ish(x, y, "id")
#' x <- dplyr::band_members
#' y <- dplyr::band_instruments2
#' by <- c("name" = "artist")
#' library(nycflights13)
#' x <- flights
#' y <- airports
#' by <- c("dest" = "faa")
#' @export
fk_ish <- function(x, y, by = NA_character_,
                   na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  by <- dplyr::common_by(by, x, y)

  x_combos <- dplyr::select(x, by$x)
  y_combos <- dplyr::select(y, by$y)
  y_combos_x <- y_combos %>% purrr::set_names(by$x) #version of y with names from x

  res <- if (isTRUE(all.equal(nrow(dplyr::setdiff(x_combos, y_combos_x)), 0)) & (pk_ish(y, by = by$y))) {TRUE} else {FALSE}
  res
}

#' @export
assert_fk_ish <- function(x, y, by = NA_character_,
                          na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  by <- dplyr::common_by(by, x, y)

  x_combos <- dplyr::select(x, by$x)
  y_combos <- dplyr::select(y, by$y)
  y_combos_x <- y_combos %>% purrr::set_names(by$x) #version of y with names from x

  if (! isTRUE(all.equal(nrow(dplyr::setdiff(x_combos, y_combos_x)), 0))) {
    stop(glue::glue("Values of {by} in `x` are not in `y`"), call. = FALSE)
  }

  assert_pk_ish(y, by = by$y)

  invisible(x)
}
