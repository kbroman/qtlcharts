\name{iplotPXG}
\alias{iplotPXG}
\title{Interactive phenotype x genotype plot}
\usage{
  iplotPXG(cross, marker, pheno.col = 1, file,
    onefile = FALSE, openfile = TRUE, title = "",
    method = c("imp", "argmax", "no_dbl_XO"),
    error.prob = 0.0001,
    map.function = c("haldane", "kosambi", "c-f", "morgan"),
    ...)
}
\arguments{
  \item{cross}{(Optional) Object of class \code{"cross"},
  see \code{\link[qtl]{read.cross}}.}

  \item{marker}{Character string with marker name}

  \item{pheno.col}{(Optional) Phenotype column in cross
  object.}

  \item{file}{Optional character vector with file to
  contain the output}

  \item{onefile}{If TRUE, have output file contain all
  necessary javascript/css code}

  \item{openfile}{If TRUE, open the plot in the default web
  browser}

  \item{title}{Character string with title for plot}

  \item{method}{Method for imputing missing genotypes}

  \item{error.prob}{Genotyping error probability used in
  imputing missing genotypes}

  \item{map.function}{Map function used in imputing missing
  genotypes}
}
\value{
  Character string with the name of the file created
}
\description{
  Interactive phenotype x genotype plot
}
\examples{
data(hyper)
\dontrun{iplotPXG(hyper)}
}

