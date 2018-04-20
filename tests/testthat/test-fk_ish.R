context("test-fk_ish.R")

#### Unary key ----------------

#facts:
f_a <- tibble::tibble(key = c(1, 2, 3), val_x = c(10, 20, 30))
f_b <- tibble::tibble(key = c(1, 1, 1, 2, 3), val_x = c(10, 10, 20, 20, 30)) # repeat key
f_c <- tibble::tibble(key = c("b", "c", "a")) # chr key


#dims:
d_a <- tibble::tibble(key = c(1, 2, 3), val_y = c(100, 200, 300)) # exact
d_b <- tibble::tibble(key = c(3, 1, 2, 4), val_y = c(300, 100, 200, 400)) # more, diff order
d_c <- tibble::tibble(key = c(1, 2), val_y = c(100, 200)) # doesn't cover


test_that("fk_ish basic examples that should work do", {
  expect_true(fk_ish(f_a, d_a, "key"))
  expect_true(fk_ish(f_a, d_b, "key"))

  expect_true(fk_ish(f_b, d_a, "key"))
  expect_true(fk_ish(f_b, d_b, "key"))
})


test_that("fk_ish detects when dfy key doesn't cover key values", {
  expect_false(fk_ish(f_a, d_c, "key"))
  expect_false(fk_ish(f_b, d_c, "key"))
})

test_that("fk_ish errors when dfy key of different wrong type", {
  expect_error(fk_ish(f_c, d_a, "key"))
  expect_error(fk_ish(f_c, d_b, "key"))
})


#### Binary keys ---------------

f_d <- tibble::tibble(key1 = c(1, 1, 1, 2, 3), key2 = c("a", "b", "a", "a", "b"))

d_d <- tibble::tibble(key1 = c(1, 1, 2, 2, 3, 3), key2 = c("a", "b", "a", "b", "a", "b"),
                      y_val = c(100, 200, 300, 400, 500, 600))

test_that("fk_ish works with binary keys", {
  expect_true(fk_ish(f_d, d_d, by = c("key1", "key2")))
  #expect_true(fk_ish(f_d, d_d))
})


#### Invalid column names ------------

#Not currently testing. Erroring in underlying dplyr I bet.







