#' Convert scanone output to json format
#'
#' @param output An object of class \code{"scanone"}, as output by \code{\link[qtl]{scanone}}.
#' @param \dots Additional arguments passed to the \code{\link[RJSONIO]{toJSON}} function
#' @return A character string with the input in JSON format.
#' @keywords interface
#' @export
#' @examples
#' data(hyper)
#' hyper <- calc.genoprob(hyper)
#' out <- scanone(hyper, method="hk")
#' out_as_json <- scanone2json(out)
scanone2json <-
function(output, ...)
{
  # marker names: replace pseudomarkers with blanks
  mnames <- rownames(output)
  pmarkers <- grep("^c.+\\.loc-*[0-9]+", mnames)
  mnames[pmarkers] <- ""

  # chromosome names
  chrnames <- as.character(unique(output[,1]))

  RJSONIO::toJSON(c(list(chrnames = chrnames), as.list(output), list(markernames = mnames)), ...)
}
