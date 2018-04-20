#' Left-join while checking that `.y` has primary key `by`
#'
#' Wraps `dplyr::left_join()` with extra checking and diagnostics.
#' @param x a data frame
#' @param y a data frame
#' @param by a character vector specification of variables to join by (with a foreign key relationship)
#' @export
#' @examples
#' if (require("Lahman")) {
#' batting_df <- tbl_df(Batting)
#' person_df <- tbl_df(Master)
#' uperson_df <- tbl_df(Master[!duplicated(Master$playerID), ])
#'
#' left_join_pk(batting_df, uperson_df)
#' left_join_pk(batting_df, person_df)
#' }
#' @export
left_join_fk <- function(x, y, by = NULL, copy = FALSE, suffix = c(".x", ".y"), ..., na_matches = pkgconfig::get_config("dplyr::na_matches")) {

  #ideally there would be some variable checks, but these are internal Rcpp in dplyr:
  #dplyr:::check_valid_names(tbl_vars(x))
  #dplyr:::check_valid_names(tbl_vars(y))
  by_y <- suppressMessages(dplyr::common_by(by, x, y)) %>% {.$y}

  if(fk_ish(x, y, by_y)) {
    left_join(x=x, y=y, by=by, copy=copy, suffix=suffix, na_matches=na_matches, ...)
  } else {
    stop("`by` variables must be `fk_ish` in `x`->`y`")
  }
}
