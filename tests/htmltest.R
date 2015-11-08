if(identical(Sys.getenv("NOT_CRAN"), "true")) {

    # move to htmltest subdirectory
    initialwd <- getwd()
    setwd("htmltest")

    # code setting up data to use in tests
    set.seed(69891250)
    library(qtl)
    library(qtlcharts)
    data(grav)
    grav$pheno <- grav$pheno[,seq(1, nphe(grav), by=5)]
    times <- as.numeric(sub("T", "", phenames(grav)))/60
    grav <- calc.genoprob(grav, step=1)
    out.hk <- scanone(grav, pheno.col=1:nphe(grav), method="hk")

    # run each .R file and create a link to the results html file
    files <- list.files(".", pattern="\\.R$")
    for(file in files) {
        cat("Sourcing ", file, "\n")
        source(file)
    }

    # move back to the initial working directory
    setwd(initialwd)

}
