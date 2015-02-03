## iplotScantwo
## Karl W Broman

#' Interactive plot of 2d genome scan
#'
#' Creates an interactive plot of the results of
#' \code{\link[qtl]{scantwo}}, for a two-dimensional, two-QTL genome
#' scan.
#'
#' @param scantwoOutput Output of \code{\link[qtl]{scantwo}}
#' @param cross (Optional) Object of class \code{"cross"}, see
#'   \code{\link[qtl]{read.cross}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot.
#' @param pheno.col (Optional) Phenotype column in cross object.
#' @param chr (Optional) Optional vector indicating the chromosomes
#'   for which LOD scores should be calculated. This should be a vector
#'   of character strings referring to chromosomes by name; numeric
#'   values are converted to strings. Refer to chromosomes with a
#'   preceding - to have all chromosomes but those considered. A logical
#'   (TRUE/FALSE) vector may also be used.
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details The estimated QTL effects, and the genotypes in the
#' phenotype x genotype plot, in the right-hand panels, are derived
#' following a single imputation to fill in missing data, and so are a
#' bit crude.
#'
#' Note that the usual \code{height} and \code{width} options in
#' \code{chartOpts} are ignored here. Instead, you may provide
#' \code{pixelPerCell} (number of pixels per cell in the heat map),
#' \code{chrGap} (gaps between chr in heat map), \code{wright} (width
#' in pixels of right panels), and \code{hbot} (height in pixels of
#' each of the lower panels)
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}
#'
#' @examples
#' library(qtl)
#' data(fake.f2)
#' \dontshow{fake.f2 <- fake.f2[c(1, 13, "X"),]}
#' fake.f2 <- calc.genoprob(fake.f2, step=5)
#' out <- scantwo(fake.f2, method="hk", verbose=FALSE)
#' \donttest{
#' iplotScantwo(out, fake.f2)}
#'
#' @export
iplotScantwo <-
function(scantwoOutput, cross, lodcolumn=1, pheno.col=1, chr,
         chartOpts=NULL)
{
    if(!any(class(scantwoOutput) == "scantwo"))
        stop('"scantwoOutput" should have class "scantwo".')

    if(!missing(chr) && !is.null(chr)) {
        scantwoOutput <- subset(scantwoOutput, chr=chr)
        if(!missing(cross) && !is.null(cross)) cross <- subset(cross, chr=chr)
    }

    if(length(lodcolumn) > 1) {
        lodcolumn <- lodcolumn[1]
        warning("lodcolumn should have length 1; using first value")
    }
    if(length(dim(scantwoOutput)) < 3) {
        if(lodcolumn != 1) {
            warning("scantwoOutput contains just one set of lod scores; using lodcolumn=1")
            lodcolumn <- 1
        }
    }
    else {
        d <- dim(scantwoOutput)[3]
        if(lodcolumn < 1 || lodcolumn > 3)
            stop("lodcolumn should be between 1 and ", d)
        scantwoOutput$lod <- scantwoOutput$lod[,,lodcolumn]
    }

    if(length(pheno.col) > 1) {
        pheno.col <- pheno.col[1]
        warning("pheno.col should have length 1; using first value")
    }
    if(!missing(cross) && !is.null(cross))
        pheno <- qtl::pull.pheno(cross, pheno.col)
    else cross <- pheno <- NULL

    scantwo_list <- data4iplotScantwo(scantwoOutput)
    phenogeno_list <- cross4iplotScantwo(scantwoOutput, cross, pheno)

    htmlwidgets::createWidget("iplotScantwo",
                              list(scantwo_data=scantwo_list,
                                   phenogeno_data=phenogeno_list,
                                   chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

#' @export
iplotScantwo_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotScantwo", width, height, package="qtlcharts")
}
#' @export
iplotScantwo_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotScantwo_output, env, quoted=TRUE)
}


# convert scantwo output to JSON format
data4iplotScantwo <-
    function(scantwoOutput, digits=4)
{
    lod <- scantwoOutput$lod
    map <- scantwoOutput$map
    lod <- lod[map$eq.spacing==1, map$eq.spacing==1,drop=FALSE]
    map <- map[map$eq.spacing==1,,drop=FALSE]

    lodv1 <- get_lodv1(lod, map, scantwoOutput$scanoneX)

    chr <- as.character(map$chr)
    chrnam <- unique(chr)
    n.mar <- tapply(chr, chr, length)[chrnam]

    labels <- revisePmarNames(rownames(map))

    dimnames(lod) <- NULL
    dimnames(lodv1) <- NULL
    list(lod=lod, lodv1=lodv1,
         nmar=n.mar, chrnames=chrnam,
         labels=labels, chr=chr, pos=map$pos)
}


# convert pseudomarker names, e.g. "c5.loc25" -> "5@25"
revisePmarNames <-
    function(labels)
{
    wh.pmar <- grep("^c.+\\.loc-*[0-9]+", labels)
    pmar <- labels[wh.pmar]
    pmar.spl <- strsplit(pmar, "\\.loc")
    pmar_chr <- vapply(pmar.spl, "[", "", 1)
    pmar_chr <- substr(pmar_chr, 2, nchar(pmar_chr))
    pmar_pos <- vapply(pmar.spl, "[", "", 2)
    labels[wh.pmar] <- paste0(pmar_chr, "@", pmar_pos)
    labels
 }


