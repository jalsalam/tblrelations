context("test-left_join_fk.R")

#facts:
f_a <- tibble::tibble(key = c(1, 2, 3), val_x = c(10, 20, 30))
f_b <- tibble::tibble(key = c(1, 1, 1, 2, 3), val_x = c(10, 10, 20, 20, 30)) # repeat key
f_c <- tibble::tibble(key = c("b", "c", "a")) # chr key


#dims:
d_a <- tibble::tibble(key = c(1, 2, 3), val_y = c(100, 200, 300)) # exact
d_b <- tibble::tibble(key = c(3, 1, 2, 4), val_y = c(300, 100, 200, 400)) # more, diff order
d_c <- tibble::tibble(key = c(1, 2), val_y = c(100, 200)) # doesn't cover


test_that("basic fk-joins work", {
  j1 <- left_join_fk(f_a, d_a)
  j2 <- left_join_fk(f_b, d_a)

  expect_equal(names(j1), c("key", "val_x", "val_y"))
  expect_equal(names(j2), c("key", "val_x", "val_y"))

  expect_equal(j1$val_y, c(100, 200, 300))
  expect_equal(j2$val_y, c(100, 100, 100, 200, 300))
})
