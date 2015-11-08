if(!testthat::skip_on_cran()) {

    files <- list.files("Rmdtest", pattern="\\.Rmd$")
    for(file in files)
        rmarkdown::render(file.path("Rmdtest", file))

}
