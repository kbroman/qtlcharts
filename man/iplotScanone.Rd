\name{iplotScanone}
\alias{iplotScanone}
\title{Interactive LOD curve}
\usage{
iplotScanone(scanoneOutput, lodcolumn = 1, cross, pheno.col = 1, file,
  onefile = FALSE, openfile = TRUE, title = "", method = c("imp",
  "argmax", "no_dbl_XO"), error.prob = 0.0001, map.function = c("haldane",
  "kosambi", "c-f", "morgan"), ...)
}
\arguments{
  \item{scanoneOutput}{Object of class \code{"scanone"}, as
  output from \code{\link[qtl]{scanone}}.}

  \item{lodcolumn}{Numeric value indicating LOD score
  column to plot.}

  \item{cross}{(Optional) Object of class \code{"cross"},
  see \code{\link[qtl]{read.cross}}.}

  \item{pheno.col}{(Optional) Phenotype column in cross
  object.}

  \item{file}{Optional character vector with file to
  contain the output}

  \item{onefile}{If TRUE, have output file contain all
  necessary javascript/css code}

  \item{openfile}{If TRUE, open the plot in the default web
  browser}

  \item{title}{Character string with title for plot}

  \item{method}{Method for imputing missing genotypes, if
  \code{\link[qtl]{fill.geno}} is needed.}

  \item{error.prob}{Genotyping error probability used in
  imputing missing genotypes, if
  \code{\link[qtl]{fill.geno}} is needed.}

  \item{map.function}{Map function used in imputing missing
  genotypes, if \code{\link[qtl]{fill.geno}} is needed.}

  \item{\dots}{Additional arguments passed to the
  \code{\link[RJSONIO]{toJSON}} function #'}
}
\value{
Character string with the name of the file created
}
\description{
Interactive LOD curve
}
\examples{
data(hyper)
hyper <- calc.genoprob(hyper)
out <- scanone(hyper, method="hk")
\dontrun{iplotScanone(out)}
\dontshow{iplotScanone(out, openfile=FALSE)}
\dontrun{iplotScanone(out, cross=hyper)}
}

