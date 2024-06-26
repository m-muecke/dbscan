test_that("FOSC", {
  data("iris")

  ## FOSC expects an hclust object
  expect_error(extractFOSC(iris))

  x <- iris[, 1:4]
  x_sl <- hclust(dist(x), "single")

  ## Should return augmented hclust object and cluster assignments
  expect_length(extractFOSC(x_sl), 2)
  res <- extractFOSC(x_sl)
  expect_identical(res$hc$method, "single (w/ stability-based extraction)")

  ## Constraint-checking
  expect_error(extractFOSC(x_sl, constraints = c("1" = 2)))

  ## Matrix inputs must be nxn
  expect_error(extractFOSC(x_sl, constraints = matrix(c(1, 2), nrow=1)))

  ## Matrix or vector constraints must be in c(-1, 0, 1)
  expect_error(extractFOSC(x_sl, constraints = matrix(-2, nrow=nrow(x), ncol=nrow(x))))

  ## Valid constraints
  expect_warning(extractFOSC(x_sl, constraints = matrix(1, nrow=nrow(x), ncol=nrow(x))))
  expect_silent(extractFOSC(x_sl, constraints = list("1" = 2, "2" = 1)))
  expect_silent(extractFOSC(x_sl, constraints = ifelse(dist(x) > 2, -1, 1)))

  ## Constraints should be symmetric, but symmetry test is only done if specified. Asymmetric
  ## constraints through warning, but proceeds with manual warning
  expect_warning(extractFOSC(x_sl, constraints = list("1" = 2), validate_constraints = TRUE))

  ## Make sure that's whats returned
  res <- extractFOSC(x_sl)
  expect_type(res$cluster, "integer")
  expect_s3_class(res$hc, "hclust")

  ## Test 'Optimal' Clustering using only positive constraints
  set <- which(iris$Species == "setosa")
  ver <- which(iris$Species == "versicolor")
  vir <- which(iris$Species == "virginica")
  il_constraints <- structure(list(set[-1], ver[-1], vir[-1]), names = as.character(c(set[1], ver[1], vir[1])))
  res <- extractFOSC(x_sl, il_constraints)

  ## Positive-only constraints should link to best unsupervised solution
  expect_identical(table(res$cluster, dnn = NULL), as.table(c(`1` = 50L, `2` = 100L)))
  expect_identical(res$hc$method, "single (w/ constraint-based extraction)")

  ## Test negative constraints
  set2 <- c(il_constraints[[as.character(set[1])]], -unlist(il_constraints[as.character(c(ver[1], vir[1]))], use.names = FALSE))
  ver2 <- c(il_constraints[[as.character(ver[1])]], -unlist(il_constraints[as.character(c(set[1], vir[1]))], use.names = FALSE))
  vir2 <- c(il_constraints[[as.character(vir[1])]], -unlist(il_constraints[as.character(c(set[1], ver[1]))], use.names = FALSE))
  il_constraints2 <- structure(list(set2, ver2, vir2), names = as.character(c(set[1], ver[1], vir[1])))
  res2 <- extractFOSC(x_sl, constraints = il_constraints2)

  ## Positive and Negative should produce a different solution
  expect_false(all(res$cluster == res2$cluster))
  expect_identical(res2$hc$method, "single (w/ constraint-based extraction)")

  ## Test minPts parameters
  expect_error(extractFOSC(x_sl, constraints = il_constraints2, minPts = 1))
  expect_silent(extractFOSC(x_sl, constraints = il_constraints2, minPts = 5))

  ## Test alpha parameter
  expect_silent(extractFOSC(x_sl, constraints = il_constraints2, alpha = 0.5))
  expect_error(extractFOSC(x_sl, constraints = il_constraints2, alpha = 1.5))
  res3 <- extractFOSC(x_sl, constraints = il_constraints2, alpha = 0.5)
  expect_identical(res3$hc$method, "single (w/ mixed-objective extraction)")

  ## Test unstable pruning
  expect_silent(extractFOSC(x_sl, constraints = il_constraints2, prune_unstable = TRUE))
})
