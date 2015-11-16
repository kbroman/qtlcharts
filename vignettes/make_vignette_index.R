# make vignette index

# Find Rmd files
Rmdfiles <- list.files(".", pattern=".Rmd$")

# create data frame to contain result
n <- length(Rmdfiles)
vignettes <- data.frame(File=Rmdfiles,
                        Title=rep("", n),
                        PDF=sub("\\.Rmd", ".html", Rmdfiles),
                        R=sub("\\.Rmd", ".R", Rmdfiles),
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

# drop empty .R files
for(i in 1:nrow(vignettes)) {
    if(paste(readLines(file.path("..", "inst", "doc", vignettes$R[i])), collapse="")=="")
        vignettes$R[i] <- ""
}

# reorder them, putting userGuide etc first
putFirst <- c("userGuide.Rmd", "develGuide.Rmd", "Rmarkdown.Rmd")
o <- match(putFirst, vignettes$File)
vignettes <- vignettes[c(o, which(!(vignettes$File %in% putFirst))),]

# save file
saveRDS(vignettes, "../build/vignette.rds")
