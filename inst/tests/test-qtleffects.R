
context("QTL effects")

test_that("estQTLeffects works for RIL by selfing", {

  data(grav)
  grav <- qtl::reduce2grid(qtl::calc.genoprob(grav[1:2,], step=5))

  pr <- qtl::pull.genoprob(grav, omit.first.prob=TRUE)

  pheno.col <- 1:5
  eff <- apply(pr, 2, function(a,b) lm(b ~ a)$coef[2,]/2, as.matrix(grav$pheno[,pheno.col]))
  eff <- lapply(as.data.frame(eff), as.matrix)

  expect_equivalent( estQTLeffects(grav, pheno.col=pheno.col, "effects"), eff )
  expect_equivalent( lapply(estQTLeffects(grav, pheno.col=pheno.col), function(a) matrix((a[,2]-a[,1])/2)), eff )

})

test_that("estQTLeffects works for X chromosome in F2", {

  data(fake.f2)
  fake.f2 <- qtl::calc.genoprob(fake.f2["X",])

  pr <- qtl::reviseXdata("f2", "full", getsex(fake.f2), prob=fake.f2$geno[["X"]]$prob,
                         cross.attr=attributes(fake.f2))

  pheno.col <- 1
  eff <- apply(pr, 2, function(a,b) lm(b ~ -1 + a)$coef, fake.f2$pheno[,1])
  eff <- lapply(as.data.frame(eff), function(a) matrix(a, nrow=1))

  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col), eff )

  eff.a <- lapply(eff, function(a) matrix(a[seq(2,length(a), by=2)] - a[seq(1,length(a), by=2)], nrow=1))
  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col, "effects"), eff.a )

  # treat as all males
  origsex <- fake.f2$pheno$sex
  fake.f2$pheno$sex <- rep(1, nind(fake.f2))

  pr <- qtl::reviseXdata("f2", "full", getsex(fake.f2), prob=fake.f2$geno[["X"]]$prob,
                         cross.attr=attributes(fake.f2))

  pheno.col <- 1
  eff <- apply(pr, 2, function(a,b) lm(b ~ -1 + a)$coef, fake.f2$pheno[,1])
  eff <- lapply(as.data.frame(eff), function(a) matrix(a, nrow=1))

  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col), eff )

  eff.a <- lapply(eff, function(a) matrix(a[seq(2,length(a), by=2)] - a[seq(1,length(a), by=2)], nrow=1))
  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col, "effects"), eff.a )


  # treat as all females
  fake.f2$pheno$sex <- rep(0, nind(fake.f2))

  pr <- qtl::reviseXdata("f2", "full", getsex(fake.f2), prob=fake.f2$geno[["X"]]$prob,
                         cross.attr=attributes(fake.f2))

  pheno.col <- 1
  eff <- apply(pr, 2, function(a,b) lm(b ~ -1 + a)$coef, fake.f2$pheno[,1])
  eff <- lapply(as.data.frame(eff), function(a) matrix(a, nrow=1))

  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col), eff )

  eff.a <- lapply(eff, function(a) matrix(a[seq(2,length(a), by=2)] - a[seq(1,length(a), by=2)], nrow=1))
  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col, "effects"), eff.a )


  # treat as all forward direction
  fake.f2$pheno$sex <- origsex
  fake.f2$pheno$pgm <- rep(1, nind(fake.f2))

  pr <- qtl::reviseXdata("f2", "full", getsex(fake.f2), prob=fake.f2$geno[["X"]]$prob,
                         cross.attr=attributes(fake.f2))

  pheno.col <- 1
  eff <- apply(pr, 2, function(a,b) lm(b ~ -1 + a)$coef, fake.f2$pheno[,1])
  eff <- lapply(as.data.frame(eff), function(a) matrix(a, nrow=1))

  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col), eff )

  eff.a <- lapply(eff, function(a) matrix(a[seq(2,length(a), by=2)] - a[seq(1,length(a), by=2)], nrow=1))
  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col, "effects"), eff.a )


  # treat as all reverse direction
  fake.f2$pheno$pgm <- rep(0, nind(fake.f2))

  pr <- qtl::reviseXdata("f2", "full", getsex(fake.f2), prob=fake.f2$geno[["X"]]$prob,
                         cross.attr=attributes(fake.f2))

  pheno.col <- 1
  eff <- apply(pr, 2, function(a,b) lm(b ~ -1 + a)$coef, fake.f2$pheno[,1])
  eff <- lapply(as.data.frame(eff), function(a) matrix(a, nrow=1))

  expect_equivalent( estQTLeffects(fake.f2, pheno.col=pheno.col), eff )

  eff.a <- lapply(eff, function(a) matrix(a[seq(2,length(a), by=2)] - a[seq(1,length(a), by=2)], nrow=1))

})

test_that("cbindQTLeffects works", {

  data(grav)
  grav <- qtl::reduce2grid(qtl::calc.genoprob(grav[1:2,], step=5))

  eff <- estQTLeffects(grav, phe=1:5)
  three_eff <- eff
  for(i in seq(along=eff))
    three_eff[[i]] <- cbind(eff[[i]], eff[[i]], eff[[i]])

  expect_equivalent( cbindQTLeffects(eff, eff, eff), three_eff )

})
