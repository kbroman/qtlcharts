## ipleiotropy
## Karl W Broman

#' Tool to explore pleiotropy
#'
#' Creates an interactive graph of a scatterplot of two phenotypes,
#' plus optionally the LOD curves for the two traits along one
#' chromosome, with a slider for selecting the locations of two QTL
#' which are then indicated on the LOD curves and the corresponding
#' genotypes used to color the points in the scatterplot.
#'
#' @param cross (Optional) Object of class `"cross"`, see
#'     [qtl::read.cross()].
#' @param scanoneOutput (Optional) object of class `"scanone"`,
#'     as output from [qtl::scanone()].
#' @param pheno.col Vector indicating two phenotype column in cross
#'     object; either numeric or character strings (the latter being
#'     the phenotype column names).
#' @param lodcolumn Vector of two numeric values indicating LOD score
#'     columns to plot.
#' @param chr A single chromosome ID, as a character string.
#' @param interval A numeric vector of length 2, defining an interval
#'     that indicates what portion of the chromosome should be
#'     included.
#' @param fillgenoArgs List of named arguments to pass to
#'     [qtl::fill.geno()], if needed.
#' @param chartOpts A list of options for configuring the chart (see
#'     the coffeescript code). Each element must be named using the
#'     corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details [qtl::fill.geno()]
#' is used to impute missing genotypes. In this case, arguments to
#' [qtl::fill.geno()] are passed as a list, for example
#' `fillgenoArgs=list(method="argmax", error.prob=0.002,
#' map.function="c-f")`.
#'
#' Individual IDs (viewable when hovering over a point in the
#' scatterplot of the two phenotypes) are taken from the input
#' `cross` object, using the [qtl::getid()] function in
#' R/qtl.
#'
#' @keywords hplot
#' @seealso [iplotScanone()], [iplotMScanone()],
#'     [iplotPXG()]
#'
#' @examples
#' library(qtl)
#' data(fake.bc)
#' fake.bc <- calc.genoprob(fake.bc[5,], step=1) # select chr 5
#' out <- scanone(fake.bc, method="hk", pheno.col=1:2)
#' \donttest{
#' ipleiotropy(fake.bc, out)}
#'
#' \donttest{
#' # omit the LOD curves
#' ipleiotropy(fake.bc)}
#'
#' @importFrom qtl chrnames phenames nphe pull.map pull.markers markernames
#' @export
ipleiotropy <-
function(cross, scanoneOutput=NULL, pheno.col=1:2, lodcolumn=1:2,
         chr=NULL, interval=NULL,
         fillgenoArgs=NULL, chartOpts=NULL, digits=5)
{
    if(is.null(chr)) chr <- qtl::chrnames(cross)[1]
    if(length(chr) > 1) {
        chr <- chr[1]
        warning("chr should have length 1; using chr[1]")
    }
    if(!(chr %in% qtl::chrnames(cross)))
        stop("chromosome ", chr, " not found in cross.")

    if(length(pheno.col) != 2)
        stop("pheno.col should have length 2")
    if(is.character(pheno.col)) {
        m <- match(pheno.col, qtl::phenames(cross))
        if(any(is.na(m)))
           stop("Some phenotypes not found: ", paste(pheno.col[is.na(m)], collapse=" ,"))
        pheno.col <- m
    }
    if(any(is.na(pheno.col) | pheno.col < 1 | pheno.col > qtl::nphe(cross)))
       stop("pheno.col should be in {1, 2, ..., ", qtl::nphe(cross), "}")

    if(class(cross)[2] != "cross")
        stop('"cross" should have class "cross".')
    # omit individuals with missing phenotype and subset to chromosome
    cross <- subset(cross, ind=rowSums(is.na(cross$pheno[,pheno.col]))==0, chr=chr)

    if(!is.null(interval)) {
        if(length(interval) != 2)
            stop("interval should have length 2")

        # subset markers to the interval
        m <- qtl::pull.map(cross)[[1]]
        cross <- qtl::pull.markers(cross, names(m)[m >= interval[1] & m <= interval[2]])
    }

    if(!is.null(scanoneOutput)) {
        scanoneOutput <- subset(scanoneOutput, chr=chr)
        if(!any(class(scanoneOutput) == "scanone"))
            stop('"scanoneOutput" should have class "scanone".')

        if(length(lodcolumn) > 2) {
            stop("lodcolumn should have length 2; using the first two values")
            lodcolumn <- lodcolumn[1:2]
        }
        if(length(lodcolumn) < 2)
            stop("lodcolumn should have length 2")

        if(any(lodcolumn < 1 | lodcolumn > ncol(scanoneOutput)-2))
            stop('lodcolumns must be between 1 and ', ncol(scanoneOutput)-2)

        scanoneOutput <- scanoneOutput[,c(1,2,lodcolumn+2), drop=FALSE]

        # subset markers to the interval
        if(!is.null(interval))
            scanoneOutput <- scanoneOutput[scanoneOutput[,2] >= interval[1] & scanoneOutput[,2] <= interval[2],,drop=FALSE]

        scanone_list <- convert_scanone(scanoneOutput, lod_as_matrix=FALSE) # this'll just take the first set of lod scores
        scanone_list$lod2 <- scanoneOutput[,4] # second set of LOD curves

        # check that scanoneOutput and cross match
        if(qtl::nmar(cross) != sum(scanone_list$marker != ""))
            stop("Mismatch in number of markers: ", qtl::nmar(cross), " vs ", sum(scanone_list$marker != ""))
        if(!all(qtl::markernames(cross) == scanone_list$marker[scanone_list$marker != ""]))
            stop("Mismatch in marker names")
    }
    else {
        m <- pull.map(cross)[[1]]
        scanone_list <- list(chr=rep(chr, length(m)),
                             pos=stats::setNames(m, NULL),
                             lod=NULL,
                             marker=names(m),
                             chrname=chr,
                             lodname=NULL)
    }

    pxg_list <- convert_pxg(cross, pheno.col[1], fillgenoArgs=fillgenoArgs)
    pxg_list$pheno1 <- pxg_list$pheno
    pxg_list$pheno2 <- cross$pheno[,pheno.col[2]]
    pxg_list$pheno <- NULL
    pxg_list$phenames <- colnames(cross$pheno)[pheno.col]

    # simplify grabbing the genonames for this case
    pxg_list$genonames <- pxg_list$genonames[[1]]

    defaultAspect <- ifelse(is.null(scanoneOutput), 1, 2) # width/height
    browsersize <- getPlotSize(defaultAspect)

    # add phenotype names to chartOpts
    chartOpts <- add2chartOpts(chartOpts, phe_labels=pxg_list$phenames)

    x <- list(scanone_data=scanone_list, pxg_data=pxg_list,
              chartOpts=chartOpts)

    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("ipleiotropy", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize$width,
                                  browser.defaultHeight=browsersize$height,
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=1000/defaultAspect
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
ipleiotropy_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "ipleiotropy", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
ipleiotropy_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, ipleiotropy_output, env, quoted=TRUE)
}
