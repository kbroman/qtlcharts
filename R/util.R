## generic utilities
## Karl W Broman

# grab argument from a list
#
# for example:
#   grabarg(list(method="argmax", map.function="c-f"), "method", "imp")
grabarg <-
function(arguments, argname, default)
  ifelse(argname %in% names(arguments), arguments[[argname]], default)


# return selected phenotype columns as a character vector
getPhename <-
function(cross, pheno.col)
{
  if(is.character(pheno.col)) return(pheno.col)
  names(cross$pheno)[pheno.col]
}

# turn a selection of matrix columns into a numeric vector
selectMatrixColumns <-
function(matrix, cols)
{
  stopifnot(is.matrix(matrix))

  origcols <- cols

  if(is.character(cols)) {
    cols <- match(cols, colnames(matrix))
    if(any(is.na(cols)))
      stop("Unmatched columns: ", paste(origcols[is.na(cols)], collapse=" "))
  }

  (1:ncol(matrix))[cols]
}
