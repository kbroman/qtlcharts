\name{iplotScanone}
\alias{iplotScanone}
\title{Interactive LOD curve}
\usage{
  iplotScanone(scanoneOutput, lodcolumn = 1, cross,
    pheno.col = 1, file, onefile = FALSE, openfile = TRUE,
    title = "")
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

