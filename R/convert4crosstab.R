# Convert genotype data for use with crosstab panel
#
# Convert genotype data for use with crosstab panel
#   - geno = list with markers as keys and genotypes as numeric values 0, 1, 2, ...
#   - chrtype = list with markers as keys and "A" or "X" as values
#   - genocat = list with two values: "A" and "X", containing vectors of genotype categories
#
# @param cross R/qtl cross object; see help file for \code{\link[qtl]{read.cross}}
# @param chr Optional set of chromosomes to select
convert4crosstab <-
function(cross, chr)
{
    if(!missing(chr)) cross <- cross[chr,]

    crosstype <- class(cross)[1] # f2, bc, etc.
    mnames <- qtl::markernames(cross)

    # chr type for each marker ("A" or "X")
    chrtype <- rep(sapply(cross$geno, class), qtl::nmar(cross))
    names(chrtype) <- mnames

    # for conversion with X chr
    cross.attr <- attributes(cross)
    sexpgm <- qtl::getsex(cross)

    # names of the genotype categories; making missing values the last category
    genocat <- vector("list", 0)
    if(any(chrtype == "A"))
        genocat$A <- c(qtl::getgenonames(crosstype, "A", cross.attr=cross.attr), "N/A")
    if(any(chrtype == "X"))
        genocat$X <- c(qtl::getgenonames(crosstype, "X", expandX = "standard", sexpgm=sexpgm,
                                         cross.attr=attributes(cross)), "N/A")

    geno <- qtl::pull.geno(cross)
    if(any(chrtype=="A")) {
        genoA <- geno[,chrtype=="A"]
        # replace missing values with number for last category
        genoA[is.na(genoA)] <- length(genocat$A)
        # check for unexpected codes
        if(any(genoA < 1 | genoA > length(genocat$A))) {
            badmar <- apply(genoA, 2, function(a) any(a < 1 | a > length(genocat$A)))
            badmar <- names(badmar)[badmar]
            warning("Unexpected genotype codes for markers ", paste(badmar, collapse=" "))
            genoA[genoA < 1 | genoA > length(genocat$A)] <- length(genocat$A)
        }
        geno[,chrtype=="A"] <- genoA
    }
    if(any(chrtype=="X")) {
        genoX <- geno[,chrtype=="X"]
        # convert from 1/2 to numbers for like AA/AB/BB/AY/BY
        genoX <- qtl::reviseXdata(crosstype, expandX="standard", sexpgm=sexpgm, geno=genoX,
                                  cross.attr=cross.attr)
        # replace missing values with number for last category
        genoX[is.na(genoX)] <- length(genocat$X)
        # check for unexpected codes
        if(any(genoX < 1 | genoX > length(genocat$X))) {
            badmar <- apply(genoX, 2, function(a) any(a < 1 | a > length(genocat$X)))
            badmar <- names(badmar)[badmar]
            warning("Unexpected genotype codes for markers ", paste(badmar, collapse=" "))
            genoX[genoX < 1 | genoX > length(genocat$X)] <- length(genocat$X)
        }
        geno[,chrtype=="X"] <- genoX
    }
    # make it a list, and convert to 0, 1, 2, ...
    geno <- as.list(as.data.frame(geno - 1))

    list(geno=geno, genocat=genocat, chrtype=chrtype)
}
