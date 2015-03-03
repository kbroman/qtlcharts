files <- list.files("Rmdtest", pattern="\\.Rmd$")
for(file in files)
    rmarkdown::render(paste0("Rmdtest/", file))
