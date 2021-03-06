% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ipleiotropy.R
\name{ipleiotropy}
\alias{ipleiotropy}
\title{Tool to explore pleiotropy}
\usage{
ipleiotropy(
  cross,
  scanoneOutput = NULL,
  pheno.col = 1:2,
  lodcolumn = 1:2,
  chr = NULL,
  interval = NULL,
  fillgenoArgs = NULL,
  chartOpts = NULL,
  digits = 5
)
}
\arguments{
\item{cross}{(Optional) Object of class `"cross"`, see
[qtl::read.cross()].}

\item{scanoneOutput}{(Optional) object of class `"scanone"`,
as output from [qtl::scanone()].}

\item{pheno.col}{Vector indicating two phenotype column in cross
object; either numeric or character strings (the latter being
the phenotype column names).}

\item{lodcolumn}{Vector of two numeric values indicating LOD score
columns to plot.}

\item{chr}{A single chromosome ID, as a character string.}

\item{interval}{A numeric vector of length 2, defining an interval
that indicates what portion of the chromosome should be
included.}

\item{fillgenoArgs}{List of named arguments to pass to
[qtl::fill.geno()], if needed.}

\item{chartOpts}{A list of options for configuring the chart (see
the coffeescript code). Each element must be named using the
corresponding option.}

\item{digits}{Round data to this number of significant digits
before passing to the chart function. (Use NULL to not round.)}
}
\value{
An object of class `htmlwidget` that will
intelligently print itself into HTML in a variety of contexts
including the R console, within R Markdown documents, and within
Shiny output bindings.
}
\description{
Creates an interactive graph of a scatterplot of two phenotypes,
plus optionally the LOD curves for the two traits along one
chromosome, with a slider for selecting the locations of two QTL
which are then indicated on the LOD curves and the corresponding
genotypes used to color the points in the scatterplot.
}
\details{
[qtl::fill.geno()]
is used to impute missing genotypes. In this case, arguments to
[qtl::fill.geno()] are passed as a list, for example
`fillgenoArgs=list(method="argmax", error.prob=0.002,
map.function="c-f")`.

Individual IDs (viewable when hovering over a point in the
scatterplot of the two phenotypes) are taken from the input
`cross` object, using the [qtl::getid()] function in
R/qtl.
}
\examples{
library(qtl)
data(fake.bc)
fake.bc <- calc.genoprob(fake.bc[5,], step=1) # select chr 5
out <- scanone(fake.bc, method="hk", pheno.col=1:2)
\donttest{
ipleiotropy(fake.bc, out)}

\donttest{
# omit the LOD curves
ipleiotropy(fake.bc)}

}
\seealso{
[iplotScanone()], [iplotMScanone()],
    [iplotPXG()]
}
\keyword{hplot}
