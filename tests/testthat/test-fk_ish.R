context("test-fk_ish.R")

dfx <- tibble::tibble(id = c(1, 2, 3))
dfy <- tibble::tibble(id = c(1, 1, 2), val = c(100, 200, 300))
dfz <- tibble::tibble(id = c(1, 2, 3), val = c(100, 200, 300))

test_that("fk_ish basic examples", {
  expect_false(fk_ish(dfx, dfy, "id"))
  expect_true(fk_ish(dfx, dfz, "id"))
})
