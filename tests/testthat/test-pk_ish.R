context("test-pk_ish.R")

dfx <- tibble::tibble(id = c(1, 2, 3), val = c(1, 1, 2))
dfy <- tibble::tibble(id = c(1, 1, 2), val = c(1, 2, 3))

test_that("pk_ish basic examples", {
  expect_true(pk_ish(dfx, "id"))
  expect_false(pk_ish(dfy, "id"))
})
