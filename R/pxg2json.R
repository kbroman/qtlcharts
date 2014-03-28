## pxg2json
## Karl W Broman

# Convert genotypes and a single phenotype to JSON format
#
# Convert the genotype and phenotype data in a cross to JSON format,
# for use with interative graphics, such as \code{\link{iplotScanone}}.
# (Largely for internal use.)
#
# @param cross An object of class \code{"cross"}; see
#   \code{\link[qtl]{read.cross}}.
# @param pheno.col Phenotype column
# @param fillgenoArgs List of named arguments to pass to
#   \code{\link[qtl]{fill.geno}}, if needed.
# @param ... Additional arguments passed to the
#   \code{\link[RJSONIO]{toJSON}} function
#
# @return A character string with the input in JSON format.
#
# @details Genotypes are encoded as integers; negative integers are used to indicate imputed values.
#
#' @importFrom qtl pull.pheno markernames getsex chrnames getgenonames getid nmar
#' @importFrom RJSONIO toJSON
#
# @keywords interface
# @seealso \code{\link{scanone2json}}
#
# @examples
# data(hyper)
# pxg_as_json <- pxg2json(hyper)
pxg2json <-
function(cross, pheno.col=1, fillgenoArgs=NULL, ...)
{
  geno_filled <- getImputedGenotypes(cross, fillgenoArgs=fillgenoArgs, imputed_negative=TRUE)

  phe <- qtl::pull.pheno(cross, pheno.col)

  # marker names
  markers <- markernames(cross)

  # chr types
  sexpgm <- qtl::getsex(cross)
  chrtype <- sapply(cross$geno, class)
  names(chrtype) <- qtl::chrnames(cross)
  uchrtype <- unique(chrtype)

  # genotype names by chr types
  genonames <- vector("list", length(uchrtype))
  names(genonames) <- uchrtype
  for(i in uchrtype)
    genonames[[i]] <- qtl::getgenonames(class(cross)[1], i, "full", sexpgm, attributes(cross))

  id <- qtl::getid(cross)
  if(is.null(id)) id <- 1:nind(cross)
  id <- as.character(id)

  dimnames(geno_filled) <- NULL

  chrByMarkers <- rep(qtl::chrnames(cross), qtl::nmar(cross))
  names(chrByMarkers) <- markers

  RJSONIO::toJSON(list(geno=t(geno_filled),
                       pheno=phe,
                       chrByMarkers=chrByMarkers,
                       indID=id,
                       chrtype=chrtype,
                       genonames=genonames))
}


# get imputed genotypes, dealing specially with X chr genotypes
#' @importFrom qtl pull.geno fill.geno chrnames getsex reviseXdata
#
getImputedGenotypes <-
function(cross, fillgenoArgs=NULL, imputed_negative=TRUE)
{
  method <- grabarg(fillgenoArgs, "method", "imp")
  error.prob <- grabarg(fillgenoArgs, "error.prob", 0.0001)
  map.function <- grabarg(fillgenoArgs, "map.function", "haldane")

  # genotypes and imputed genotypes
  geno <- qtl::pull.geno(cross)
  cross_filled <- qtl::fill.geno(cross, method=method, error.prob=error.prob, map.function=map.function)
  geno_imp <- qtl::pull.geno(cross_filled)

  # on X chr, revise genotypes
  chr <- qtl::chrnames(cross)
  chrtype <- sapply(cross$geno, class)
  sexpgm <- qtl::getsex(cross)
  if(any(chrtype == "X")) {
    for(i in chr[chrtype=="X"]) {
      geno_X <- qtl::reviseXdata(class(cross)[1], "full", sexpgm, geno=qtl::pull.geno(cross, chr=i),
                                 cross.attr=attributes(cross))
      geno[,colnames(geno_X)] <- geno_X

      geno_imp_X <- qtl::reviseXdata(class(cross)[1], "full", sexpgm, geno=qtl::pull.geno(cross_filled, chr=i),
                                     cross.attr=attributes(cross))
      geno_imp[,colnames(geno_imp_X)] <- geno_imp_X
    }
  }

  if(imputed_negative) {
    # replace imputed values with negatives
    imputed <- is.na(geno) | (!is.na(geno_imp) & geno != geno_imp)
    geno_imp[imputed] <- -geno_imp[imputed]
  }

  geno_imp
}

