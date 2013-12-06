\name{scanone2json}
\alias{scanone2json}
\title{Convert scanone output to json format}
\usage{
  scanone2json(output, ...)
}
\arguments{
  \item{output}{An object of class \code{"scanone"}, as
  output by \code{\link[qtl]{scanone}}.}

  \item{\dots}{Additional arguments passed to the
  \code{\link[RJSONIO]{toJSON}} function}
}
\value{
  A character string with the input in JSON format.
}
\description{
  Convert scanone output to json format
}
\examples{
data(hyper)
hyper <- calc.genoprob(hyper)
out <- scanone(hyper, method="hk")
out_as_json <- scanone2json(out)
}
\keyword{interface}

