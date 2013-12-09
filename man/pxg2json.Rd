\name{pxg2json}
\alias{pxg2json}
\title{Convert genotypes and a single phenotype to JSON format}
\usage{
  pxg2json(cross, pheno.col = 1,
    method = c("imp", "argmax", "no_dbl_XO"),
    error.prob = 0.0001,
    map.function = c("haldane", "kosambi", "c-f", "morgan"),
    ...)
}
\arguments{
  \item{cross}{An object of class \code{"cross"}; see
  \code{\link[qtl]{read.cross}}.}

  \item{pheno.col}{Phenotype column}

  \item{method}{Method for imputing missing genotypes}

  \item{error.prob}{Genotyping error probability used in
  imputing missing genotypes}

  \item{map.function}{Map function used in imputing missing
  genotypes}

  \item{\dots}{Additional arguments passed to the
  \code{\link[RJSONIO]{toJSON}} function}
}
\value{
  A character string with the input in JSON format.
}
\description{
  Convert genotypes and a single phenotype to JSON format
}
\details{
  Genotypes are encoded as integers; negative integers are
  used to indicate imputed values.
}
\examples{
data(hyper)
pxg_as_json <- pxg2json(hyper)
}
\keyword{interface}

