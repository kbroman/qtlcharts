\name{corr_w_scatter}
\alias{corr_w_scatter}
\title{Image of correlation matrix with linked scatterplot}
\usage{
corr_w_scatter(dat, group, reorder = TRUE, corr = cor(dat, use =
  "pairwise.complete.obs"), file, onefile = FALSE, openfile = TRUE,
  title = "Correlation matrix with linked scatterplot")
}
\arguments{
  \item{dat}{Data matrix (individuals x variables)}

  \item{group}{Option vector of groups of individuals
  (e.g., a genotype)}

  \item{reorder}{If TRUE, reorder the variables by
  clustering}

  \item{corr}{Correlation matrix (optional)}

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
Creates an interactive graph with an image of a correlation
matrix linked to underlying scatterplots.
}
\examples{
\dontrun{
data(geneExpr)
corr_w_scatter(geneExpr$expr, geneExpr$genotype)
}
}

