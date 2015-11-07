# make vignette index

# Find Rmd files
Rmdfiles <- list.files(".", pattern=".Rmd$")

# create data frame to contain result
n <- length(Rmdfiles)
vignettes <- data.frame(File=Rmdfiles,
                        Title=rep("", n),
                        PDF=sub("\\.Rmd", ".html", Rmdfiles),
                        R=sub("\\.Rmd", ".html", Rmdfiles),
                        Depends=rep("", n),
                        Keywords=rep("", n),
                        stringsAsFactors=FALSE)

# find titles
for(i in seq(along=Rmdfiles)) {
    file <- Rmdfiles[i]
    lines <- readLines(file, n=20)
    indexline <- grep("VignetteIndexEntry\\{.*\\}", lines, value=TRUE)
    index_entry <- regmatches(indexline, regexpr("\\{.*\\}", indexline))
    vignettes[i,"Title"] <- substr(index_entry, 2, nchar(index_entry)-1)
}

# save file
saveRDS(vignettes, "../build/vignette.rds")
