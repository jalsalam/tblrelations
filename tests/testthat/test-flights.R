context("test-flights")

library(nycflights13)


test_that("pk_ish handles basic true cases", {
  expect_true(         pk_ish(airports, by = "faa"))
  expect_silent(assert_pk_ish(airports, by = "faa"))

  expect_true(         pk_ish(airlines, "carrier"))
  expect_silent(assert_pk_ish(airlines, "carrier"))
})

test_that("pk_ish handles basic false cases", {
  expect_false(       pk_ish(planes, by = "model"))
  expect_error(assert_pk_ish(planes, by = "model"))
})

test_that("pk_ish handles multiple key true cases", {
  expect_true(         pk_ish(flights, by = c("year", "month", "day", "hour", "carrier", "flight")))
  expect_silent(assert_pk_ish(flights, by = c("year", "month", "day", "hour", "carrier", "flight")))

  expect_true(         pk_ish(flights, c("year", "month", "day", "origin", "carrier", "flight")))
  expect_silent(assert_pk_ish(flights, c("year", "month", "day", "origin", "carrier", "flight")))
})

test_that("pk_ish handles multiple key false cases", {
  expect_false(       pk_ish(flights, by = c("year", "month", "day", "flight")))
  expect_error(assert_pk_ish(flights, by = c("year", "month", "day", "flight")))

  expect_false(       pk_ish(flights, c("year", "month", "day", "carrier", "flight")))
  expect_error(assert_pk_ish(flights, c("year", "month", "day", "carrier", "flight")))
})


test_that("fk_ish handles basic true case", {
  expect_true(         fk_ish(flights, airlines, by = "carrier"))
  expect_silent(assert_fk_ish(flights, airlines, by = "carrier"))
})

test_that("fk_ish handles basic false case - no match", {
  expect_false(fk_ish(flights, airports, "faa"))
  expect_error(assert_fk_ish(flights, airports, "faa"))
})

test_that('fk_ish handles `by = c("x.by" = "y.by"', {
  expect_true(         fk_ish(flights, airports, by = c("origin" = "faa")))
  expect_silent(assert_fk_ish(flights, airports, by = c("origin" = "faa")))

  expect_true(         fk_ish(flights, airports, c("dest" = "faa")))
  expect_silent(assert_fk_ish(flights, airports, c("dest" = "faa")))
})
