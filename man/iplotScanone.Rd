\name{iplotScanone}
\alias{iplotScanone}
\title{Interactive LOD curve}
\usage{
  iplotScanone(output, lodcolumn = 1, file,
    onefile = FALSE, openfile = TRUE, title = "LOD curves")
}
\arguments{
  \item{output}{Object of class \code{"scanone"}, as output
  from \code{\link[qtl]{scanone}}.}

  \item{lodcolumn}{Numeric value indicating LOD score
  column to plot}

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
}

