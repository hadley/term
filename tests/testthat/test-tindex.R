context("tindex")

test_that("tindex", {
  term <- as.term(c("alpha[1]", "alpha[2]", "beta[1,1]", "beta[2,1]",
                    "beta[1,2]", "sigma", "beta[2,2]"))
  expect_identical(tindex(term),
                   list(`alpha[1]` = 1L, `alpha[2]` = 2L, 
                        `beta[1,1]` = c(1L, 1L), `beta[2,1]` = 2:1, 
                        `beta[1,2]` = 1:2, sigma = 1L, 
                        `beta[2,2]` = c(2L,  2L)))
  
  expect_identical(tindex(c("alpha[1]", "alpha[2]", "beta[1,1]", "beta[2,1]",
                    "beta[1,2]", "sigma", "beta[2,2]")),
                   list(`alpha[1]` = 1L, `alpha[2]` = 2L, 
                        `beta[1,1]` = c(1L, 1L), `beta[2,1]` = 2:1, 
                        `beta[1,2]` = 1:2, sigma = 1L, 
                        `beta[2,2]` = c(2L,  2L)))
})