# get fv1/av1 LOD scores from the full/add LOD scores
get_lodv1 <-
    function(lod, map, scanoneX=NULL)
{
    thechr <- map$chr
    uchr <- unique(thechr)
    thechr <- factor(as.character(thechr), levels=as.character(uchr))
    uchr <- factor(as.character(uchr), levels=levels(thechr))
    xchr <- tapply(map$xchr, thechr, function(a) a[1])

    # maximum 1-d LOD score on each chromosome
    maxo <- tapply(diag(lod), thechr, max, na.rm=TRUE)
    if(any(xchr) && !is.null(scanoneX)) {
        maxox <- tapply(scanoneX, thechr, max, na.rm=TRUE)
        maxo[xchr] <- maxox[xchr]
    }

    # subtract max(i,j) from each chr pair (i,j)
    n.chr <- length(uchr)
    for(i in 1:n.chr) {
        pi <- which(thechr==uchr[i])
        for(j in 1:n.chr) {
            pj <- which(thechr==uchr[j])
            lod[pj,pi] <- lod[pj,pi] - max(maxo[c(i,j)])
        }
    }
    # if negative, replace with 0
    lod[is.na(lod) | lod < 0] <- 0

    lod
}


# convert genotype/phenotype information to JSON format
cross4iplotScantwo <-
    function(scantwoOutput, cross, pheno, digits=4)
{
    # if no cross or phenotype, just return null
    if(missing(cross) || is.null(cross) || missing(pheno) || is.null(pheno))
        return("null")

    # pull out locations of LOD calculations, on grid
    map <- scantwoOutput$map
    map <- map[map$eq.spacing==1,,drop=FALSE]

    # local function to get pseudomarker names
    getPmarNames <-
        function(cross)
        {
            nam <- lapply(cross$geno, function(a) colnames(a$draws))
            chrnam <- names(cross$geno)
            for(i in seq(along=nam)) {
                g <- grep("^loc", nam[[i]])
                if(length(g) > 0)
                    nam[[i]][g] <- paste0("c", chrnam[i], ".", nam[[i]][g])
            }
            nam
        }

    # attempt to get imputations at pseudomarker locations in scantwo object
    needImp <- TRUE
    if("draws" %in% names(cross$geno[[1]])) { # contains imputations; attempt to use these
        nam <- getPmarNames(cross)
        if(all(rownames(scantwoOutput) %in% unlist(nam))) { # same pseudomarkers as in scantwo
            needImp <- FALSE
        }
    }
    if(needImp) {
        if("prob" %in% names(cross$geno[[1]])) { # contains genotype probabilities
            # do imputation with positions in calc.genoprob
            cross <- qtl::sim.geno(cross,
                                   error.prob=attr(cross$geno[[1]]$prob, "error.prob"),
                                   step=attr(cross$geno[[1]]$prob, "step"),
                                   off.end=attr(cross$geno[[1]]$prob, "off.end"),
                                   map.function=attr(cross$geno[[1]]$prob, "map.function"),
                                   stepwidth=attr(cross$geno[[1]]$prob, "stepwidth"),
                                   n.draws=1)

            nam <- getPmarNames(cross)
            if(all(rownames(scantwoOutput) %in% unlist(nam))) {
                needImp <- FALSE
            }
        }

        if(needImp) # give up
            stop('cross object needs imputed genotypes at pseudomarkers\n',
                 'Run sim.geno with step/stepwidth as used for scantwo')
    }

    # X chr imputations: 1/2 -> AA/AB/BB/AY/BY
    crosstype <- class(cross)[1]
    chrtype <- sapply(cross$geno, class)
    sexpgm <- qtl::getsex(cross)
    cross.attr <- attributes(cross)
    if(crosstype %in% c("f2", "bc", "bcsft") && any(chrtype=="X")) {
        for(i in which(chrtype=="X")) {
            cross$geno[[i]]$draws <- qtl::reviseXdata(crosstype, "full", sexpgm,
                                                      draws=cross$geno[[i]]$draws,
                                                      cross.attr=cross.attr)
        }
    }

    # pull out imputed genotypes as a list
    geno <- vector("list", nrow(map))
    names(geno) <- rownames(map)
    for(i in seq(along=cross$geno)) {
        m <- which(nam[[i]] %in% rownames(map))
        for(j in m)
            geno[[nam[[i]][j]]] <- cross$geno[[i]]$draws[,j,1]
    }
    names(geno) <- revisePmarNames(rownames(map))

    # names of the possible genotypes
    genonames <- vector("list", length(cross$geno))
    names(genonames) <- names(cross$geno)
    for(i in seq(along=genonames))
        genonames[[i]] <- qtl::getgenonames(crosstype, class(cross$geno[[i]]),
                                            "full", sexpgm, cross.attr)

    # chr for each marker
    chr <- as.character(map$chr)
    names(chr) <- names(geno) # the revised pseudomarker names

    # individual IDs
    indID <- qtl::getid(cross)
    if(is.null(indID)) indID <- 1:qtl::nind(cross)

    list(geno=geno, chr=as.list(chr), genonames=genonames, pheno=pheno, indID=indID)
}
